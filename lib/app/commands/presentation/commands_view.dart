import 'package:cliptopia/app/clipboard/presentation/states/clipboard_loading_state_view.dart';
import 'package:cliptopia/app/commands/presentation/commands_controller.dart';
import 'package:cliptopia/app/commands/presentation/commands_state_machine.dart';
import 'package:cliptopia/app/commands/presentation/states/commands_empty_state_view.dart';
import 'package:cliptopia/app/commands/presentation/states/commands_initialized_state_view.dart';
import 'package:flutter/material.dart';

class CommandsView extends StatefulWidget {
  const CommandsView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<CommandsView> createState() => _CommandsViewState();
}

class _CommandsViewState extends State<CommandsView> {
  late CommandsController controller;

  @override
  void initState() {
    super.initState();
    controller = CommandsController(onRebuild: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case CommandsLoadingState:
        controller.load();
        return const ClipboardLoadingStateView(title: "Finding Commands");
      case CommandsEmptyState:
        return CommandsEmptyStateView(
          controller: controller,
          cause: (currentState as CommandsEmptyState).cause,
        );
      case CommandsInitializedState:
        return CommandsInitializedStateView(controller: controller);
      default:
        throw Exception(
            "Unrecognized State Exception: ${currentState.runtimeType}");
    }
  }
}
