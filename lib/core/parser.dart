import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/constants/typedefs.dart';

class Parser {
  static ClipboardEntityType parseClipboardEntityType(String value) {
    switch (value) {
      case 'ClipboardEntityType.path':
        return ClipboardEntityType.path;
      case 'ClipboardEntityType.image':
        return ClipboardEntityType.image;
    }
    return ClipboardEntityType.text;
  }

  static FilterMode parseFilterMode(String value) {
    switch (value) {
      case 'FilterMode.builtin':
        return FilterMode.builtin;
    }
    return FilterMode.custom;
  }

  static ViewMode parseViewMode(String value) {
    switch (value) {
      case 'ViewMode.tiles':
        return ViewMode.tiles;
    }
    return ViewMode.list;
  }

  static dynamic parseBuiltinFilterPattern(String value) {
    switch (value) {
      case 'BuiltinFilterPattern.image':
        return BuiltinFilterPattern.image;
      case 'BuiltinFilterPattern.video':
        return BuiltinFilterPattern.video;
      case 'BuiltinFilterPattern.audio':
        return BuiltinFilterPattern.audio;
      case 'BuiltinFilterPattern.files':
        return BuiltinFilterPattern.files;
      case 'BuiltinFilterPattern.none':
        return BuiltinFilterPattern.none;
    }
    return value;
  }
}
