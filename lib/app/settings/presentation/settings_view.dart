import 'package:cliptopia/app/settings/presentation/settings_controller.dart';
import 'package:cliptopia/app/settings/presentation/settings_state_machine.dart';
import 'package:cliptopia/app/settings/presentation/states/settings_initialized_state_view.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late SettingsController controller;

  @override
  void initState() {
    super.initState();
    controller = SettingsController(
      onRebuild: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case SettingsInitializedState:
        return SettingsInitializedStateView(controller: controller);
      default:
        throw Exception(
            "Unrecognized State Exception: ${currentState.runtimeType}");
    }
  }
}
