// ignore_for_file: prefer_const_constructors

import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/app/powermode/presentation/panels/collection_panel.dart';
import 'package:cliptopia/app/powermode/presentation/panels/colors_panel.dart';
import 'package:cliptopia/app/powermode/presentation/panels/emoji_panel.dart';
import 'package:cliptopia/app/powermode/presentation/panels/images_panel.dart';
import 'package:cliptopia/app/powermode/presentation/panels/search_panel.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/app_session.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/route_service.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/main.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../core/powermode/power_data_store.dart';

final appFocusNode = FocusNode();

dynamic _appState;

void rebuildView({required String message}) {
  if (_appState != null) {
    prettyLog(value: "Rebuilding View: Reason -> $message");
    _appState();
  }
}

class PowerModeApp extends StatefulWidget {
  const PowerModeApp({super.key});

  @override
  State<PowerModeApp> createState() => _PowerModeAppState();
}

class _PowerModeAppState extends State<PowerModeApp> {
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() {
    Future(
      () {
        FlutterView view =
            WidgetsBinding.instance.platformDispatcher.views.first;
        Size size = view.physicalSize;
        windowSize = size;
        PowerDataStore.init();
        PowerDataHandler.searchTypeChangeListeners.add(() {
          rebuild();
        });
        Injector.init(
          onRebuild: () {},
          onFinished: () {
            initialized = true;
            rebuild();
          },
        );
      },
    );
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildInitializingView() {
    return Container(
      decoration: BoxDecoration(
        color: PowerModeTheme.background,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppIcons.appIcon,
            ),
            Gap(30),
            Material(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  "Reading your clipboard storage ...",
                  style: AppTheme.fontSize(16),
                ),
              ),
            ),
            Gap(20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      return _buildInitializingView();
    }
    _appState = rebuild;
    final defaultViewMode = Storage.get(StorageKeys.viewMode,
            fallback: StorageValues.defaultViewMode) ==
        StorageValues.defaultViewMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cliptopia (Power Mode)",
      themeMode: AppTheme.mode,
      navigatorKey: RouteService.navigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        tooltipTheme: TooltipThemeData(
          waitDuration: const Duration(seconds: 1),
          textStyle: AppTheme.fontSize(14)
              .makeMedium()
              .withColor(PowerModeTheme.background),
        ),
      ),
      home: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () =>
              Injector.find<AppSession>().endSession(),
          const SingleActivator(LogicalKeyboardKey.keyI, control: true): () {
            if (Storage.get(StorageKeys.hideImagePanelKey, fallback: false)) {
              TempStorage.toggle(StorageKeys.hideImagePanelKey,
                  fallback: false);
              rebuild();
            }
          },
          const SingleActivator(LogicalKeyboardKey.keyI,
              control: true, shift: true): () {
            if (Storage.isSensitivityOn()) {
              TempStorage.set(StorageKeys.sensitivity,
                  !TempStorage.canShowSensitiveContent());
              rebuild();
            }
          },
          const SingleActivator(LogicalKeyboardKey.keyT, alt: true): () {
            PowerDataHandler.searchTypeUpdate(PowerSearchType.Text);
            rebuild();
          },
          const SingleActivator(LogicalKeyboardKey.keyR, alt: true): () {
            PowerDataHandler.searchTypeUpdate(PowerSearchType.Regex);
            rebuild();
          },
          const SingleActivator(LogicalKeyboardKey.keyI, alt: true): () {
            PowerDataHandler.searchTypeUpdate(PowerSearchType.Image);
            rebuild();
          },
          const SingleActivator(LogicalKeyboardKey.keyC, alt: true): () {
            PowerDataHandler.searchTypeUpdate(PowerSearchType.Comment);
            rebuild();
          },
        },
        child: Focus(
          focusNode: appFocusNode,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {
                appFocusNode.requestFocus();
              },
              child: Container(
                color: defaultViewMode
                    ? PowerModeTheme.barrier
                    : Colors.transparent,
                child: Stack(
                  children: [
                    Align(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SearchPanel(),
                          if (!Storage.get(StorageKeys.hideImagePanelKey,
                                  fallback: false) ||
                              !TempStorage.get(StorageKeys.hideImagePanelKey,
                                  fallback: true)) ...[
                            const Gap(25),
                            ImagesPanel(),
                          ],
                          if (PowerDataHandler.searchType !=
                              PowerSearchType.Image) ...[
                            if (!Storage.get(StorageKeys.hideColorPanelKey,
                                fallback: false)) ...[
                              const Gap(25),
                              ColorsPanel(),
                            ],
                            if (!Storage.get(StorageKeys.hideEmojiPanelKey,
                                fallback: true)) ...[
                              const Gap(25),
                              EmojiPanel(),
                            ],
                            const Gap(25),
                            CollectionPanel(),
                            const Gap(35),
                          ],
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: MessageBird.create(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
