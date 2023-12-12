import 'package:emojis/emoji.dart';

typedef CategoryChangeCallback = void Function(EmojiCategory category);

enum EmojiCategory { all, face, cloth, animal, food, misc }

class AppEmojiUtils {
  AppEmojiUtils._();

  static final _smileysAndPeople = Emoji.byGroup(EmojiGroup.smileysEmotion);
  static final _clothAndBody = Emoji.byGroup(EmojiGroup.peopleBody);
  static final _animalsAndNature = Emoji.byGroup(EmojiGroup.animalsNature);
  static final _foodAndDrink = Emoji.byGroup(EmojiGroup.foodDrink);

  static EmojiCategory getEmojiType(String emojiText) {
    if (_any(_smileysAndPeople, emojiText)) {
      return EmojiCategory.face;
    } else if (_any(_clothAndBody, emojiText)) {
      return EmojiCategory.cloth;
    } else if (_any(_animalsAndNature, emojiText)) {
      return EmojiCategory.animal;
    } else if (_any(_foodAndDrink, emojiText)) {
      return EmojiCategory.food;
    }
    return EmojiCategory.misc;
  }

  static bool _any(Iterable<Emoji> emojis, text) {
    for (final emoji in emojis) {
      if (emoji.char == text) {
        return true;
      }
    }
    return false;
  }
}
