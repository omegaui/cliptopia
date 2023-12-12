import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/app/filter/presentation/dialog/date_range_picker_dialog.dart';
import 'package:cliptopia/app/filter/presentation/widgets/filter_card.dart';
import 'package:cliptopia/app/filter/presentation/widgets/filter_dialog_close_button.dart';
import 'package:cliptopia/app/filter/presentation/widgets/view_card.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showFilterDialog() {
  final filterRepo = Injector.find<FilterRepository>();

  final editingController = TextEditingController(
      text: filterRepo.activeFilter.pattern.runtimeType != BuiltinFilterPattern
          ? filterRepo.activeFilter.pattern
          : "");

  VoidCallback? onRebuild;
  void rebuild() {
    if (onRebuild != null) {
      editingController.text =
          (filterRepo.activeFilter.pattern.runtimeType != BuiltinFilterPattern
              ? filterRepo.activeFilter.pattern
              : "");
      onRebuild!();
    }
  }

  final watcher = FilterWatcher(onEvent: (filter) => rebuild());

  filterRepo.addWatcher(watcher);

  showDialog(
    context: RouteService.navigatorKey.currentContext!,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              child: Container(
                width: 700,
                height: 600,
                decoration: BoxDecoration(
                  color: AppTheme.barrierColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: StatefulBuilder(builder: (context, setState) {
                    onRebuild = () {
                      setState(() {});
                    };
                    return Container(
                      width: 378,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.windowDropShadowColor,
                            blurRadius: 16,
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 23, top: 21),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Available Filters",
                                        style: AppTheme.fontSize(14).makeBold(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 7),
                                  Wrap(
                                    spacing: 6,
                                    children: [
                                      FilterCard(
                                        text: "IMG",
                                        active:
                                            filterRepo.activeFilter.pattern ==
                                                BuiltinFilterPattern.image,
                                        background:
                                            AppTheme.imageFilterBackgroundColor,
                                        foreground:
                                            AppTheme.imageFilterForegroundColor,
                                        onPressed: filterRepo.useImageFilter,
                                      ),
                                      FilterCard(
                                        text: "VIDEO",
                                        active:
                                            filterRepo.activeFilter.pattern ==
                                                BuiltinFilterPattern.video,
                                        background:
                                            AppTheme.videoFilterBackgroundColor,
                                        foreground:
                                            AppTheme.videoFilterForegroundColor,
                                        onPressed: filterRepo.useVideoFilter,
                                      ),
                                      FilterCard(
                                        text: "AUDIO",
                                        active:
                                            filterRepo.activeFilter.pattern ==
                                                BuiltinFilterPattern.audio,
                                        background:
                                            AppTheme.audioFilterBackgroundColor,
                                        foreground:
                                            AppTheme.audioFilterForegroundColor,
                                        onPressed: filterRepo.useAudioFilter,
                                      ),
                                      FilterCard(
                                        text: "FILES",
                                        active:
                                            filterRepo.activeFilter.pattern ==
                                                BuiltinFilterPattern.files,
                                        background:
                                            AppTheme.filesFilterBackgroundColor,
                                        foreground:
                                            AppTheme.filesFilterForegroundColor,
                                        onPressed: filterRepo.useFilesFilter,
                                      ),
                                      FilterCard(
                                        text: "NONE",
                                        active:
                                            filterRepo.activeFilter.pattern ==
                                                BuiltinFilterPattern.none,
                                        background: AppTheme.background,
                                        foreground: AppTheme.foreground,
                                        onPressed: filterRepo.clearPattern,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: Image.asset(
                                          AppIcons.filter,
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width: 200,
                                        height: 35,
                                        child: TextField(
                                          controller: editingController,
                                          style: AppTheme.fontSize(13),
                                          onChanged: (value) {
                                            filterRepo
                                                .createFilterFromCustomPattern(
                                                    value);
                                          },
                                          decoration: InputDecoration(
                                            hintText:
                                                "Apply a custom filter ...",
                                            hintStyle:
                                                AppTheme.fontSize(13).copyWith(
                                              color: AppTheme.hintColor,
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppTheme.hintColor,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppTheme.hintColor,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: AppTheme.hintColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text(
                                        "View Mode",
                                        style: AppTheme.fontSize(14).makeBold(),
                                      ),
                                      const SizedBox(width: 92),
                                      Text(
                                        "Filter by Date",
                                        style: AppTheme.fontSize(14).makeBold(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      ViewCard(
                                        text: "Tiles",
                                        icon: AppIcons.tile,
                                        active:
                                            filterRepo.activeFilter.viewMode ==
                                                ViewMode.tiles,
                                        onPressed: filterRepo.useTileMode,
                                      ),
                                      const SizedBox(width: 7),
                                      ViewCard(
                                        text: "List",
                                        icon: AppIcons.list,
                                        active:
                                            filterRepo.activeFilter.viewMode ==
                                                ViewMode.list,
                                        onPressed: filterRepo.useListMode,
                                      ),
                                      const SizedBox(width: 24),
                                      ViewCard(
                                        text: filterRepo.activeFilter.dateRange
                                                .isCustom()
                                            ? "Custom"
                                            : "All Time",
                                        icon: AppIcons.datePicker,
                                        active: filterRepo
                                            .activeFilter.dateRange
                                            .isCustom(),
                                        onPressed: () async {
                                          DateRange range =
                                              filterRepo.activeFilter.dateRange;
                                          range =
                                              await showDateRangePickerDialog(
                                                  initialRange: range);
                                          prettyLog(
                                              value:
                                                  "Setting DateRange: ${DateFormat("EEE, MMM d, ''yy").format(range.startDate ?? DateTime.now())} - ${DateFormat("EEE, MMM d, ''yy").format(range.endDate ?? DateTime.now())}");
                                          filterRepo.useDateRange(range);
                                        },
                                      ),
                                      if (filterRepo.activeFilter.dateRange
                                          .isCustom())
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: FilterCard(
                                            text: "NONE",
                                            active: filterRepo
                                                    .activeFilter.pattern ==
                                                BuiltinFilterPattern.none,
                                            background: AppTheme.background,
                                            foreground: AppTheme.foreground,
                                            onPressed:
                                                filterRepo.clearDateRange,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 19.0, top: 16.0),
                              child: FilterDialogCloseButton(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topRight,
              child: AppCloseButton(),
            ),
          ],
        ),
      );
    },
  ).then((value) {
    onRebuild = null;
    watcher.dispose();
  });
}
