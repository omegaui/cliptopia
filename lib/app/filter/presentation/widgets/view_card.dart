import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class ViewCard extends StatefulWidget {
  const ViewCard({
    super.key,
    required this.text,
    required this.icon,
    required this.active,
    required this.onPressed,
  });

  final String text;
  final String icon;
  final bool active;
  final VoidCallback onPressed;

  @override
  State<ViewCard> createState() => _ViewCardState();
}

class _ViewCardState extends State<ViewCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate,
          scale: hover ? 0.9 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            height: 30,
            decoration: BoxDecoration(
              color: widget.active
                  ? AppTheme.integrateButtonSurfaceColor
                  : AppTheme.buttonSurfaceColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 3,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    widget.icon,
                    width: 24,
                    height: 24,
                  ),
                  Text(
                    widget.text,
                    style: AppTheme.fontSize(12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
