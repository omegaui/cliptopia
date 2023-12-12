import 'package:cliptopia/app/clipboard/presentation/clipboard_controller.dart';
import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/search_engine.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/topbar/backdrop_panel.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ClipboardEmptyStateView extends StatefulWidget {
  const ClipboardEmptyStateView({
    super.key,
    required this.controller,
    required this.cause,
  });

  final ClipboardController controller;
  final EmptyCause cause;

  @override
  State<ClipboardEmptyStateView> createState() =>
      _ClipboardEmptyStateViewState();
}

class _ClipboardEmptyStateViewState extends State<ClipboardEmptyStateView> {
  FilterWatcher? filterWatcher;

  @override
  void initState() {
    super.initState();
    debugPrint(widget.cause.toString());
    if (widget.cause == EmptyCause.noInitialElements) {
      Injector.find<Database>().addWatcher(
        DatabaseWatcher.temp(
          onEvent: (_) {
            widget.controller.reload();
          },
        ),
      );
    } else if (widget.cause == EmptyCause.noElementsOnSearch) {
      SearchEngine.primary.onEvent = (text) {
        if (mounted) {
          widget.controller.reload(fastLoad: true);
        }
      };
    } else if (widget.cause == EmptyCause.noElementsOnFilter ||
        widget.cause == EmptyCause.noImageElements ||
        widget.cause == EmptyCause.noAudioElements ||
        widget.cause == EmptyCause.noVideoElements ||
        widget.cause == EmptyCause.noFileElements ||
        widget.cause == EmptyCause.noElementsOnDate) {
      filterWatcher = FilterWatcher(onEvent: (filter) {
        widget.controller.reload(fastLoad: true);
      });
      Injector.find<FilterRepository>().addWatcher(filterWatcher!);
    }
  }

  @override
  void dispose() {
    if (filterWatcher != null) {
      filterWatcher!.dispose();
    }
    super.dispose();
  }

  String getClipboardEmptyText(EmptyCause cause) {
    switch (cause) {
      case EmptyCause.noInitialElements:
        return "Clipboard is Empty";
      case EmptyCause.noElementsOnDate:
        return "Try Another Date";
      case EmptyCause.noElementsOnFilter:
        return "Try Another Filter";
      case EmptyCause.noElementsOnSearch:
        return "No Matches";
      case EmptyCause.noImageElements:
        return "There are no Image Elements in your clipboard";
      case EmptyCause.noAudioElements:
        return "There are no Audio Elements in your clipboard";
      case EmptyCause.noVideoElements:
        return "There are no Video Elements in your clipboard";
      case EmptyCause.noNoteElements:
        return "There are no Note Elements in your clipboard";
      case EmptyCause.noFileElements:
        return "There are no File Elements in your clipboard";
      default:
        return "";
    }
  }

  String getSubTitle(EmptyCause cause) {
    switch (cause) {
      case EmptyCause.noInitialElements:
        return "";
      default:
        return "No Elements found";
    }
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
                        AppAnimations.getEmptyAnimationOnCause(widget.cause),
                        fit: BoxFit.fitWidth,
                        repeat: widget.cause != EmptyCause.noImageElements,
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
                    alignment: Alignment.topCenter,
                    child: BackdropPanel(
                      filterEnabled: true,
                      searchBarEnabled:
                          widget.cause == EmptyCause.noElementsOnSearch,
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
                            getClipboardEmptyText(widget.cause),
                            textAlign: TextAlign.center,
                            style: AppTheme.fontSize(20).makeBold(),
                          ),
                          Text(
                            getSubTitle(widget.cause),
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
