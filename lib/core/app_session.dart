import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum SessionState {
  dirty,
  clean,
}

class AppSession {
  final List<AppSessionCallback> _listeners = [];
  final RebuildCallback onRebuild;

  AppSession({required this.onRebuild});

  SessionState _state = SessionState.clean;

  bool get isClean => _state == SessionState.clean;

  void addListener(AppSessionCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(AppSessionCallback listener) {
    _listeners.remove(listener);
  }

  void setSessionState(SessionState state) {
    _state = state;
    prettyLog(value: ">> Notifying ${_listeners.length} App Session Listeners");
    for (var listener in _listeners) {
      listener();
    }
  }

  void endSession() {
    if (RouteService.navigatorKey.currentContext != null) {
      Navigator.pop(RouteService.navigatorKey.currentContext!);
    }
    SystemNavigator.pop();
    appWindow.close();
  }
}
