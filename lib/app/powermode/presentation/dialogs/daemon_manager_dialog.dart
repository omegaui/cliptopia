// ignore_for_file: use_build_context_synchronously

import 'package:cliptopia/app/clipboard/data/clipboard_repository.dart';
import 'package:cliptopia/app/powermode/presentation/states/power_mode_loaded_state_view.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class DaemonManagerDialog extends StatefulWidget {
  const DaemonManagerDialog({super.key});

  @override
  State<DaemonManagerDialog> createState() => _DaemonManagerDialogState();
}

class _DaemonManagerDialogState extends State<DaemonManagerDialog> {
  bool isIntegrated = false;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    isIntegrated = Injector.find<ClipboardRepository>().isDaemonIntegrated();
    isRunning = isDaemonAlive();
  }

  Widget _buildDownloadView(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          AppAnimations.downloading,
          width: 300,
          animate: Storage.get(StorageKeys.animationEnabledKey,
              fallback: StorageValues.defaultAnimationEnabledKey),
        ),
        Text(
          "Downloading Cliptopia Daemon",
          style: AppTheme.fontSize(18).makeMedium(),
        ),
        Text(
          "Please make sure your network allows downloading raw artifacts from GitHub or else you would be stuck in this screen for a very long time",
          textAlign: TextAlign.center,
          style: AppTheme.fontSize(16).makeMedium(),
        ),
      ],
    );
  }

  Widget _buildIntegrationView(BuildContext context) {
    bool download = false;
    bool downloadFinish = false;
    bool downloadError = false;
    bool finish = false;
    return StatefulBuilder(builder: (context, setModalState) {
      if (finish) {
        return Column(
          children: [
            Image.asset(
              AppIcons.rover,
            ),
            Text(
              "Daemon is installed and running",
              style: AppTheme.fontSize(20).makeMedium(),
            ),
            Text(
              "Please restart the app",
              style: AppTheme.fontSize(18).makeMedium(),
            ),
          ],
        );
      }
      if (downloadFinish) {
        return Column(
          children: [
            Image.asset(
              AppIcons.rover,
            ),
            Text(
              downloadError
                  ? "An Error Occurred Downloading Cliptopia Daemon"
                  : "Downloaded Cliptopia Daemon Successfully",
              style: AppTheme.fontSize(18).makeMedium(),
            ),
            const Gap(15),
            if (!downloadError)
              GestureDetector(
                onTap: () async {
                  Injector.find<ClipboardRepository>().integrateDaemon();
                  await Injector.find<ClipboardRepository>()
                      .startDaemonIfNotRunning();
                  setModalState(() {
                    finish = true;
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.videoFilterBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Integrate",
                      style: AppTheme.fontSize(18)
                          .withColor(AppTheme.videoFilterForegroundColor),
                    ),
                  ),
                ),
              ),
          ],
        );
      }
      return download
          ? _buildDownloadView(context)
          : Column(
              children: [
                Image.asset(
                  AppIcons.rover,
                ),
                Text(
                  "Just Approxiamately 5 MB in size",
                  style: AppTheme.fontSize(18).makeMedium(),
                ),
                const Gap(30),
                GestureDetector(
                  onTap: () async {
                    setModalState(() {
                      download = true;
                    });

                    Injector.find<ClipboardRepository>().downloadDaemon(
                      onDownloadComplete: () {
                        setModalState(() {
                          downloadFinish = true;
                        });
                      },
                      onError: () {
                        setModalState(() {
                          downloadFinish = true;
                          downloadError = true;
                        });
                      },
                    );
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.videoFilterBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        "Download",
                        style: AppTheme.fontSize(18)
                            .withColor(AppTheme.videoFilterForegroundColor),
                      ),
                    ),
                  ),
                ),
              ],
            );
    });
  }

  Widget _buildView(BuildContext context) {
    if (!isIntegrated) {
      bool integrate = false;
      return StatefulBuilder(builder: (context, setModalState) {
        return integrate
            ? _buildIntegrationView(context)
            : Column(
                children: [
                  Lottie.asset(
                    AppAnimations.connection,
                    width: 250,
                    animate: Storage.get(StorageKeys.animationEnabledKey,
                        fallback: StorageValues.defaultAnimationEnabledKey),
                  ),
                  Text(
                    "Please integrate the Cliptopia Daemon",
                    style: AppTheme.fontSize(20).makeMedium(),
                  ),
                  Text(
                    "Without it, Cliptopia won't able to watch your clipboard",
                    style: AppTheme.fontSize(16).makeMedium(),
                  ),
                  const Gap(10),
                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        integrate = true;
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.audioFilterBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "Integrate",
                          style: AppTheme.fontSize(18)
                              .withColor(AppTheme.audioFilterForegroundColor),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      });
    } else if (!isRunning) {
      return Column(
        children: [
          Lottie.asset(
            AppAnimations.sleeping,
            width: 250,
            filterQuality: FilterQuality.high,
            animate: Storage.get(StorageKeys.animationEnabledKey,
                fallback: StorageValues.defaultAnimationEnabledKey),
          ),
          Text(
            "Looks like your cliptopia-daemon is not running",
            style: AppTheme.fontSize(20).makeMedium(),
          ),
          Text(
            "Please click start daemon and restart the app",
            style: AppTheme.fontSize(16).makeMedium(),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  await Injector.find<ClipboardRepository>()
                      .startDaemonIfNotRunning();
                  rebuildView(message: "Cliptopia Daemon started ...");
                  Navigator.pop(context);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.audioFilterBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Start Daemon",
                      style: AppTheme.fontSize(18)
                          .withColor(AppTheme.audioFilterForegroundColor),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Storage.set(
                      StorageKeys.dontShowDaemonSleepingDialogKey, true);
                  rebuildView(
                      message: "Cliptopia Daemon Manager Discarded ...");
                  Navigator.pop(context);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.videoFilterBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Don't Show Again",
                      style: AppTheme.fontSize(18)
                          .withColor(AppTheme.videoFilterForegroundColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return SizedBox(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.restart_alt,
              size: 48,
            ),
            const Gap(5),
            Text(
              "Please restart the app",
              style: AppTheme.fontSize(20).makeMedium(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 600,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(PowerModeTheme.dropShadowOpacity),
                blurRadius: 48,
              ),
            ],
          ),
          padding: const EdgeInsets.all(25),
          child: _buildView(context),
        ),
      ),
    );
  }
}

showDaemonManagerDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return const DaemonManagerDialog();
    },
  );
}
