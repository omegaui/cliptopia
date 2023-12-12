import 'dart:typed_data';

import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:flutter/material.dart';

class ImageEntity {
  ClipboardEntity entity;
  Uint8List bytes;
  Size size;
  Size originalSize;
  PowerImageFilterType imageFilterType;

  ImageEntity(
    this.entity,
    this.bytes,
    this.size,
    this.originalSize,
    this.imageFilterType,
  );

  bool search(String text) {
    if (PowerDataHandler.searchType == PowerSearchType.Comment) {
      return entity.info.comment.contains(text);
    }
    return "${originalSize.width.round()}x${originalSize.height.round()}"
            .startsWith(text) ||
        "${originalSize.height.round()}".startsWith(text) ||
        entity.info.comment.contains(text);
  }
}
