import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmojisLoadingStateView extends StatelessWidget {
  const EmojisLoadingStateView({super.key});

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
                    child: Lottie.asset(
                      AppAnimations.emojis,
                      width: 200,
                      reverse: true,
                      animate: Storage.get(StorageKeys.animationEnabledKey,
                          fallback: StorageValues.defaultAnimationEnabledKey),
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
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Cliptopia",
                            style: AppTheme.fontSize(26).makeBold(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Identifying Emojis in Clipboard Cache",
                            style: AppTheme.fontSize(16),
                          ),
                          const SizedBox(height: 20),
                          const CircularProgressIndicator(
                            color: Color(0xFFFF7639),
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
