import 'package:cliptopia/app/settings/domain/exclusion_entity.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';

class ExclusionDatabase {
  final exclusionConfig = JsonConfigurator(configName: 'exclusion-config.json');

  final List<ExclusionEntity> _exclusions = [];

  List<ExclusionEntity> get exclusions =>
      List<ExclusionEntity>.from(_exclusions);

  ExclusionDatabase() {
    reload();
  }

  void reload() {
    _exclusions.clear();
    exclusionConfig.reload();
    final objects = exclusionConfig.get('exclusions');
    if (objects != null && objects.isNotEmpty) {
      for (final object in objects) {
        _exclusions.add(
            ExclusionEntity(name: object['name'], pattern: object['pattern']));
      }
    }
  }

  void add(ExclusionEntity entity) {
    _exclusions.add(entity);
    exclusionConfig.add('exclusions', entity.toMap());
  }

  void remove(ExclusionEntity entity) {
    exclusionConfig.remove('exclusions', entity.toMap());
  }
}
