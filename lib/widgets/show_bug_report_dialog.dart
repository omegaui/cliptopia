import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/app_bug_report.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

bool _visible = false;

void showBugReports() {
  if (_visible || RouteService.navigatorKey.currentContext == null) {
    return;
  }
  _visible = true;
  prettyLog(value: ">> Showing Bug Report Dialog");
  showDialog(
    context: RouteService.navigatorKey.currentContext!,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: MoveWindow(
          onDoubleTap: () {
            // this will prevent maximize operation
          },
          child: Align(
            child: FittedBox(
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(20),
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
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcons.bug,
                            ),
                            Text(
                              "Error Occurred",
                              style: AppTheme.fontSize(18)
                                  .makeBold()
                                  .withColor(Colors.red),
                            ),
                            Text(
                              "Automatic Bug Report Generated",
                              style: AppTheme.fontSize(14),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Click to view the",
                                  style: AppTheme.fontSize(14).makeItalic(),
                                ),
                                const SizedBox(width: 2),
                                linkText(
                                  text: "Bug Report",
                                  url: getBugReportPath(
                                      AppBugReport.reportIDs.last),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Please upload the bug report",
                                  style: AppTheme.fontSize(14),
                                ),
                                const SizedBox(width: 2),
                                linkText(
                                  text: "here",
                                  url:
                                      'https://github.com/omegaui/cliptopia/issues/new',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: () {
                                _visible = false;
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: AppTheme.foreground,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    _visible = false;
  });
}

Widget linkText({required String text, required String url}) {
  bool hover = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return MouseRegion(
        onEnter: (event) => setState(() => hover = true),
        onExit: (event) => setState(() => hover = false),
        child: GestureDetector(
          onTap: () {
            launchUrlString(url);
            prettyLog(
              value: url,
              type: DebugType.url,
            );
          },
          child: AnimatedSwitcher(
            duration: getDuration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: hover
                ? Text(
                    text,
                    key: const ValueKey("hover"),
                    style: AppTheme.fontSize(14)
                        .withColor(Colors.green)
                        .makeBold(),
                  )
                : Text(
                    text,
                    key: const ValueKey("normal"),
                    style: AppTheme.fontSize(14)
                        .withColor(Colors.blue)
                        .makeBold()
                        .makeItalic(),
                  ),
          ),
        ),
      );
    },
  );
}
