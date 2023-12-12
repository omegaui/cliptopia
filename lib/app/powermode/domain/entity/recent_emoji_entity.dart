import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';

class RecentEmojiEntity {
  String emoji;
  ClipboardEntity entity;

  RecentEmojiEntity(this.emoji, this.entity);

  bool search(String text) {
    return entity.info.comment.contains(text);
  }
}
