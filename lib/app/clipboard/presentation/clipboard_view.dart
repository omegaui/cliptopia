import 'package:cliptopia/app/clipboard/presentation/clipboard_controller.dart';
import 'package:cliptopia/app/clipboard/presentation/clipboard_state_machine.dart';
import 'package:cliptopia/app/clipboard/presentation/states/clipboard_daemon_integration_state_view.dart';
import 'package:cliptopia/app/clipboard/presentation/states/clipboard_daemon_missing_state_view.dart';
import 'package:cliptopia/app/clipboard/presentation/states/clipboard_empty_state_view.dart';
import 'package:cliptopia/app/clipboard/presentation/states/clipboard_initialized_state_view.dart';
import 'package:cliptopia/app/clipboard/presentation/states/clipboard_loading_state_view.dart';
import 'package:flutter/material.dart';

class ClipboardView extends StatefulWidget {
  const ClipboardView({super.key, this.arguments});

  final dynamic arguments;

  @override
  State<ClipboardView> createState() => _ClipboardViewState();
}

class _ClipboardViewState extends State<ClipboardView> {
  late ClipboardController controller;

  @override
  void initState() {
    super.initState();
    controller = ClipboardController(onRebuild: () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case ClipboardLoadingState:
        controller.load((currentState as ClipboardLoadingState));
        return const ClipboardLoadingStateView();
      case ClipboardDaemonMissingState:
        return ClipboardDaemonMissingStateView(controller: controller);
      case ClipboardDaemonIntegrationState:
        return ClipboardDaemonIntegrationStateView(controller: controller);
      case ClipboardEmptyState:
        return ClipboardEmptyStateView(
          controller: controller,
          cause: (currentState as ClipboardEmptyState).cause,
        );
      case ClipboardInitializedState:
        return ClipboardInitializedStateView(controller: controller);
      default:
        throw Exception(
            "Unrecognized State Exception: ${currentState.runtimeType}");
    }
  }
}
