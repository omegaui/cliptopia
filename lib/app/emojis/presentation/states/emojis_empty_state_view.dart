import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/emojis/presentation/emojis_controller.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmojisEmptyStateView extends StatefulWidget {
  const EmojisEmptyStateView({
    super.key,
    required this.controller,
  });

  final EmojisController controller;

  @override
  State<EmojisEmptyStateView> createState() => _EmojisEmptyStateViewState();
}

class _EmojisEmptyStateViewState extends State<EmojisEmptyStateView> {
  @override
  void initState() {
    super.initState();
    Injector.find<Database>().addWatcher(
      DatabaseWatcher.temp(
        onEvent: (_) {
          widget.controller.reload();
        },
        filters: [ClipboardEntityType.text],
        forceCall: false,
      ),
    );
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
                    child: SizedBox(
                      width: 250,
                      child: Lottie.asset(
                        AppAnimations.emojis,
                        fit: BoxFit.fitWidth,
                        animate: Storage.get(StorageKeys.animationEnabledKey,
                            fallback: StorageValues.defaultAnimationEnabledKey),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: TopBar(
                      enabled: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 130.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "No Emojis in your clipboard",
                            textAlign: TextAlign.center,
                            style: AppTheme.fontSize(20).makeBold(),
                          ),
                          Text(
                            "Once you copy an emoji, it will appear here.",
                            style: AppTheme.fontSize(16),
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
