import 'package:cliptopia/app/powermode/presentation/power_mode_app.dart';
import 'package:cliptopia/app/settings/presentation/widgets/option.dart';
import 'package:cliptopia/config/assets/app_artworks.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showPowerSettings(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return const PowerModeSettings();
    },
  ).then((value) {
    appFocusNode.requestFocus();
  });
}

class PowerModeSettings extends StatefulWidget {
  const PowerModeSettings({super.key});

  @override
  State<PowerModeSettings> createState() => _PowerModeSettingsState();
}

class _PowerModeSettingsState extends State<PowerModeSettings> {
  @override
  Widget build(BuildContext context) {
    final defaultViewMode = Storage.get(StorageKeys.viewMode,
            fallback: StorageValues.defaultViewMode) ==
        StorageValues.defaultViewMode;
    final backgroundViewMode = !defaultViewMode;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: FittedBox(
          child: Container(
            width: 700,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(PowerModeTheme.dropShadowOpacity),
                  blurRadius: 48,
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, top: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppIcons.settings,
                            ),
                            const Gap(10),
                            Text(
                              "Power Mode Settings",
                              style: AppTheme.fontSize(24).makeBold(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 32.0, top: 20),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppTheme.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                Text(
                  "Choose Appearance",
                  style: AppTheme.fontSize(22),
                ),
                const Gap(25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Storage.set(StorageKeys.viewMode,
                                StorageValues.backgroundViewMode);
                            rebuildView(message: "Appearance Modified ...");
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            decoration: BoxDecoration(
                              color: backgroundViewMode
                                  ? Colors.blueAccent.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  AppArtworks.backgroundViewMode,
                                ),
                                Text(
                                  "Transparent Mode",
                                  style: AppTheme.fontSize(16).copyWith(
                                    fontWeight: backgroundViewMode
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Storage.set(StorageKeys.viewMode,
                                StorageValues.defaultViewMode);
                            rebuildView(message: "Appearance Modified ...");
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            decoration: BoxDecoration(
                              color: defaultViewMode
                                  ? Colors.blueAccent.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  AppArtworks.defaultViewMode,
                                ),
                                Text(
                                  "Barrier Mode",
                                  style: AppTheme.fontSize(16).copyWith(
                                    fontWeight: defaultViewMode
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                Option(
                  title: "Keep the images hidden until triggered",
                  description:
                      "Image Panel will be hidden by default, Use Ctrl + I to toggle its visibility",
                  active: Storage.get(StorageKeys.hideImagePanelKey,
                      fallback: false),
                  icon: AppIcons.images,
                  onChanged: (enabled) {
                    setState(() {
                      Storage.set(StorageKeys.hideImagePanelKey, enabled);
                      rebuildView(message: "Image Panel settings changed");
                    });
                  },
                ),
                Option(
                  title: "Don't show sensitive data",
                  description:
                      "Elements marked sensitive will be hidden until you press Ctrl + SHIFT + I",
                  active: Storage.isSensitivityOn(),
                  icon: AppIcons.hide,
                  onChanged: (enabled) {
                    setState(() {
                      Storage.set(StorageKeys.sensitivity, enabled);
                      rebuildView(message: "Sensitivity Enabled: $enabled");
                    });
                  },
                ),
                Option(
                  title: "Always hide emojis",
                  description:
                      "Hide all your emojis that you copied directly/indirectly",
                  active: Storage.get(StorageKeys.hideEmojiPanelKey,
                      fallback: true),
                  icon: AppIcons.emoji,
                  onChanged: (enabled) {
                    setState(() {
                      Storage.set(StorageKeys.hideEmojiPanelKey, enabled);
                      rebuildView(message: "Emoji Panel settings changed");
                    });
                  },
                ),
                Option(
                  title: "Always hide the colors panel",
                  description:
                      "This panel contains all your colors in hexadecimal notation",
                  active: Storage.get(StorageKeys.hideColorPanelKey,
                      fallback: false),
                  icon: AppIcons.drop,
                  onChanged: (enabled) {
                    setState(() {
                      Storage.set(StorageKeys.hideColorPanelKey, enabled);
                      rebuildView(message: "Colors Panel settings changed");
                    });
                  },
                ),
                Option(
                  title: "Save Date Filter Preferences",
                  description:
                      "Previous date filter is automatically applied when you press Super + V",
                  active: Storage.get(StorageKeys.saveDateFilerKey,
                      fallback: false),
                  icon: AppIcons.datePicker,
                  onChanged: (enabled) {
                    setState(() {
                      Storage.set(StorageKeys.saveDateFilerKey, enabled);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
