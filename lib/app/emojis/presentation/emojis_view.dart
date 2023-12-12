import 'package:cliptopia/app/emojis/presentation/emojis_controller.dart';
import 'package:cliptopia/app/emojis/presentation/emojis_state_machine.dart';
import 'package:cliptopia/app/emojis/presentation/states/emojis_empty_state_view.dart';
import 'package:cliptopia/app/emojis/presentation/states/emojis_initialized_state_view.dart';
import 'package:cliptopia/app/emojis/presentation/states/emojis_loading_state_view.dart';
import 'package:flutter/material.dart';

class EmojisView extends StatefulWidget {
  const EmojisView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<EmojisView> createState() => _EmojisViewState();
}

class _EmojisViewState extends State<EmojisView> {
  late EmojisController controller;

  @override
  void initState() {
    super.initState();
    controller = EmojisController(onRebuild: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case EmojisLoadingState:
        controller.load();
        return const EmojisLoadingStateView();
      case EmojisEmptyState:
        return EmojisEmptyStateView(controller: controller);
      case EmojisInitializedState:
        return EmojisInitializedStateView(controller: controller);
      default:
        throw Exception(
            "Unrecognized State Exception: ${currentState.runtimeType}");
    }
  }
}
