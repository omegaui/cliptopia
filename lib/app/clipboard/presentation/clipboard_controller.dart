import 'package:cliptopia/app/clipboard/data/clipboard_repository.dart';
import 'package:cliptopia/app/clipboard/presentation/clipboard_state_machine.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/machine/controller.dart';

class ClipboardController extends Controller<ClipboardState, ClipboardEvent> {
  final clipboardRepo = Injector.find<ClipboardRepository>();

  ClipboardController({required RebuildCallback onRebuild})
      : super(onRebuild: onRebuild, stateMachine: ClipboardStateMachine());

  void load(ClipboardLoadingState state) async {
    if (!state.fastLoad) {
      if (!clipboardRepo.isDaemonIntegrated()) {
        onEvent(ClipboardDaemonMissingEvent());
        return;
      }
      await clipboardRepo.startDaemonIfNotRunning();
    }
    if (clipboardRepo.hasObjects()) {
      onEvent(ClipboardInitializedEvent());
    } else {
      onEvent(ClipboardEmptyEvent(EmptyCause.noInitialElements));
    }
  }

  void triggerDaemonIntegrationEvent() {
    onEvent(ClipboardDaemonIntegrationEvent());
  }

  void downloadDaemon({
    required RebuildCallback onDownloadComplete,
    required RebuildCallback onError,
  }) {
    clipboardRepo.downloadDaemon(
      onDownloadComplete: onDownloadComplete,
      onError: onError,
    );
  }

  void integrateDaemon() {
    clipboardRepo.integrateDaemon();
    clipboardRepo.startDaemonIfNotRunning();
  }

  void reload({fastLoad = false}) {
    onEvent(ClipboardLoadingEvent(fastLoad));
    if (fastLoad) {
      load(ClipboardLoadingState(fastLoad));
    }
  }

  bool isClipboardEmpty() {
    return !clipboardRepo.hasObjects();
  }

  void gotoEmptyState(EmptyCause cause) {
    onEvent(ClipboardEmptyEvent(cause));
  }
}
