import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity_info.dart';
import 'package:cliptopia/core/powermode/entity_info_data_store.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';

class PowerDataStore {
  PowerDataStore._();

  static final List<ClipboardEntity> _entities = [];

  static List<ClipboardEntity> get entities =>
      List<ClipboardEntity>.from(_entities);

  static void init() {
    EntityInfoStore.init();
    final cacheStore = JsonConfigurator(configName: 'cache/clipboard.json');
    final objects = cacheStore.get('cache');
    if (objects != null && objects.isNotEmpty) {
      for (final obj in objects) {
        _entities.add(ClipboardEntity.fromMap(obj));
      }
    }
    if (_entities.isNotEmpty) {
      _entities.sort((a, b) => b.time.compareTo(a.time));
      // Assigning each entity its respective comment
      void assignComment(ClipboardEntity entity) {
        final comments =
            EntityInfoStore.infos.where((e) => e.refID == entity.id);
        if (comments.isNotEmpty) {
          entity.info = comments.first;
        } else {
          entity.info = EntityInfo("", entity.id, false);
          EntityInfoStore.infos.add(entity.info);
        }
      }

      for (final entity in _entities) {
        assignComment(entity);
      }
    }
    PowerDataHandler.init();
  }
}
