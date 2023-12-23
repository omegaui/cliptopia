import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cliptopia/app/powermode/presentation/power_mode_app.dart';
import 'package:cliptopia/app/welcome/presentation/welcome_dialog.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/meta_info.dart';
import 'package:cliptopia/constants/usage.dart';
import 'package:cliptopia/core/app_bug_report.dart';
import 'package:cliptopia/core/argument_handler.dart';
import 'package:cliptopia/core/clipboard_engine.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:flutter/material.dart';

const normalSize = Size(750, 650);

var windowSize = normalSize;

void main(List<String> arguments) {
  runZonedGuarded(() {
    ArgumentHandler.init(arguments);
    if (!ArgumentHandler.validate()) {
      final unknownOptions = ArgumentHandler.getUnknownOptions();
      if (unknownOptions.isNotEmpty) {
        stdout.writeln("Incorrect Usage: ${unknownOptions.join(" ")}");
      }
      Usage.logUsage(describe: false);
      return;
    }

    if (ArgumentHandler.shouldShowHelp()) {
      Usage.logUsage();
      return;
    }

    if (ArgumentHandler.shouldShowVersion()) {
      stdout.writeln("Cliptopia version ${MetaInfo.version}");
      return;
    }

    if (ArgumentHandler.shouldShowDaemonCompatibleVersion()) {
      stdout.writeln(
          "Compatible Cliptopia Daemon version ${MetaInfo.daemonCompatibleVersion}");
      return;
    }

    WidgetsFlutterBinding.ensureInitialized();

    // Initializing App Storage
    Storage.initSpace();

    // Initializing Themes
    AppTheme.init();

    if (ArgumentHandler.isPowerMode()) {
      PowerModeTheme.init();
      return runApp(const PowerModeApp());
    }

    return runApp(const App());
  }, (error, stackTrace) {
    AppBugReport.createZoneReport(error: error, stackTrace: stackTrace);
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late RouteService routeService;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    // Injecting Dependencies
    Injector.init(
      onRebuild: () {
        // triggering widget rebuild
        setState(() {});
      },
      onFinished: () {
        // Starting Clipboard Engine
        Injector.find<ClipboardEngine>().start(
          onStarted: () {
            setState(() {
              initialized = true;
            });
            if (Storage.get('version') != MetaInfo.version) {
              showWelcomeDialog();
            }
          },
        );
        // Finding Route Service
        routeService = Injector.find<RouteService>();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: routeService.currentRoute,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppTheme.tooltipBackgroundColor,
            border: Border.all(color: AppTheme.tooltipBorderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppTheme.fontSize(14).makeBold(),
          waitDuration: const Duration(seconds: 1),
        ),
      ),
      home: initialized
          ? SizedBox.fromSize(
              size: windowSize,
              child: MoveWindow(
                onDoubleTap: () {
                  // this will prevent maximize operation
                },
                child: Stack(
                  children: [
                    Align(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchInCurve: Curves.ease,
                        switchOutCurve: Curves.ease,
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: const Offset(0, 0),
                            ).animate(animation),
                            child:
                                ScaleTransition(scale: animation, child: child),
                          );
                        },
                        child: routeService.getCurrentRoute().getView(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: MessageBird.create(),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
      navigatorKey: RouteService.navigatorKey,
    );
  }
}
