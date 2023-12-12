import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/machine/background_event.dart';
import 'package:cliptopia/core/services/machine/state_machine.dart';

class ClipboardState {}

class ClipboardLoadingState extends ClipboardState {
  bool fastLoad;

  ClipboardLoadingState(this.fastLoad);
}

class ClipboardDaemonMissingState extends ClipboardState {}

class ClipboardDaemonIntegrationState extends ClipboardState {}

class ClipboardEmptyState extends ClipboardState {
  EmptyCause cause;

  ClipboardEmptyState(this.cause);
}

class ClipboardInitializedState extends ClipboardState {}

class ClipboardUpdateState extends ClipboardState {}

class ClipboardEvent {}

class ClipboardLoadingEvent extends ClipboardEvent implements BackgroundEvent {
  bool fastLoad;

  ClipboardLoadingEvent(this.fastLoad);

  @override
  bool shouldUpdateUI() {
    return !fastLoad;
  }
}

class ClipboardDaemonMissingEvent extends ClipboardEvent {}

class ClipboardDaemonIntegrationEvent extends ClipboardEvent {}

class ClipboardEmptyEvent extends ClipboardEvent {
  EmptyCause cause;

  ClipboardEmptyEvent(this.cause);
}

class ClipboardInitializedEvent extends ClipboardEvent {}

class ClipboardUpdateEvent extends ClipboardEvent {}

class ClipboardStateMachine
    extends StateMachine<ClipboardState, ClipboardEvent> {
  ClipboardStateMachine() : super(initialState: ClipboardLoadingState(false));

  @override
  void changeStateOnEvent(ClipboardEvent e) {
    switch (e.runtimeType) {
      case ClipboardLoadingEvent:
        currentState =
            ClipboardLoadingState((e as ClipboardLoadingEvent).fastLoad);
      case ClipboardDaemonMissingEvent:
        currentState = ClipboardDaemonMissingState();
      case ClipboardDaemonIntegrationEvent:
        currentState = ClipboardDaemonIntegrationState();
      case ClipboardEmptyEvent:
        currentState = ClipboardEmptyState((e as ClipboardEmptyEvent).cause);
      case ClipboardInitializedEvent:
        currentState = ClipboardInitializedState();
      case ClipboardUpdateEvent:
        currentState = ClipboardUpdateState();
    }
  }
}
