import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/commands/presentation/commands_controller.dart';
import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/config/assets/app_animations.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/search_engine.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/topbar/backdrop_panel.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommandsEmptyStateView extends StatefulWidget {
  const CommandsEmptyStateView({
    super.key,
    required this.controller,
    required this.cause,
  });

  final CommandsController controller;
  final EmptyCause cause;

  @override
  State<CommandsEmptyStateView> createState() => _CommandsEmptyStateViewState();
}

class _CommandsEmptyStateViewState extends State<CommandsEmptyStateView> {
  FilterWatcher? filterWatcher;
  DatabaseWatcher? databaseWatcher;

  @override
  void initState() {
    super.initState();
    if (widget.cause == EmptyCause.noCommandsElements) {
      Injector.find<Database>().addWatcher(
        databaseWatcher = DatabaseWatcher.permanent(
          onEvent: (commands) {
            EntityUtils.filterOnlyCommands(commands);
            if (commands.isNotEmpty) {
              widget.controller.reload(fastLoad: true);
            }
          },
          filters: [ClipboardEntityType.text],
        ),
      );
    } else if (widget.cause == EmptyCause.noElementsOnSearch) {
      SearchEngine.primary.onEvent = (text) {
        if (mounted) {
          widget.controller.reload(fastLoad: true);
        }
      };
    } else if (widget.cause == EmptyCause.noElementsOnDate) {
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
    if (databaseWatcher != null) {
      databaseWatcher!.dispose();
    }
    super.dispose();
  }

  String getNotesEmptyText(EmptyCause cause) {
    switch (cause) {
      case EmptyCause.noCommandsElements:
        return "No Commands Found";
      case EmptyCause.noElementsOnSearch:
        return "No matches";
      case EmptyCause.noElementsOnDate:
        return "Try Another Date";
      default:
        // No other cause is possible in commands feature, so the control never reaches this section
        return "";
    }
  }

  String getSubTitle(EmptyCause cause) {
    switch (cause) {
      case EmptyCause.noCommandsElements:
        return "You haven't copied any command yet";
      case EmptyCause.noElementsOnDate:
        return "You haven't copied any command during the applied time";
      default:
        return "You haven't copied any command that matches the search";
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
                    alignment: Alignment.topCenter,
                    child: BackdropPanel(
                      filterEnabled:
                          widget.cause == EmptyCause.noElementsOnDate,
                      searchBarEnabled:
                          widget.cause == EmptyCause.noElementsOnSearch,
                      searchHint: "Search Commands here ...",
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
                            getNotesEmptyText(widget.cause),
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
