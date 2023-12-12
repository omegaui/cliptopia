import 'package:cliptopia/app/powermode/domain/entity_info.dart';

mixin Commentable {
  late EntityInfo _info;

  set info(EntityInfo value) {
    _info = value;
  }

  EntityInfo get info => _info;

  bool matches(String text) {
    return _info.comment.contains(text);
  }
}
