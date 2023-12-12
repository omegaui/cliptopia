import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/commands/presentation/commands_controller.dart';
import 'package:cliptopia/app/commands/presentation/widgets/command_tile.dart';
import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/search_engine.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/main.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/tag.dart';
import 'package:cliptopia/widgets/topbar/backdrop_panel.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CommandsInitializedStateView extends StatefulWidget {
  const CommandsInitializedStateView({super.key, required this.controller});

  final CommandsController controller;

  @override
  State<CommandsInitializedStateView> createState() =>
      _CommandsInitializedStateViewState();
}

class _CommandsInitializedStateViewState
    extends State<CommandsInitializedStateView> {
  late FilterWatcher filterWatcher;
  late DatabaseWatcher databaseWatcher;

  final filterRepo = Injector.find<FilterRepository>();
  final database = Injector.find<Database>();

  Filter currentFilter = Filter.defaultFilter;
  EmptyCause cause = EmptyCause.none;
  String currentSearchText = "";

  void rebuild() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filterWatcher = FilterWatcher.forceCall(onEvent: (filter) {
      currentFilter = filter;
      rebuild();
    });
    databaseWatcher = DatabaseWatcher.permanent(
      onEvent: (commands) {
        EntityUtils.filterOnlyCommands(commands);
        if (commands.isNotEmpty) {
          rebuild();
        }
      },
      filters: [ClipboardEntityType.text],
    );

    SearchEngine.primary.onEvent = (text) {
      currentSearchText = text;
      rebuild();
    };
    Injector.find<SearchEngine>().signal();

    filterRepo.addWatcher(filterWatcher);
    database.addWatcher(databaseWatcher);
  }

  @override
  void dispose() {
    filterWatcher.dispose();
    databaseWatcher.dispose();
    super.dispose();
  }

  Widget _buildItems() {
    // Finding Elements by date (if applied)
    final entities = database
        .getEntities(
            range: currentFilter.dateRange, type: ClipboardEntityType.text)
        .toList();
    // Filtering Only Note Elements by
    // removing other texts, commands and emojis
    EntityUtils.filterOnlyCommands(entities);
    if (entities.isEmpty) {
      if (currentFilter.dateRange.isCustom()) {
        cause = EmptyCause.noElementsOnDate;
      } else {
        cause = EmptyCause.noInitialElements;
      }
    }
    // No Filter is applied on text types
    if (cause != EmptyCause.none) {
      widget.controller.gotoEmptyState(cause);
    }
    // Searching Entities if applicable
    if (currentSearchText.isNotEmpty) {
      EntityUtils.search(entities, currentSearchText);
      if (entities.isEmpty) {
        cause = EmptyCause.noElementsOnSearch;
      }
    }
    if (cause != EmptyCause.none) {
      widget.controller.gotoEmptyState(cause);
    }
    return Column(
      children: entities.map((e) => CommandTile(entity: e)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.fromSize(
        size: windowSize,
        child: Stack(
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
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          BackdropPanel(
                            filterEnabled: cause == EmptyCause.none,
                            searchBarEnabled: cause == EmptyCause.none,
                            searchHint: "Search notes from here ...",
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 420,
                            child: SingleChildScrollView(
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildItems(),
                                    const SizedBox(height: 36),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: TopBar(
                        enabled: cause == EmptyCause.none,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 120.0, right: 36.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Tag(
                              text: "Experimental",
                              message: "This view may show unexpected results.",
                              color: Colors.grey.shade700,
                            ),
                            const Gap(8),
                            Tag(
                              text: "Quick Tip",
                              message:
                                  "Right click on a command to start executing it in the terminal",
                              color: Colors.blue.shade700,
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
      ),
    );
  }
}
