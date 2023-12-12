import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/emojis/domain/emoji_entity.dart';
import 'package:cliptopia/app/emojis/domain/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class EmojisRepository {
  final _database = Injector.find<Database>();
  final _parser = EmojiParser();
  final Map<String, Set<String>> _parsedEmojisMap = {};

  bool hasEmojis() {
    if (!_database.hasEntities(ClipboardEntityType.text)) {
      return false;
    }
    final texts =
        _database.entities.where((e) => e.type == ClipboardEntityType.text);
    return texts.any((e) => _parser.parseEmojis(e.data).isNotEmpty);
  }

  List<EmojiEntity> getEmojis() {
    List<EmojiEntity> emojis = [];
    final texts =
        _database.entities.where((e) => e.type == ClipboardEntityType.text);
    for (final text in texts) {
      String contents = text.data;
      if (_parsedEmojisMap.containsKey(contents)) {
        final emojiSet = _parsedEmojisMap[contents]!;
        for (final text in emojiSet) {
          emojis.add(EmojiEntity(text, AppEmojiUtils.getEmojiType(text)));
        }
      } else {
        final emojiSet = _parser.parseEmojis(contents);
        _parsedEmojisMap[contents] = emojiSet.toSet();
        for (final text in emojiSet) {
          emojis.add(EmojiEntity(text, AppEmojiUtils.getEmojiType(text)));
        }
      }
    }
    return emojis;
  }
}
