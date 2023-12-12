import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  const CategoryButton({
    super.key,
    required this.active,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final bool active;
  final String tooltip;
  final String icon;
  final VoidCallback onPressed;

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
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
          curve: Curves.easeIn,
          scale: (hover && !widget.active) ? 1.4 : 1.0,
          child: Tooltip(
            message: widget.tooltip,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn,
              width: widget.active ? 48 : 32,
              height: 48,
              decoration: BoxDecoration(
                color: widget.active
                    ? AppTheme.selectedCategoryBackgroundColor
                    : AppTheme.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Image.asset(
                  widget.icon,
                  width: 32,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
