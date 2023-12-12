import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/app/filter/presentation/dialog/filter_dialog.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key, this.enabled = true});

  final bool enabled;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool hover = false;
  final filterRepo = Injector.find<FilterRepository>();

  void onMouseEnter(e) {
    if (widget.enabled) {
      setState(() => hover = true);
    }
  }

  void onMouseExit(e) {
    if (widget.enabled) {
      setState(() => hover = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onMouseEnter,
      onExit: onMouseExit,
      child: GestureDetector(
        onTap: () {
          if (widget.enabled) {
            showFilterDialog();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (filterRepo.activeFilter != Filter.defaultFilter)
                ? AppTheme.filterActiveColor
                : AppTheme.buttonSurfaceColor,
            borderRadius: BorderRadius.circular(hover ? 15 : 30),
          ),
          child: Center(
            child: Image.asset(
              AppIcons.filter,
              width: 32,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}
