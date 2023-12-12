import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/machine/background_event.dart';
import 'package:cliptopia/core/services/machine/state_machine.dart';

class CommandsState {}

class CommandsLoadingState extends CommandsState {}

class CommandsEmptyState extends CommandsState {
  EmptyCause cause;

  CommandsEmptyState(this.cause);
}

class CommandsInitializedState extends CommandsState {}

class CommandsEvent {}

class CommandsLoadingEvent extends CommandsEvent implements BackgroundEvent {
  bool fastLoad;

  CommandsLoadingEvent(this.fastLoad);

  @override
  bool shouldUpdateUI() {
    return !fastLoad;
  }
}

class CommandsEmptyEvent extends CommandsEvent {
  EmptyCause cause;

  CommandsEmptyEvent(this.cause);
}

class CommandsInitializedEvent extends CommandsEvent {}

class CommandsStateMachine extends StateMachine<CommandsState, CommandsEvent> {
  CommandsStateMachine() : super(initialState: CommandsLoadingState());

  @override
  void changeStateOnEvent(CommandsEvent e) {
    switch (e.runtimeType) {
      case CommandsLoadingEvent:
        currentState = CommandsLoadingState();
      case CommandsEmptyEvent:
        currentState = CommandsEmptyState((e as CommandsEmptyEvent).cause);
      case CommandsInitializedEvent:
        currentState = CommandsInitializedState();
    }
  }
}
