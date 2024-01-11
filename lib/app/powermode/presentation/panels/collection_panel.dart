// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cliptopia/app/powermode/presentation/panels/collections/command_panel.dart';
import 'package:cliptopia/app/powermode/presentation/panels/collections/file_panel.dart';
import 'package:cliptopia/app/powermode/presentation/panels/collections/text_panel.dart';
import 'package:cliptopia/app/powermode/presentation/power_mode_controller.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/main.dart';
import 'package:flutter/material.dart';

class CollectionPanel extends StatefulWidget {
  const CollectionPanel({
    super.key,
    required this.controller,
  });

  final PowerModeController controller;

  @override
  State<CollectionPanel> createState() => _CollectionPanelState();
}

class _CollectionPanelState extends State<CollectionPanel> {
  @override
  void initState() {
    super.initState();
    PowerDataHandler.prepareTexts();
    PowerDataHandler.dateFilterChangeListeners.add(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150),
      width: windowSize.width,
      height: 450,
      decoration: BoxDecoration(
        color: PowerModeTheme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PowerModeTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(PowerModeTheme.dropShadowOpacity),
            blurRadius: 48,
          )
        ],
      ),
      child: Row(
        children: [
          TextPanel(controller: widget.controller),
          CommandPanel(),
          FilePanel(),
        ],
      ),
    );
  }
}
