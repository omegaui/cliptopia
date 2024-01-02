import 'package:cliptopia/app/filter/presentation/widgets/filter_dialog_button.dart';
import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilter extends StatefulWidget {
  const DateFilter({super.key});

  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  final defaultDate = DateRange(
    startDate: DateTime.now().subtract(const Duration(days: 6)),
    endDate: DateTime.now(),
  );

  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showFilterSelectionBottomSheet,
      child: MouseRegion(
        onEnter: (e) => setState(() => hover = true),
        onExit: (e) => setState(() => hover = false),
        child: AnimatedContainer(
          duration: getDuration(milliseconds: 250),
          curve: Curves.easeIn,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: hover
                ? PowerModeTheme.dateFilterHoverBackgroundColor
                : PowerModeTheme.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                convertDateFilterToText(PowerDataHandler.dateFilterType),
                style: AppTheme.fontSize(14)
                    .withColor(PowerModeTheme.dateFilterTextColor)
                    .makeMedium(),
              ),
              const Gap(8),
              Image.asset(
                AppIcons.datePicker,
                width: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showFilterSelectionBottomSheet() {
    bool customState =
        PowerDataHandler.dateFilterType == PowerDateFilterType.custom;
    void handleOnChanged(value, setModalState, [date]) {
      if (value == null) {
        setModalState(() {
          customState = false;
        });
      } else if (value != PowerDateFilterType.custom) {
        Navigator.pop(context);
        setState(() {
          PowerDataHandler.useDate(value);
        });
      } else if (date == null) {
        setModalState(() {
          customState = true;
        });
      } else {
        Navigator.pop(context);
        setState(() {
          PowerDataHandler.useDate(value, date);
        });
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: PowerModeTheme.background,
      showDragHandle: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return SizedBox(
          width: 500,
          height: 400,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: FittedBox(
                child: Container(
                  width: 500,
                  height: 450,
                  decoration: BoxDecoration(
                    color: PowerModeTheme.background,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(PowerModeTheme.dropShadowOpacity),
                        blurRadius: 48,
                      )
                    ],
                  ),
                  child: StatefulBuilder(builder: (context, setModalState) {
                    if (customState) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Select a date range",
                                style: AppTheme.fontSize(18).makeBold(),
                              ),
                            ),
                            SfDateRangePicker(
                              selectionMode: DateRangePickerSelectionMode.range,
                              initialSelectedRange: PickerDateRange(
                                PowerDataHandler.date.startDate ??
                                    DateTime.now(),
                                PowerDataHandler.date.endDate ?? DateTime.now(),
                              ),
                              onSelectionChanged: (args) {
                                if (args.value is PickerDateRange) {
                                  PowerDataHandler.date = DateRange(
                                    startDate: args.value.startDate,
                                    endDate: args.value.endDate,
                                  );
                                }
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilterDialogButton(
                                  text: "Other Filters",
                                  onPressed: () {
                                    handleOnChanged(null, setModalState);
                                  },
                                ),
                                const SizedBox(width: 10),
                                FilterDialogButton(
                                  text: "Reset",
                                  onPressed: () {
                                    PowerDataHandler.date = defaultDate;
                                    handleOnChanged(PowerDateFilterType.custom,
                                        setModalState, PowerDataHandler.date);
                                  },
                                ),
                                const SizedBox(width: 10),
                                FilterDialogButton(
                                  text: "Select",
                                  onPressed: () {
                                    handleOnChanged(PowerDateFilterType.custom,
                                        setModalState, PowerDataHandler.date);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListView(
                        children: PowerDateFilterType.values.map((e) {
                          return Material(
                            child: InkWell(
                              child: RadioListTile(
                                value: e,
                                groupValue: PowerDataHandler.dateFilterType,
                                onChanged: (value) =>
                                    handleOnChanged(value, setModalState),
                                title: Text(
                                  convertDateFilterToText(e),
                                  style: AppTheme.fontSize(16),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
