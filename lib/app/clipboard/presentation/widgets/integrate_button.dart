import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class IntegrateButton extends StatefulWidget {
  const IntegrateButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<IntegrateButton> createState() => _IntegrateButtonState();
}

class _IntegrateButtonState extends State<IntegrateButton> {
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
        message: "Start Integration",
        child: GestureDetector(
          onTap: () {
            widget.onPressed();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.integrateButtonSurfaceColor,
              borderRadius: BorderRadius.circular(hover ? 15 : 30),
            ),
            child: Center(
              child: Text(
                'Integrate',
                style: AppTheme.fontSize(16).makeBold(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
