import 'package:cliptopia/app/settings/data/settings_repository.dart';
import 'package:cliptopia/app/settings/presentation/settings_state_machine.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/machine/controller.dart';

class SettingsController extends Controller<SettingsState, SettingsEvent> {
  final settingsRepo = Injector.find<SettingsRepository>();

  SettingsController({required super.onRebuild})
      : super(stateMachine: SettingsStateMachine());
}
