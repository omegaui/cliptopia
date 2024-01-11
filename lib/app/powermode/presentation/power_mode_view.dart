import 'package:cliptopia/app/powermode/presentation/power_mode_controller.dart';
import 'package:cliptopia/app/powermode/presentation/power_mode_state_machine.dart';
import 'package:cliptopia/app/powermode/presentation/states/power_mode_loaded_state_view.dart';
import 'package:cliptopia/app/powermode/presentation/states/power_mode_text_view_state_view.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:flutter/material.dart';

class PowerModeView extends StatefulWidget {
  const PowerModeView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<PowerModeView> createState() => _PowerModeViewState();
}

class _PowerModeViewState extends State<PowerModeView> {
  late PowerModeController controller;

  @override
  void initState() {
    super.initState();
    controller = PowerModeController(onRebuild: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cliptopia (Power Mode)",
      themeMode: AppTheme.mode,
      navigatorKey: RouteService.navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        tooltipTheme: TooltipThemeData(
          waitDuration: const Duration(seconds: 1),
          textStyle: AppTheme.fontSize(14)
              .makeMedium()
              .withColor(PowerModeTheme.background),
        ),
      ),
      home: _buildState(),
    );
  }

  Widget _buildState() {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case PowerModeLoadedState:
        return PowerModeLoadedStateView(controller: controller);
      case PowerModeTextViewState:
        return PowerModeTextViewStateView(controller: controller);
      default:
        throw Exception(
            "Unrecognized State Exception: ${currentState.runtimeType}");
    }
  }
}
