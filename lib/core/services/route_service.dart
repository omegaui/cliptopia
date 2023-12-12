import 'package:cliptopia/app/clipboard/presentation/clipboard_view.dart';
import 'package:cliptopia/app/commands/presentation/commands_view.dart';
import 'package:cliptopia/app/emojis/presentation/emojis_view.dart';
import 'package:cliptopia/app/notes/presentation/notes_view.dart';
import 'package:cliptopia/app/settings/presentation/settings_view.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:flutter/material.dart';

class RouteService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const clipboardRoute = 'clipboard';
  static const emojisRoute = 'emojis';
  static const notesRoute = 'notes';
  static const commandsRoute = 'commands';
  static const settingsRoute = 'settings';

  final RebuildCallback onRebuild;

  RouteService.withState({required this.onRebuild});

  final Route unrecognizedRoute = Route(
      name: "unrecognized-route",
      builder: (arguments) {
        return const SizedBox();
      });

  String currentRoute = clipboardRoute;

  final routes = [
    Route(
      name: clipboardRoute,
      builder: (arguments) => ClipboardView(
        arguments: arguments,
      ),
    ),
    Route(
      name: notesRoute,
      builder: (arguments) => NotesView(
        arguments: arguments,
      ),
    ),
    Route(
      name: commandsRoute,
      builder: (arguments) => CommandsView(
        arguments: arguments,
      ),
    ),
    Route(
      name: emojisRoute,
      builder: (arguments) => EmojisView(
        arguments: arguments,
      ),
    ),
    Route(
      name: settingsRoute,
      builder: (arguments) => SettingsView(
        arguments: arguments,
      ),
    ),
  ];

  Route _getRoute(String name) {
    for (var route in routes) {
      if (route.name == name) {
        return route;
      }
    }
    return unrecognizedRoute;
  }

  void gotoRoute(String route, {dynamic arguments, bool isReload = false}) {
    if (!isReload && currentRoute == route) {
      return;
    }
    currentRoute = route;
    _getRoute(currentRoute).arguments = arguments;
    prettyLog(value: "Going to $currentRoute route ...");
    onRebuild();
  }

  Route getCurrentRoute() {
    return _getRoute(currentRoute);
  }
}

class Route {
  String name;
  dynamic arguments;
  Widget Function(dynamic) builder;

  Route({
    required this.name,
    this.arguments,
    required this.builder,
  });

  Widget getView() {
    return builder(arguments);
  }
}
