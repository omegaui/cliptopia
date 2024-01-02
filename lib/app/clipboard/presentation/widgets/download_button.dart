import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:flutter/material.dart';

class DownloadButton extends StatefulWidget {
  const DownloadButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  bool hover = false;

  void onMouseEnter(e) {
    setState(() => hover = true);
  }

  void onMouseExit(e) {
    setState(() => hover = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onMouseEnter,
      onExit: onMouseExit,
      child: Tooltip(
        message: "Click to Download the Daemon",
        child: GestureDetector(
          onTap: () {
            widget.onPressed();
          },
          child: AnimatedContainer(
            duration: getDuration(milliseconds: 250),
            curve: Curves.decelerate,
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.integrateButtonSurfaceColor,
              borderRadius: BorderRadius.circular(hover ? 15 : 30),
            ),
            child: Center(
              child: Text(
                'Download',
                style: AppTheme.fontSize(16).makeBold(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
