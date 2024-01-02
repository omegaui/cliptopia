import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  const Option({
    super.key,
    required this.title,
    required this.description,
    required this.active,
    this.enabled = true,
    required this.icon,
    this.width = 48,
    this.height = 48,
    required this.onChanged,
    this.disableCause,
    this.noPadding = false,
  });

  final String title;
  final String? disableCause;
  final String description;
  final bool active;
  final bool enabled;
  final String icon;
  final double width;
  final double height;
  final OptionChangedCallback onChanged;
  final bool noPadding;

  @override
  Widget build(BuildContext context) {
    if (!enabled && disableCause == null) {
      throw Exception('Option is disabled but no disableCause is provided');
    }

    return Stack(
      children: [
        Align(
          child: Padding(
            padding: EdgeInsets.only(
              left: noPadding ? 0 : 36,
              right: noPadding ? 0 : 36,
              bottom: noPadding ? 0 : 25,
            ),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icon,
                    width: width,
                    height: height,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(width: 11),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.fontSize(16).makeBold(),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: AppTheme.fontSize(14).makeMedium(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Switch(
                          value: enabled && active,
                          onChanged: enabled ? onChanged : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!enabled)
          Align(
            child: Tooltip(
              message: disableCause,
              child: Container(
                height: 50,
                color: AppTheme.barrierColor,
              ),
            ),
          ),
      ],
    );
  }
}
