import 'package:cliptopia/app/filter/presentation/widgets/filter_dialog_button.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Future<DateRange> showDateRangePickerDialog({initialRange, context}) async {
  DateRange dateRange = initialRange;
  await showDialog(
    context: context ?? RouteService.navigatorKey.currentContext!,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: 750,
          height: 650,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Container(
              width: 400,
              height: 400,
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
              child: Padding(
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
                        dateRange.startDate ?? DateTime.now(),
                        dateRange.endDate ?? DateTime.now(),
                      ),
                      onSelectionChanged: (args) {
                        if (args.value is PickerDateRange) {
                          dateRange = DateRange(
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
                          text: "Cancel",
                          onPressed: () {
                            dateRange = initialRange;
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 10),
                        FilterDialogButton(
                          text: "Select",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
  return dateRange;
}
