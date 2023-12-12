import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';

class TextEntity {
  ClipboardEntity entity;
  String text;

  TextEntity(this.entity, this.text);

  bool search(String text) {
    if (PowerDataHandler.searchType == PowerSearchType.Regex) {
      try {
        return RegExp(text).hasMatch(this.text);
      } catch (e) {
        return true;
      }
    } else if (PowerDataHandler.searchType == PowerSearchType.Comment) {
      return entity.info.comment.contains(text);
    }
    return this.text.contains(text) || entity.info.comment.contains(text);
  }
}
