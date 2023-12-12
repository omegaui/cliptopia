import 'package:cliptopia/core/services/machine/state_machine.dart';

class SettingsState {}

class SettingsInitializedState extends SettingsState {}

class SettingsEvent {}

class SettingsInitializedEvent extends SettingsEvent {}

class SettingsStateMachine extends StateMachine<SettingsState, SettingsEvent> {
  SettingsStateMachine() : super(initialState: SettingsInitializedState());

  @override
  void changeStateOnEvent(SettingsEvent e) {
    switch (e.runtimeType) {
      case SettingsInitializedEvent:
        currentState = SettingsInitializedState();
    }
  }
}
