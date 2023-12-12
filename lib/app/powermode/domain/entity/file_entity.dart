import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';

class FileEntity {
  bool directory;
  String name;
  String parentPath;
  String path;
  ClipboardEntity entity;

  FileEntity(
      this.directory, this.name, this.parentPath, this.path, this.entity);

  bool search(String text) {
    if (PowerDataHandler.searchType == PowerSearchType.Regex) {
      try {
        return RegExp(text).hasMatch(path);
      } catch (e) {
        return true;
      }
    } else if (PowerDataHandler.searchType == PowerSearchType.Comment) {
      return entity.info.comment.contains(text);
    }
    return path.contains(text) ||
        path.endsWith(text) ||
        entity.info.comment.contains(text);
  }
}
