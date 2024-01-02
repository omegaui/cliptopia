import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/app/notes/presentation/notes_controller.dart';
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

class NotesEmptyStateView extends StatefulWidget {
  const NotesEmptyStateView({
    super.key,
    required this.controller,
    required this.cause,
  });

  final NotesController controller;
  final EmptyCause cause;

  @override
  State<NotesEmptyStateView> createState() => _NotesEmptyStateViewState();
}

class _NotesEmptyStateViewState extends State<NotesEmptyStateView> {
  FilterWatcher? filterWatcher;
  DatabaseWatcher? databaseWatcher;

  @override
  void initState() {
    super.initState();
    if (widget.cause == EmptyCause.noNoteElements) {
      Injector.find<Database>().addWatcher(
        databaseWatcher = DatabaseWatcher.permanent(
          onEvent: (notes) {
            EntityUtils.filterOnlyNotes(notes);
            if (notes.isNotEmpty) {
              widget.controller.reload(fastLoad: true);
            }
          },
          filters: [ClipboardEntityType.text],
        ),
      );
    } else if (widget.cause == EmptyCause.noElementsOnSearch) {
      Injector.find<SearchEngine>().addWatcher(SearchWatcher.temp(
          onEvent: (text) {
            widget.controller.reload(fastLoad: true);
          },
          forceCall: false));
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
      case EmptyCause.noNoteElements:
        return "Notes is Empty";
      case EmptyCause.noElementsOnSearch:
        return "Try Another Text";
      case EmptyCause.noElementsOnDate:
        return "Try Another Date";
      default:
        // No other cause is possible in notes feature, so the control never reaches this section
        return "";
    }
  }

  String getSubTitle(EmptyCause cause) {
    switch (cause) {
      case EmptyCause.noNoteElements:
        return "You haven't copied any text yet";
      case EmptyCause.noElementsOnDate:
        return "You haven't copied any text during the applied time";
      default:
        return "You haven't copied any text that matches the search";
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
                        repeat: widget.cause != EmptyCause.noNoteElements,
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
                      searchHint: "Search notes from here ...",
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
