import 'package:cliptopia/app/commands/data/commands_repository.dart';
import 'package:cliptopia/app/commands/presentation/commands_state_machine.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/machine/controller.dart';

class CommandsController extends Controller<CommandsState, CommandsEvent> {
  final _commandsRepo = Injector.find<CommandsRepository>();

  CommandsController({required RebuildCallback onRebuild})
      : super(onRebuild: onRebuild, stateMachine: CommandsStateMachine());

  void load({fastLoad = false}) async {
    if (_commandsRepo.hasObjects()) {
      onEvent(CommandsInitializedEvent());
    } else {
      onEvent(CommandsEmptyEvent(EmptyCause.noCommandsElements));
    }
  }

  void reload({fastLoad = false}) {
    onEvent(CommandsLoadingEvent(fastLoad));
    if (fastLoad) {
      load(fastLoad: true);
    }
  }

  void gotoEmptyState(EmptyCause cause) {
    onEvent(CommandsEmptyEvent(cause));
  }
}
