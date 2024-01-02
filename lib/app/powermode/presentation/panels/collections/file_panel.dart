import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/app/powermode/presentation/panels/widgets/file_card.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class FilePanel extends StatefulWidget {
  const FilePanel({super.key});

  @override
  State<FilePanel> createState() => _FilePanelState();
}

class _FilePanelState extends State<FilePanel> {
  bool hover = false;
  bool initialized = false;
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
    PowerDataHandler.prepareFiles(onComplete: () {
      initialized = true;
      rebuild();
      PowerDataHandler.searchTypeChangeListeners.add(rebuild);
      PowerDataHandler.searchTextChangeListeners.add(rebuild);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty =
        PowerDataHandler.files.where((e) => !e.entity.isMarkedDeleted).isEmpty;
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: getDuration(milliseconds: 250),
        curve: Curves.easeIn,
        margin: const EdgeInsets.only(left: 20),
        width: 500,
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
              width: 500,
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
                    AppIcons.folder,
                    width: 32,
                  ),
                  const Gap(8),
                  Text(
                    "Files & Folders",
                    style: AppTheme.fontSize(16),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isEmpty)
                          IconButton(
                            onPressed: () {
                              for (var e in PowerDataHandler.files) {
                                e.entity.markAsDeleted();
                              }
                              rebuild();
                            },
                            tooltip: "Remove All Files",
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
            const Gap(10),
            if (!initialized)
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (initialized) ...[
              if (isEmpty) ...[
                Center(
                  child: Lottie.asset(
                    AppAnimations.filesEmpty,
                    width: 200,
                    repeat: false,
                  ),
                ),
                Text(
                  "You can directly access a file\nAfter it has been copied",
                  textAlign: TextAlign.center,
                  style: AppTheme.fontSize(14).makeMedium(),
                ),
              ],
              if (!isEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ...PowerDataHandler.files
                            .where((e) =>
                                !e.entity.isMarkedDeleted &&
                                (!searchActive ||
                                    e.search(PowerDataHandler.searchText)))
                            .where((e) =>
                                !e.entity.info.sensitive ||
                                !Storage.isSensitivityOn() ||
                                TempStorage.canShowSensitiveContent())
                            .map(
                              (e) => FileCard(
                                fileEntity: e,
                                onRebuildRequested: () {
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
