import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class FilterDialogCloseButton extends StatelessWidget {
  const FilterDialogCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: AppTheme.filterDialogCloseButtonColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Center(
            child: Icon(
              Icons.close,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
