import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';

class CopyItemButton extends StatefulWidget {
  const CopyItemButton({
    super.key,
    required this.entity,
  });

  final ClipboardEntity entity;

  @override
  State<CopyItemButton> createState() => _CopyItemButtonState();
}

class _CopyItemButtonState extends State<CopyItemButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        copy(widget.entity);
      },
      child: MouseRegion(
        onEnter: (e) => setState(() => hover = true),
        onExit: (e) => setState(() => hover = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.copyButtonColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
              child: AnimatedScale(
                duration: getDuration(milliseconds: 250),
                curve: Curves.easeIn,
                scale: hover ? 1.2 : 1.0,
                child: AnimatedRotation(
                  duration: getDuration(milliseconds: 250),
                  curve: Curves.easeIn,
                  turns: hover ? -0.05 : 0,
                  child: Image.asset(
                    AppIcons.copy,
                    width: 24,
                    height: 24,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
