import 'package:cliptopia/app/notes/data/notes_repository.dart';
import 'package:cliptopia/app/notes/presentation/notes_state_machine.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/machine/controller.dart';

class NotesController extends Controller<NotesState, NotesEvent> {
  final notesRepo = Injector.find<NotesRepository>();

  NotesController({required RebuildCallback onRebuild})
      : super(onRebuild: onRebuild, stateMachine: NotesStateMachine());

  void load({fastLoad = false}) async {
    if (notesRepo.hasObjects()) {
      onEvent(NotesInitializedEvent());
    } else {
      onEvent(NotesEmptyEvent(EmptyCause.noNoteElements));
    }
  }

  void reload({fastLoad = false}) {
    onEvent(NotesLoadingEvent(fastLoad));
    if (fastLoad) {
      load(fastLoad: true);
    }
  }

  void gotoEmptyState(EmptyCause cause) {
    onEvent(NotesEmptyEvent(cause));
  }
}
