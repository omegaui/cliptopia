import 'dart:io';

import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:thread/thread.dart';

/// Watches cache maintained by the daemon
class ClipboardEngine {
  ClipboardEngine();

  late Thread thread;
  final database = Injector.find<Database>();
  JsonConfigurator? _clipboardCacheReader;

  void start({onStarted}) async {
    final cacheFile = File(
        combineHomePath(['.config', 'cliptopia', 'cache', 'clipboard.json']));
    bool synced = false;
    if (cacheFile.existsSync()) {
      _clipboardCacheReader = JsonConfigurator(
          configName: combinePath(['cache', 'clipboard.json']));
      List<dynamic> entityMaps = _clipboardCacheReader!.get('cache') ?? [];
      if (entityMaps.isNotEmpty) {
        List<ClipboardEntity> entities =
            entityMaps.map((e) => ClipboardEntity.fromMap(e)).toList();
        await database.addAll(entities);
        onStarted();
        synced = true;
      }
    }
    thread = Thread((events) {
      events.on('watch', (_) async {
        while (true) {
          await Future.delayed(const Duration(seconds: 1));
          if (_clipboardCacheReader == null) {
            if (cacheFile.existsSync()) {
              _clipboardCacheReader = JsonConfigurator(
                  configName: combinePath(['cache', 'clipboard.json']));
            } else {
              continue;
            }
          }
          _clipboardCacheReader!.reload();
          List<dynamic> entityMaps = _clipboardCacheReader!.get('cache') ?? [];
          if (entityMaps.isNotEmpty) {
            List<ClipboardEntity> entities =
                entityMaps.map((e) => ClipboardEntity.fromMap(e)).toList();
            events.emit('receive-event', entities);
          }
        }
      });
    });
    thread.on('receive-event', (List<ClipboardEntity> entities) async {
      await database.addAll(entities);
    });
    await thread.emit('watch');
    if (!synced) {
      onStarted();
    }
  }

  void stop() {
    thread.stop();
  }
}
