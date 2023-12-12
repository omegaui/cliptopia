import 'package:cliptopia/app/emojis/data/emojis_repository.dart';
import 'package:cliptopia/app/emojis/domain/emoji_entity.dart';
import 'package:cliptopia/app/emojis/presentation/emojis_state_machine.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/services/machine/controller.dart';

class EmojisController extends Controller<EmojisState, EmojisEvent> {
  final emojisRepo = Injector.find<EmojisRepository>();

  EmojisController({required RebuildCallback onRebuild})
      : super(
          onRebuild: onRebuild,
          stateMachine: EmojisStateMachine(),
        );

  void load() async {
    if (emojisRepo.hasEmojis()) {
      onEvent(EmojisInitializedEvent());
    } else {
      onEvent(EmojisEmptyEvent());
    }
  }

  void reload() async {
    load();
  }

  List<EmojiEntity> getEmojis() {
    return emojisRepo.getEmojis();
  }
}
