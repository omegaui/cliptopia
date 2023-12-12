import 'dart:io';

import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/utils.dart';

import '../../app/clipboard/domain/entity/clipboard_entity.dart';
import '../../constants/typedefs.dart';

class Database {
  final List<DatabaseWatcher> _watchers = [];
  final List<ClipboardEntity> _entities = [];

  // to prevent change-reflection, a clone of the original list is released out
  List<ClipboardEntity> get entities {
    final result = List<ClipboardEntity>.from(_entities);
    result.removeWhere((e) => e.isMarkedDeleted);
    return result;
  }

  Database();

  final _now = DateTime.now();

  bool get isEmpty => getCount() == 0;

  bool get isNotEmpty => getCount() != 0;

  bool hasEntities(ClipboardEntityType type) {
    return _entities.any((entity) => entity.type == type);
  }

  void _filterCorrupt() {
    _entities.removeWhere((entity) {
      if (entity.type == ClipboardEntityType.text) {
        return false;
      }
      bool isDirectory = FileSystemEntity.isDirectorySync(entity.data);
      bool exists = isDirectory
          ? Directory(entity.data).existsSync()
          : File(entity.data).existsSync();
      if (!exists) {
        prettyLog(
            value:
                "Removing ${entity.data} from cache ... ${!File(entity.data).existsSync()}");
      }
      return !exists;
    });
  }

  List<ClipboardEntity> getEntities({required DateRange range, type}) {
    if (!range.isCustom()) {
      range = DateRange(
        startDate: DateTime.fromMicrosecondsSinceEpoch(1),
        endDate: _now,
      );
    }
    _filterCorrupt();
    List<ClipboardEntity> results = [];
    for (final entity in _entities) {
      if (type != null && entity.type != type) {
        continue;
      }
      if (entity.time.isBetween(range)) {
        results.add(entity);
      }
    }
    results.sort((a, b) => b.time.compareTo(a.time));
    results.removeWhere((e) => e.isMarkedDeleted);
    return results;
  }

  int getCount() {
    return _entities.length;
  }

  Future<void> addAll(List<ClipboardEntity> entities) async {
    bool gotOnce = false;
    for (final entity in entities) {
      bool result = await add(entity, signal: false);
      if (!gotOnce && result) {
        gotOnce = true;
      }
    }
    if (gotOnce) {
      _signal();
    }
  }

  Future<bool> add(ClipboardEntity entity, {signal = true}) async {
    for (final currentEntity in _entities) {
      if (currentEntity == entity) {
        return false;
      }
    }
    if (entity.type != ClipboardEntityType.text) {
      bool isDirectory = FileSystemEntity.isDirectorySync(entity.data);
      bool exists = isDirectory
          ? Directory(entity.data).existsSync()
          : File(entity.data).existsSync();
      bool isEmptyImage = false;
      if (entity.type == ClipboardEntityType.image) {
        if (exists) {
          final imageFile = File(entity.data);
          isEmptyImage = imageFile.lengthSync() == 0 ||
              !(await isImageValid(imageFile.readAsBytesSync()));
        }
      }
      if (!exists || isEmptyImage) {
        return false;
      }
    }
    prettyLog(value: "Adding ${entity.type.name} to database ...");
    _entities.add(entity);
    if (signal) {
      _signal(type: entity.type);
    }
    return true;
  }

  void _signal({type}) {
    if (type == null) {
      for (final watcher in _watchers) {
        if (!watcher.isDisposed()) {
          watcher.watch(entities);
        }
      }
    } else {
      for (final watcher in _watchers) {
        if (!watcher.isDisposed() && watcher.listensTo(type)) {
          watcher.watch(entities);
        }
      }
    }
  }

  void addWatcher(DatabaseWatcher watcher) {
    _watchers.add(watcher);
    if (watcher.forceCall) {
      watcher.watch(entities);
    }
  }
}
