import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/machine/background_event.dart';
import 'package:cliptopia/core/services/machine/state_machine.dart';

class NotesState {}

class NotesLoadingState extends NotesState {}

class NotesEmptyState extends NotesState {
  EmptyCause cause;

  NotesEmptyState(this.cause);
}

class NotesInitializedState extends NotesState {}

class NotesEvent {}

class NotesLoadingEvent extends NotesEvent implements BackgroundEvent {
  bool fastLoad;

  NotesLoadingEvent(this.fastLoad);

  @override
  bool shouldUpdateUI() {
    return !fastLoad;
  }
}

class NotesEmptyEvent extends NotesEvent {
  EmptyCause cause;

  NotesEmptyEvent(this.cause);
}

class NotesInitializedEvent extends NotesEvent {}

class NotesStateMachine extends StateMachine<NotesState, NotesEvent> {
  NotesStateMachine() : super(initialState: NotesLoadingState());

  @override
  void changeStateOnEvent(NotesEvent e) {
    switch (e.runtimeType) {
      case NotesLoadingEvent:
        currentState = NotesLoadingState();
        break;
      case NotesEmptyEvent:
        currentState = NotesEmptyState((e as NotesEmptyEvent).cause);
        break;
      case NotesInitializedEvent:
        currentState = NotesInitializedState();
    }
  }
}
