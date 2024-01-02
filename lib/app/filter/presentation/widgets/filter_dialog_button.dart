import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:flutter/material.dart';

class FilterDialogButton extends StatefulWidget {
  const FilterDialogButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  State<FilterDialogButton> createState() => _FilterDialogButtonState();
}

class _FilterDialogButtonState extends State<FilterDialogButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedScale(
          duration: getDuration(milliseconds: 250),
          curve: Curves.decelerate,
          scale: hover ? 0.9 : 1.0,
          child: AnimatedContainer(
            duration: getDuration(milliseconds: 500),
            curve: Curves.decelerate,
            height: 35,
            decoration: BoxDecoration(
              color: AppTheme.buttonSurfaceColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: AppTheme.fontSize(14).makeBold(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
