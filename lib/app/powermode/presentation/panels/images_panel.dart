import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/app/powermode/presentation/panels/widgets/image_card.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class ImagesPanel extends StatefulWidget {
  const ImagesPanel({super.key});

  @override
  State<ImagesPanel> createState() => _ImagesPanelState();
}

class _ImagesPanelState extends State<ImagesPanel> {
  bool initialized = false;

  bool searchActive = false;

  void rebuild() {
    searchActive = PowerDataHandler.searchType == PowerSearchType.Image ||
        PowerDataHandler.searchType == PowerSearchType.Comment;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    Future(
      () async {
        await PowerDataHandler.prepareImages();
        PowerDataHandler.dateFilterChangeListeners.add(rebuild);
        PowerDataHandler.searchTypeChangeListeners.add(rebuild);
        PowerDataHandler.searchTextChangeListeners.add(rebuild);
        setState(() {
          initialized = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty =
        PowerDataHandler.images.where((e) => !e.entity.isMarkedDeleted).isEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150),
      width: windowSize.width,
      height: PowerDataHandler.searchType == PowerSearchType.Image
          ? windowSize.height - 275
          : 213,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Text(
                  "Images",
                  style: AppTheme.fontSize(16),
                ),
                const Gap(16),
                ...PowerImageFilterType.values.map((e) {
                  final active = PowerDataHandler.imageFilterType == e;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        PowerDataHandler.imageFilterType = e;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: getDuration(milliseconds: 250),
                        curve: Curves.easeIn,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: active
                              ? PowerModeTheme.activeImageFilterBackgroundColor
                              : PowerModeTheme
                                  .inActiveImageFilterBackgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: PowerModeTheme.cardDropShadowColor,
                                    blurRadius: 16,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          convertImageFilterToText(e),
                          style: AppTheme.fontSize(14)
                              .copyWith(
                                color: active
                                    ? PowerModeTheme.activeImageFilterTextColor
                                    : PowerModeTheme
                                        .inActiveImageFilterTextColor,
                              )
                              .makeMedium(),
                        ),
                      ),
                    ),
                  );
                }),
                const Gap(10),
                Text(
                  "Show Images from files",
                  style: AppTheme.fontSize(16).makeMedium(),
                ),
                const Gap(4),
                Switch(
                  value: Storage.get('show-images-from-files') ?? false,
                  onChanged: (value) {
                    Storage.set('show-images-from-files', value);
                    rebuild();
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          for (var e in PowerDataHandler.images) {
                            e.entity.markAsDeleted();
                          }
                          rebuild();
                        },
                        tooltip: "Delete All Images",
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
          if (initialized) ...[
            if (isEmpty) ...[
              Center(
                child: Lottie.asset(
                  AppAnimations.imagesEmpty,
                  width: 175,
                  repeat: false,
                ),
              ),
            ],
            if (!isEmpty)
              SingleChildScrollView(
                scrollDirection:
                    PowerDataHandler.searchType == PowerSearchType.Image
                        ? Axis.vertical
                        : Axis.horizontal,
                child: Wrap(
                  children: [
                    const Gap(16),
                    ...PowerDataHandler.images
                        .where((e) {
                          return !e.entity.isMarkedDeleted &&
                              (PowerDataHandler.imageFilterType ==
                                      PowerImageFilterType.all ||
                                  e.imageFilterType ==
                                      PowerDataHandler.imageFilterType) &&
                              (!searchActive ||
                                  e.search(PowerDataHandler.searchText));
                        })
                        .where((e) =>
                            !e.entity.info.sensitive ||
                            !Storage.isSensitivityOn() ||
                            TempStorage.canShowSensitiveContent())
                        .map((e) => ImageCard(
                              imageEntity: e,
                              onRebuildRequested: () {
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            )),
                    const Gap(16),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
