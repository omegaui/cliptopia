import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:flutter/material.dart';

class ColorEntity {
  ClipboardEntity entity;
  Color color;

  ColorEntity(this.entity, this.color);

  bool search(String text) {
    if (text.startsWith('0xFF')) {
      if (text.length > 4) {
        text = text.substring(4);
      } else {
        return true;
      }
    }
    final hex = colorToHex(color);
    if (PowerDataHandler.searchType == PowerSearchType.Regex) {
      try {
        return RegExp(text).hasMatch(hex);
      } catch (e) {
        return true;
      }
    } else if (PowerDataHandler.searchType == PowerSearchType.Comment) {
      return entity.info.comment.contains(text);
    }
    return hex.contains(text) || entity.info.comment.contains(text);
  }
}
