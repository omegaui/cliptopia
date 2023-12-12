import 'dart:io';

import 'package:cliptopia/app/powermode/domain/entity/commentable.dart';
import 'package:cliptopia/core/parser.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:cliptopia/core/utils.dart';

final _userRemovables = JsonConfigurator(
    configName: combinePath(['cache', 'user-removables.json']));

class ClipboardEntity with Commentable {
  String id;
  dynamic data;
  DateTime time;
  ClipboardEntityType type;
  bool _deleted = false;

  bool get isMarkedDeleted => _deleted;

  ClipboardEntity(this.id, this.data, this.time, this.type);

  void markAsDeleted() {
    _deleted = true;
    _userRemovables.add('removables', id);
    if (type == ClipboardEntityType.image) {
      File(data).deleteSync();
    }
  }

  static ClipboardEntity fromMap(Map<String, dynamic> data) {
    return ClipboardEntity(
      data['id'],
      data['data'],
      DateTime.parse(data['time']),
      Parser.parseClipboardEntityType(
        data['type'],
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is ClipboardEntity) {
      return other.data == data;
    }
    return super == other;
  }

  @override
  int get hashCode =>
      super.hashCode ^ data.hashCode ^ time.hashCode ^ type.hashCode;
}

enum ClipboardEntityType { text, image, path }
