import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/services/machine/background_event.dart';
import 'package:cliptopia/core/services/machine/state_machine.dart';
import 'package:flutter/material.dart';

class Controller<State, Event> {
  final RebuildCallback onRebuild;
  final StateMachine<State, Event> stateMachine;

  Event? _recentEvent;

  Controller({required this.onRebuild, required this.stateMachine});

  void onEvent(Event e) {
    if (_recentEvent.runtimeType == e.runtimeType) {
      return;
    }
    prettyLog(value: ">> Firing Event -> ${e.runtimeType}");
    _recentEvent = e;
    stateMachine.changeStateOnEvent(e);
    if (e is BackgroundEvent) {
      if (!e.shouldUpdateUI()) {
        return;
      }
    }
    refreshUI();
  }

  State getCurrentState() {
    return stateMachine.currentState;
  }

  void refreshUI() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onRebuild();
    });
  }
}
