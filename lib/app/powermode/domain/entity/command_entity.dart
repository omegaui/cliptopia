import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';

class CommandEntity {
  ClipboardEntity entity;
  String command;

  CommandEntity(this.entity, this.command);

  bool search(String text) {
    if (PowerDataHandler.searchType == PowerSearchType.Regex) {
      try {
        return RegExp(text).hasMatch(command);
      } catch (e) {
        return true;
      }
    } else if (PowerDataHandler.searchType == PowerSearchType.Comment) {
      return entity.info.comment.contains(text);
    }
    return command.contains(text) || entity.info.comment.contains(text);
  }
}
