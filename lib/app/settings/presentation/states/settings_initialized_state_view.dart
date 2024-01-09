import 'dart:io';

import 'package:cliptopia/app/settings/domain/exclusion_entity.dart';
import 'package:cliptopia/app/settings/presentation/settings_controller.dart';
import 'package:cliptopia/app/settings/presentation/widgets/option.dart';
import 'package:cliptopia/app/welcome/presentation/widgets/feature_list.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/assets/app_artworks.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/meta_info.dart';
import 'package:cliptopia/core/database/exclusion_database.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:cliptopia/widgets/topbar/backdrop_panel.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsInitializedStateView extends StatefulWidget {
  const SettingsInitializedStateView({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  State<SettingsInitializedStateView> createState() =>
      _SettingsInitializedStateViewState();
}

class _SettingsInitializedStateViewState
    extends State<SettingsInitializedStateView>
    with SingleTickerProviderStateMixin<SettingsInitializedStateView> {
  final tabs = [
    "General",
    "Interactions",
    "Security",
    "Troubleshoot",
    "About",
  ];

  final exclusionDb = Injector.find<ExclusionDatabase>();

  late String cacheSize;
  late String cacheUnit;

  TextEditingController cacheSizeController = TextEditingController();
  late TabController tabController;

  bool showInfo = false;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    cacheSize = widget.controller.settingsRepo.getCacheSize().toString();
    cacheUnit = widget.controller.settingsRepo.getCacheUnit();
    cacheSizeController.text = cacheSize;
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentTab = tabController.index;
        });
      }
    });
  }

  Widget _getTab(String name, int index) {
    final tabStyle = AppTheme.fontSize(14);
    return Text(
      name,
      key: ValueKey("$name $currentTab $index"),
      style: currentTab == index ? tabStyle.makeBold() : tabStyle,
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
                  const Align(
                    alignment: Alignment.topCenter,
                    child: TopBar(
                      enabled: true,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: BackdropPanel(
                      filterEnabled: false,
                      searchBarEnabled: false,
                      showSearchBar: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 110.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 700,
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 36.0),
                              child: TabBar(
                                controller: tabController,
                                indicatorSize: TabBarIndicatorSize.tab,
                                onTap: (value) {
                                  setState(() {
                                    setState(() {
                                      currentTab = value;
                                    });
                                  });
                                },
                                tabs: tabs
                                    .map((e) => _getTab(e, tabs.indexOf(e)))
                                    .toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 700,
                            height: 440,
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                _buildGeneralPage(),
                                _buildInteractionsPage(),
                                _buildSecurityPage(),
                                _buildTroubleshootPage(),
                                _buildAboutPage(),
                              ],
                            ),
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

  Widget _buildGeneralPage() {
    return SizedBox(
      width: 700,
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 36,
                  right: 36,
                  bottom: 25,
                ),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.theme,
                        width: 48,
                        height: 48,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(width: 11),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose App Theme",
                            style: AppTheme.fontSize(16).makeBold(),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Chose one among \"Light\", \"Dark\" and \"System\" (under development)",
                            style: AppTheme.fontSize(14),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 80,
                              child: DropdownButton<String>(
                                items: ["Light", "Dark", "System"]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        enabled: false,
                                        value: e,
                                        child: Text(
                                          e,
                                          style:
                                              AppTheme.fontSize(14).makeBold(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: Storage.get('theme') ?? 'Light',
                                onChanged: (String? value) {
                                  setState(() {
                                    Storage.set('theme', value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Option(
                title: "App Animations",
                description:
                    "Toggle animations for motion sensitive eyes, or other problems",
                active: Storage.get(StorageKeys.animationEnabledKey,
                        fallback: StorageValues.defaultAnimationEnabledKey) ==
                    StorageValues.defaultAnimationEnabledKey,
                icon: AppIcons.animations,
                onChanged: (enabled) {
                  setState(() {
                    Storage.set(StorageKeys.animationEnabledKey, enabled);
                  });
                },
              ),
              Option(
                title: "Autostart Cliptopia Daemon",
                description:
                    "Watches the clipboard in the background, for working seamlessly",
                active: widget.controller.settingsRepo.isDaemonAutostart(),
                icon: AppIcons.launch,
                onChanged: (enabled) async {
                  await widget.controller.settingsRepo
                      .setDaemonAutostart(!enabled);
                  setState(() {});
                },
              ),
              Option(
                title: "Force use xclip instead of wl-clipboard",
                description:
                    "Uses xclip in your wayland session (e.g GNOME on UBUNTU)",
                active: widget.controller.settingsRepo.isForcingXClip(),
                icon: AppIcons.clipboard,
                enabled: Platform.environment['WAYLAND_DISPLAY'] != null,
                disableCause: "Value of \$WAYLAND_DISPLAY is not set",
                onChanged: (enabled) {
                  widget.controller.settingsRepo.setForceXClip(enabled);
                  setState(() {});
                },
              ),
              Option(
                title: "Keep Clipboard History Across Restarts",
                description:
                    "Enable this to keep your clipboard contents even after restarts",
                active: widget.controller.settingsRepo.isKeepingHistory(),
                icon: AppIcons.history,
                onChanged: (enabled) {
                  widget.controller.settingsRepo.setKeepHistory(enabled);
                  if (widget.controller.settingsRepo.isMaintainingState()) {
                    if (!enabled) {
                      Messenger.show(
                        "State Management Turned off",
                        type: MessageType.severe,
                      );
                    }
                  }
                  setState(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 36,
                  right: 36,
                  bottom: 25,
                ),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.storage,
                        width: 48,
                        height: 48,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(width: 11),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Limit Clipboard Cache Size",
                            style: AppTheme.fontSize(16).makeBold(),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Control the amount of disk space cache should occupy",
                            style: AppTheme.fontSize(14),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: cacheSizeController,
                                style: AppTheme.fontSize(14),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (num.tryParse(value) != null) {
                                    cacheSize = value;
                                    widget.controller.settingsRepo
                                        .setCacheSize(value);
                                  }
                                },
                                decoration: InputDecoration(
                                  suffix: DropdownButton<String>(
                                    items: ["KB", "MB", "GB"]
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: AppTheme.fontSize(14)
                                                  .makeBold(),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    value: cacheUnit,
                                    onChanged: (String? value) {
                                      setState(() {
                                        cacheUnit = value!;
                                        widget.controller.settingsRepo
                                            .setCacheUnit(cacheUnit);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Option(
                title: "Maintain Clipboard State",
                description:
                    "Copy the most recent item to the clipboard on system restart",
                active: widget.controller.settingsRepo.isMaintainingState(),
                enabled: widget.controller.settingsRepo.isKeepingHistory(),
                icon: AppIcons.card,
                disableCause: "Maintaining State requires History Keeping",
                onChanged: (enabled) {
                  widget.controller.settingsRepo.setMaintainState(enabled);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionsPage() {
    return SizedBox(
      width: 700,
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 15),
              child: Text(
                "App Behaviour",
                style: AppTheme.fontSize(18).makeBold(),
              ),
            ),
            Option(
              title: "Close after paste operation",
              description:
                  "This closes the app if it’s started via Super + V keyboard shortcut",
              active: Storage.get('exit-on-paste') ?? true,
              icon: AppIcons.hide,
              onChanged: (enabled) {
                setState(() {
                  Storage.set('exit-on-paste', enabled);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 15),
              child: Text(
                "Click Options",
                style: AppTheme.fontSize(18).makeBold(),
              ),
            ),
            Option(
              title: "Open media files when clicked",
              description:
                  "This, plays media in your desktop using default applications",
              active: Storage.get('open-media-on-click') ?? false,
              icon: AppIcons.images,
              onChanged: (enabled) {
                setState(() {
                  Storage.set('open-media-on-click', enabled);
                });
              },
            ),
            Option(
              title: "Copy file contents",
              description:
                  "When a text file element is clicked, its contents are copied to clipboard",
              active: Storage.get('copy-contents') ?? false,
              icon: AppIcons.copy,
              onChanged: (enabled) {
                setState(() {
                  Storage.set('copy-contents', enabled);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityPage() {
    var exclusions = exclusionDb.exclusions;
    if (exclusions.isNotEmpty) {
      exclusions.sort((a, b) => b.name.compareTo(a.name));
    }
    Widget buildTile(ExclusionEntity e) {
      return Row(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              color: AppTheme.exclusionTileNameBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              e.name,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.fontSize(14)
                  .withColor(AppTheme.exclusionTileNameForegroundColor),
            ),
          ),
          const Gap(8),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.exclusionTilePatternBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              e.pattern,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.fontSize(14)
                  .withColor(AppTheme.exclusionTilePatternForegroundColor),
            ),
          ),
        ],
      );
    }

    return StatefulBuilder(builder: (context, setModalState) {
      return SizedBox(
        width: 700,
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0, left: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Protect Clipboard Content",
                        style: AppTheme.fontSize(18).makeBold(),
                      ),
                      Text(
                        "Exclude sensitive text from being watched as per your preferences",
                        style: AppTheme.fontSize(14),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            exclusionDb.reload();
                            exclusions = exclusionDb.exclusions;
                            if (exclusions.isNotEmpty) {
                              exclusions
                                  .sort((a, b) => b.name.compareTo(a.name));
                            }
                            setModalState(() {});
                          },
                          tooltip: "Reload",
                          icon: Icon(
                            Icons.refresh,
                            color: AppTheme.foreground,
                          ),
                        ),
                        const Gap(8),
                        IconButton(
                          onPressed: () {
                            launchUrlString(
                                "file://${exclusionDb.exclusionConfig.configPath}");
                          },
                          tooltip: "Edit",
                          icon: Icon(
                            Icons.edit_note_sharp,
                            color: AppTheme.foreground,
                          ),
                        ),
                        const Gap(36),
                      ],
                    ),
                  ),
                ],
              ),
              if (exclusions.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Gap(16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...exclusions.map((e) => buildTile(e)).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              if (exclusions.isEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                      ),
                      Lottie.asset(
                        AppAnimations.shield,
                        width: 300,
                        animate: Storage.get(StorageKeys.animationEnabledKey,
                            fallback: StorageValues.defaultAnimationEnabledKey),
                      ),
                      Text(
                        "No content filter detected, looks like you also removed the default ones\nPlease note that any password or key you copy will be watched",
                        textAlign: TextAlign.center,
                        style: AppTheme.fontSize(14).makeBold(),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTroubleshootPage() {
    int issues = 0;
    dynamic setState;
    dynamic addIssue() {
      Future.delayed(
        const Duration(milliseconds: 250),
        () {
          if (setState != null) {
            setState(() {
              issues++;
            });
          }
        },
      );
      return "";
    }

    Widget buildTile(String executable, String helpFlag) {
      return SizedBox(
        height: 40,
        child: FutureBuilder(
          future: doesCommandExists(executable, helpFlag),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                  const Gap(6),
                  Text(
                    "Finding",
                    style: AppTheme.fontSize(16),
                  ),
                  Text(
                    " $executable",
                    style: AppTheme.fontSize(16).makeBold(),
                  ),
                ],
              );
            } else if (snapshot.hasError ||
                !snapshot.hasData ||
                !(snapshot.data!)) {
              addIssue();
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppIcons.incorrect,
                    width: 32,
                  ),
                  const Gap(6),
                  Text(
                    " $executable",
                    style:
                        AppTheme.fontSize(16).makeBold().withColor(Colors.red),
                  ),
                  Text(
                    " is not installed!",
                    style: AppTheme.fontSize(16),
                  ),
                ],
              );
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppIcons.correct,
                  width: 32,
                ),
                const Gap(6),
                Text(
                  " $executable",
                  style: AppTheme.fontSize(16).makeBold(),
                ),
                Text(
                  " is installed",
                  style: AppTheme.fontSize(16),
                ),
              ],
            );
          },
        ),
      );
    }

    return SizedBox(
      width: 700,
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0, left: 36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cliptopia Daemon Status",
              style: AppTheme.fontSize(18).makeBold(),
            ),
            const Gap(16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppIcons.daemon,
                  width: 30,
                  height: 30,
                ),
                const Gap(6),
                Text(
                  isDaemonAlive()
                      ? "Active"
                      : "Stopped (there is some problem in launching cliptopia-daemon)${addIssue() ?? ""}",
                  style: AppTheme.fontSize(16),
                ),
              ],
            ),
            const Gap(16),
            Text(
              "Required Command Status",
              style: AppTheme.fontSize(18).makeBold(),
            ),
            const Gap(6),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                buildTile("xclip", "-h"),
                if (Platform.environment['WAYLAND_DISPLAY'] != null) ...[
                  buildTile("wl-paste", "-h"),
                  buildTile("wl-copy", "-h"),
                ],
                buildTile("pgrep", "--help"),
                buildTile("grep", "--help"),
                buildTile("pkexec", "--help"),
                buildTile("java", "--help"),
                buildTile("whereis", "--version"),
                // buildTile("gsettings", "--version"),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36.0, vertical: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        StatefulBuilder(builder: (context, setModalState) {
                          setState = setModalState;
                          return Text(
                            issues == 0
                                ? "No Issues Found!"
                                : "$issues Issue Found!",
                            style: AppTheme.fontSize(16),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutPage() {
    return SizedBox(
      width: 700,
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppIcons.appIcon,
                      width: 64,
                    ),
                    const Gap(16),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cliptopia",
                              style: AppTheme.fontSize(26).makeBold(),
                            ),
                            Text(
                              MetaInfo.version,
                              style: AppTheme.fontSize(14).makeBold(),
                            ),
                          ],
                        ),
                        const Gap(5),
                        Text(
                          "The start-of-the-art clipboard manager (Linux)",
                          style: AppTheme.fontSize(14),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: "View Project on GitHub",
                            onPressed: () {
                              launchUrlString(
                                  "https://github.com/omegaui/cliptopia");
                            },
                            icon: Image.asset(AppIcons.github),
                          ),
                          const Gap(25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: buildFeatureList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                AppArtworks.appGradient,
                width: 700,
                height: 230,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
