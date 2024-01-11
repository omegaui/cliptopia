import 'package:cliptopia/app/powermode/presentation/power_mode_state_machine.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/machine/controller.dart';

class PowerModeController extends Controller<PowerModeState, PowerModeEvent> {
  PowerModeController({required RebuildCallback onRebuild})
      : super(onRebuild: onRebuild, stateMachine: PowerModeStateMachine());

  void gotoHomeView() {
    onEvent(PowerModeLoadedEvent());
  }

  void gotoTextView() {
    onEvent(PowerModeTextViewEvent());
  }
}
