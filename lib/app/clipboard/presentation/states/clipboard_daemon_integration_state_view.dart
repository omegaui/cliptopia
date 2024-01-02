import 'dart:async';

import 'package:cliptopia/app/clipboard/presentation/clipboard_controller.dart';
import 'package:cliptopia/app/clipboard/presentation/widgets/download_button.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/topbar/backdrop_panel.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ClipboardDaemonIntegrationStateView extends StatefulWidget {
  const ClipboardDaemonIntegrationStateView({
    super.key,
    required this.controller,
  });

  final ClipboardController controller;

  @override
  State<ClipboardDaemonIntegrationStateView> createState() =>
      _ClipboardDaemonIntegrationStateViewState();
}

class _ClipboardDaemonIntegrationStateViewState
    extends State<ClipboardDaemonIntegrationStateView> {
  late StreamSubscription<ConnectivityResult> subscription;

  bool connected = false;
  bool downloading = false;
  bool success = false;
  bool error = false;

  @override
  void initState() {
    super.initState();
    Future(() async {
      final connectivity = Connectivity();
      connected =
          (await connectivity.checkConnectivity()) != ConnectivityResult.none;
      setState(() {});
      subscription = connectivity.onConnectivityChanged.listen((result) {
        if (result != ConnectivityResult.none) {
          if (!connected) {
            setState(() {
              connected = true;
            });
          }
        } else {
          if (connected) {
            setState(() {
              connected = false;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            child: Container(
              width: 700,
              height: 600,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(30),
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
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Image.asset(
                          AppIcons.rover,
                        ),
                        Text(
                          "Cliptopia Daemon",
                          style: AppTheme.fontSize(26).makeBold(),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          success
                              ? "Integrating Daemon (authenticating) ..."
                              : error
                                  ? "Oops!! An Error Occurred\nAutomatic Bug Report Generated."
                                  : "Download size: 5.2 MB",
                          textAlign: TextAlign.center,
                          style: AppTheme.fontSize(16),
                        ),
                        const SizedBox(height: 10),
                        if (!downloading && !success)
                          DownloadButton(
                            onPressed: () {
                              widget.controller.downloadDaemon(
                                onDownloadComplete: () {
                                  setState(() {
                                    downloading = false;
                                    success = true;
                                    widget.controller.integrateDaemon();
                                    widget.controller.reload();
                                  });
                                },
                                onError: () {
                                  setState(() {
                                    downloading = false;
                                    error = true;
                                  });
                                },
                              );
                              setState(() {
                                downloading = true;
                              });
                            },
                          ),
                        if (downloading)
                          Lottie.asset(
                            AppAnimations.downloading,
                            width: 100,
                            animate: Storage.get(
                                StorageKeys.animationEnabledKey,
                                fallback:
                                    StorageValues.defaultAnimationEnabledKey),
                          ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: TopBar(
                      enabled: false,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: BackdropPanel(
                      filterEnabled: false,
                      showSearchBar: false,
                    ),
                  ),
                  if (!connected)
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 36, bottom: 18.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info,
                              color: AppTheme.foreground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "No internet connection available",
                              style: AppTheme.fontSize(14).makeBold(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
  }
}
