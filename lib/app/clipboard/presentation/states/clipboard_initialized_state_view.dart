import 'package:cliptopia/app/clipboard/presentation/clipboard_controller.dart';
import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/search_engine.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/main.dart';
import 'package:cliptopia/widgets/app_close_button.dart';
import 'package:cliptopia/widgets/builder/content_builder.dart';
import 'package:cliptopia/widgets/topbar/backdrop_panel.dart';
import 'package:cliptopia/widgets/topbar/top_bar.dart';
import 'package:flutter/material.dart';

class ClipboardInitializedStateView extends StatefulWidget {
  const ClipboardInitializedStateView({super.key, required this.controller});

  final ClipboardController controller;

  @override
  State<ClipboardInitializedStateView> createState() =>
      _ClipboardInitializedStateViewState();
}

class _ClipboardInitializedStateViewState
    extends State<ClipboardInitializedStateView> {
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
    databaseWatcher = DatabaseWatcher.permanent(onEvent: (_) => rebuild());
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
    final viewMode = filterRepo.activeFilter.viewMode;
    // Finding Elements by date (if applied)
    final entities =
        database.getEntities(range: currentFilter.dateRange).toList();
    if (entities.isEmpty) {
      if (currentFilter.dateRange.isCustom()) {
        cause = EmptyCause.noElementsOnDate;
      } else {
        cause = EmptyCause.noInitialElements;
      }
    }
    if (cause != EmptyCause.none) {
      widget.controller.gotoEmptyState(cause);
    }
    // Applying Filter, then, Checks on the result set
    EntityUtils.filter(entities, currentFilter);
    if (entities.isEmpty) {
      if (currentFilter.filterMode == FilterMode.builtin) {
        switch ((currentFilter.pattern as BuiltinFilterPattern)) {
          case BuiltinFilterPattern.image:
            cause = EmptyCause.noImageElements;
            break;
          case BuiltinFilterPattern.video:
            cause = EmptyCause.noVideoElements;
            break;
          case BuiltinFilterPattern.audio:
            cause = EmptyCause.noAudioElements;
            break;
          case BuiltinFilterPattern.files:
            cause = EmptyCause.noFileElements;
            break;
          case BuiltinFilterPattern.none:
            cause = EmptyCause.noElementsOnFilter;
        }
      } else {
        if (cause == EmptyCause.none) {
          cause = EmptyCause.noElementsOnFilter;
        }
      }
    } else {
      cause = EmptyCause.none;
    }
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
    switch (viewMode) {
      case ViewMode.tiles:
        return ContentBuilder.buildTiles(entities);
      case ViewMode.list:
        return ContentBuilder.buildList(rebuild, entities);
    }
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
                                    const SizedBox(height: 36),
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
