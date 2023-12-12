import 'package:cliptopia/app/powermode/domain/entity_info.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:cliptopia/core/utils.dart';

class EntityInfoStore {
  static final _commentStorage =
      JsonConfigurator(configName: combinePath(['cache', 'entity-infos.json']));

  static final List<EntityInfo> infos = [];

  static void init() {
    final objects = _commentStorage.get('infos');
    if (objects != null && objects.isNotEmpty) {
      for (final info in objects) {
        infos.add(EntityInfo(
            info['comment'], info['refID'], info['sensitive'] ?? false));
      }
    }
  }

  static void update() {
    final info = EntityInfoStore.infos.where((e) => e.isNotEmpty);
    _commentStorage.put('infos', [
      ...info.map((e) => e.toMap()),
    ]);
  }
}
