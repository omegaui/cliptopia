import 'package:cliptopia/core/services/machine/state_machine.dart';

class PowerModeEvent {}

class PowerModeLoadedEvent extends PowerModeEvent {}

class PowerModeTextViewEvent extends PowerModeEvent {}

class PowerModeState {}

class PowerModeLoadedState extends PowerModeState {}

class PowerModeTextViewState extends PowerModeState {}

class PowerModeStateMachine
    extends StateMachine<PowerModeState, PowerModeEvent> {
  PowerModeStateMachine() : super(initialState: PowerModeLoadedState());

  @override
  void changeStateOnEvent(PowerModeEvent e) {
    switch (e.runtimeType) {
      case PowerModeLoadedEvent:
        currentState = PowerModeLoadedState();
        break;
      case PowerModeTextViewEvent:
        currentState = PowerModeTextViewState();
    }
  }
}
