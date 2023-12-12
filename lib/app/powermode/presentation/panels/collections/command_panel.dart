import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../widgets/command_card.dart';

class CommandPanel extends StatefulWidget {
  const CommandPanel({super.key});

  @override
  State<CommandPanel> createState() => _CommandPanelState();
}

class _CommandPanelState extends State<CommandPanel> {
  bool hover = false;
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
    PowerDataHandler.prepareCommands();
    PowerDataHandler.searchTypeChangeListeners.add(rebuild);
    PowerDataHandler.searchTextChangeListeners.add(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = PowerDataHandler.commands
        .where((e) => !e.entity.isMarkedDeleted)
        .isEmpty;
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
        margin: const EdgeInsets.only(left: 20),
        width: 520,
        height: 400,
        decoration: BoxDecoration(
          color: PowerModeTheme.panelBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: PowerModeTheme.borderColor),
          boxShadow: !hover
              ? [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(PowerModeTheme.dropShadowOpacity),
                    blurRadius: 16,
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Container(
              width: 520,
              height: 50,
              decoration: BoxDecoration(
                color: PowerModeTheme.panelTopBarColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Gap(20),
                  Image.asset(
                    AppIcons.commands,
                    width: 32,
                  ),
                  const Gap(8),
                  Text(
                    "Commands",
                    style: AppTheme.fontSize(16),
                  ),
                  const Gap(8),
                  Tag(
                    text: "Experimental",
                    message: "This view may show unexpected results.",
                    color: Colors.grey.shade700,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isEmpty)
                          IconButton(
                            onPressed: () {
                              for (var e in PowerDataHandler.commands) {
                                e.entity.markAsDeleted();
                              }
                              rebuild();
                            },
                            tooltip: "Delete All Commands",
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                          ),
                        const Gap(5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isEmpty) ...[
              Center(
                child: Lottie.asset(
                  AppAnimations.commandsEmpty,
                  width: 200,
                ),
              ),
              Text(
                "Once you copy a command,\nyou can find it here",
                textAlign: TextAlign.center,
                style: AppTheme.fontSize(14).makeMedium(),
              ),
            ],
            if (!isEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(10),
                      ...PowerDataHandler.commands
                          .where((e) =>
                              !e.entity.isMarkedDeleted &&
                              (!searchActive ||
                                  e.search(PowerDataHandler.searchText)))
                          .where((e) =>
                              !e.entity.info.sensitive ||
                              !Storage.isSensitivityOn() ||
                              TempStorage.canShowSensitiveContent())
                          .map(
                            (e) => CommandCard(
                              commandEntity: e,
                              onRebuildRequested: () {
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                      const Gap(20),
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
