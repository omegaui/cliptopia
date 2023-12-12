import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/app/powermode/presentation/panels/widgets/color_card.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ColorsPanel extends StatefulWidget {
  const ColorsPanel({super.key});

  @override
  State<ColorsPanel> createState() => _ColorsPanelState();
}

class _ColorsPanelState extends State<ColorsPanel> {
  bool searchActive = false;

  void rebuild() {
    searchActive = PowerDataHandler.searchType != PowerSearchType.Image;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    PowerDataHandler.prepareColors();
    PowerDataHandler.dateFilterChangeListeners.add(rebuild);
    PowerDataHandler.searchTypeChangeListeners.add(rebuild);
    PowerDataHandler.searchTextChangeListeners.add(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150),
      width: windowSize.width,
      height: 60,
      decoration: BoxDecoration(
        color: PowerModeTheme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: PowerModeTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(PowerModeTheme.dropShadowOpacity),
            blurRadius: 48,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          children: [
            Text(
              "Colors",
              style: AppTheme.fontSize(16),
            ),
            const Gap(7),
            if (PowerDataHandler.colors.isEmpty)
              Text(
                "(No Color objects in your clipboard found.)",
                style: AppTheme.fontSize(14).makeMedium(),
              ),
            if (PowerDataHandler.colors.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    children: [
                      const Gap(7),
                      ...PowerDataHandler.colors
                          .where((e) =>
                              !searchActive ||
                              e.search(PowerDataHandler.searchText))
                          .where((e) =>
                              !e.entity.info.sensitive ||
                              !Storage.isSensitivityOn() ||
                              TempStorage.canShowSensitiveContent())
                          .map((e) => ColorCard(colorEntity: e)),
                      const Gap(14),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
