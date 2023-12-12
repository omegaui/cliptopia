abstract class StateMachine<State, Event> {
  State currentState;

  StateMachine({required State initialState}) : currentState = initialState;

  void changeStateOnEvent(Event e);
}
