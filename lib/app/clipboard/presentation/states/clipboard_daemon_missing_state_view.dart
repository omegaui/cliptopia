import 'package:cliptopia/app/clipboard/presentation/clipboard_controller.dart';
import 'package:cliptopia/app/clipboard/presentation/widgets/integrate_button.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/topbar/backdrop_panel.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';

class ClipboardDaemonMissingStateView extends StatelessWidget {
  const ClipboardDaemonMissingStateView({
    super.key,
    required this.controller,
  });

  final ClipboardController controller;

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
                        const SizedBox(height: 200),
                        Image.asset(
                          AppIcons.charge,
                          width: 128,
                        ),
                        Text(
                          "Cliptopia Daemon is Missing",
                          style: AppTheme.fontSize(26).makeBold(),
                        ),
                        Text(
                          "Please integrate the daemon to use Cliptopia",
                          style: AppTheme.fontSize(16),
                        ),
                        const SizedBox(height: 20),
                        IntegrateButton(
                          onPressed: () {
                            controller.triggerDaemonIntegrationEvent();
                          },
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
                            "Daemon is required to watch the system clipboard",
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
