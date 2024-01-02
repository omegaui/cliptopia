import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cliptopia/app/welcome/presentation/widgets/feature_list.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/meta_info.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showWelcomeDialog() {
  showGeneralDialog(
    context: RouteService.navigatorKey.currentContext!,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    transitionDuration: getDuration(seconds: 1),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: MoveWindow(
          onDoubleTap: () {
            // this will prevent maximize operation
          },
          child: Stack(
            children: [
              Align(
                child: FittedBox(
                  child: StatefulBuilder(builder: (context, setState) {
                    return Container(
                      width: 500,
                      height: 300,
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.windowDropShadowColor,
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                ),
                                iconSize: 28,
                                onPressed: () {
                                  Navigator.pop(context);
                                  Storage.set('version', MetaInfo.version);
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Welcome to ",
                                        style: AppTheme.fontSize(24),
                                      ),
                                      Text(
                                        "Cliptopia",
                                        style: AppTheme.fontSize(24).makeBold(),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "The state-of-the-art clipboard manager",
                                    style: AppTheme.fontSize(16),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Features",
                                    style: AppTheme.fontSize(18).makeBold(),
                                  ),
                                  const SizedBox(height: 10),
                                  buildFeatureList(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          launchUrlString(
                                              'https://github.com/omegaui/cliptopia/releases/latest');
                                        },
                                        child: Tag(
                                          text: MetaInfo.version,
                                          message:
                                              "See What's NEW in this version",
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
