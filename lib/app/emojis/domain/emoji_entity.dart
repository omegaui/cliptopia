import 'package:cliptopia/app/emojis/domain/typedefs.dart';

class EmojiEntity {
  String text;
  EmojiCategory category;

  EmojiEntity(this.text, this.category);

  @override
  bool operator ==(Object other) {
    if (other is EmojiEntity) {
      return text == text && category == category;
    }
    return super == other;
  }

  @override
  int get hashCode => super.hashCode ^ text.hashCode ^ category.hashCode;
}
