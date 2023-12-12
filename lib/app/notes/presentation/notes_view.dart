import 'package:cliptopia/app/clipboard/presentation/states/clipboard_loading_state_view.dart';
import 'package:cliptopia/app/notes/presentation/notes_controller.dart';
import 'package:cliptopia/app/notes/presentation/notes_state_machine.dart';
import 'package:cliptopia/app/notes/presentation/states/notes_empty_state_view.dart';
import 'package:cliptopia/app/notes/presentation/states/notes_initialized_state_view.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late NotesController controller;

  @override
  void initState() {
    super.initState();
    controller = NotesController(onRebuild: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case NotesLoadingState:
        controller.load();
        return const ClipboardLoadingStateView(title: "Finding Notes");
      case NotesEmptyState:
        return NotesEmptyStateView(
          controller: controller,
          cause: (currentState as NotesEmptyState).cause,
        );
      case NotesInitializedState:
        return NotesInitializedStateView(controller: controller);
      default:
        throw Exception(
            "Unrecognized State Exception: ${currentState.runtimeType}");
    }
  }
}
