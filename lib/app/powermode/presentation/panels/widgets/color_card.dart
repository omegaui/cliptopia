import 'package:cliptopia/app/powermode/domain/entity/color_entity.dart';
import 'package:cliptopia/app/powermode/presentation/dialogs/entity_info_dialog.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ColorCard extends StatefulWidget {
  const ColorCard({
    super.key,
    required this.colorEntity,
  });

  final ColorEntity colorEntity;

  @override
  State<ColorCard> createState() => _ColorCardState();
}

class _ColorCardState extends State<ColorCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() => hover = true);
        PowerDataHandler.hoveringOn(widget.colorEntity.entity);
      },
      onExit: (e) {
        setState(() => hover = false);
        PowerDataHandler.hoveringOn(null);
      },
      child: GestureDetector(
        onTap: () {
          EntityUtils.inject(widget.colorEntity.entity);
        },
        onSecondaryTap: () {
          showInfoDialog(
              context, widget.colorEntity.entity, "Color (Hex Code)");
        },
        child: AnimatedContainer(
          duration: getDuration(milliseconds: 250),
          curve: Curves.easeIn,
          width: 100,
          height: 32,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: PowerModeTheme.background,
            borderRadius: BorderRadius.circular(10),
            boxShadow: hover
                ? [
                    BoxShadow(
                      color: PowerModeTheme.collectionCardDropShadowColor,
                      blurRadius: 16,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: getDuration(milliseconds: 250),
                curve: Curves.easeIn,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.colorEntity.color,
                  borderRadius: BorderRadius.circular(20),
                  border: hover
                      ? Border.all(color: PowerModeTheme.cardBorderColor)
                      : null,
                ),
              ),
              const Gap(4),
              Text(
                colorToHex(widget.colorEntity.color),
                style: AppTheme.fontSize(12).makeBold(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
