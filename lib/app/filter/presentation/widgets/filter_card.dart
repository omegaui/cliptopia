import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:flutter/material.dart';

class FilterCard extends StatefulWidget {
  const FilterCard({
    super.key,
    required this.text,
    required this.active,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final String text;
  final bool active;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          widget.onPressed();
        },
        child: AnimatedScale(
          duration: getDuration(milliseconds: 250),
          curve: Curves.decelerate,
          scale: hover ? 0.9 : 1.0,
          child: AnimatedContainer(
            duration: getDuration(milliseconds: 250),
            curve: Curves.decelerate,
            height: 30,
            decoration: BoxDecoration(
              color: widget.active ? AppTheme.foreground : widget.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                widget.text,
                style: AppTheme.fontSize(12).makeBold().copyWith(
                    color: widget.active
                        ? AppTheme.background
                        : widget.foreground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
