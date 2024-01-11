import 'package:cliptopia/core/services/machine/state_machine.dart';

class EmojisState {}

class EmojisLoadingState extends EmojisState {}

class EmojisEmptyState extends EmojisState {}

class EmojisInitializedState extends EmojisState {}

class EmojisEvent {}

class EmojisLoadingEvent extends EmojisEvent {}

class EmojisEmptyEvent extends EmojisEvent {}

class EmojisInitializedEvent extends EmojisEvent {}

class EmojisStateMachine extends StateMachine<EmojisState, EmojisEvent> {
  EmojisStateMachine() : super(initialState: EmojisLoadingState());

  @override
  void changeStateOnEvent(EmojisEvent e) {
    switch (e.runtimeType) {
      case EmojisLoadingEvent:
        currentState = EmojisLoadingState();
        break;
      case EmojisEmptyEvent:
        currentState = EmojisEmptyState();
        break;
      case EmojisInitializedEvent:
        currentState = EmojisInitializedState();
    }
  }
}
