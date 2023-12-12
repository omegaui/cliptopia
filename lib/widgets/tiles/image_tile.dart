import 'dart:io';

import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/tiles/copy_item_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImageTile extends StatefulWidget {
  const ImageTile({
    super.key,
    required this.entity,
    this.forceCompactMode = false,
    this.forceExpandedMode = false,
    this.normalSizeMode = false,
  });

  final bool forceCompactMode;
  final bool forceExpandedMode;
  final bool normalSizeMode;
  final ClipboardEntity entity;

  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.normalSizeMode) {
      double width = 200;
      double height = 100;
      double imageWidth = 96;
      return _buildContent(
        width: width,
        height: height,
        imageWidth: imageWidth,
      );
    } else if (widget.forceCompactMode) {
      double width = 100;
      double height = 100;
      double imageWidth = 64;
      return _buildContent(
        width: width,
        height: height,
        imageWidth: imageWidth,
      );
    } else if (widget.forceExpandedMode) {
      double width = 300;
      double height = 200;
      double imageWidth = 250;
      return _buildContent(
        width: width,
        height: height,
        imageWidth: imageWidth,
      );
    }
    return FutureBuilder(
      future: getImageSize(widget.entity.data),
      builder: (context, snapshot) {
        final size = (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.hasError ||
                snapshot.data == null)
            ? const Size(300, 100)
            : snapshot.data!;
        double width = size.width >= 250 ? 300 : 100;
        double height = size.width >= 250 ? 200 : 100;
        double imageWidth = width == 300 ? 250 : 64;
        return _buildContent(
          width: width,
          height: height,
          imageWidth: imageWidth,
        );
      },
    );
  }

  Widget _buildContent({width, height, imageWidth}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.tileUpperDropShadowColor,
            blurRadius: 24,
            offset: const Offset(-8, -8),
          ),
          BoxShadow(
            color: AppTheme.tileLowerDropShadowColor,
            blurRadius: 24,
            offset: const Offset(8, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () {
                  if (Storage.get('open-media-on-click') ?? false) {
                    launchUrlString('file://${widget.entity.data}');
                  } else {
                    EntityUtils.inject(widget.entity);
                  }
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Image.file(
                    File(widget.entity.data),
                    width: imageWidth,
                    height: imageWidth == 250 ? 166.53 : 64,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CopyItemButton(entity: widget.entity),
          ),
        ],
      ),
    );
  }
}
