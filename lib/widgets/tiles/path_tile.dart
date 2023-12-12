import 'dart:io';

import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:cliptopia/widgets/tiles/copy_item_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PathTile extends StatefulWidget {
  const PathTile({
    super.key,
    required this.entity,
  });

  final ClipboardEntity entity;

  @override
  State<PathTile> createState() => _PathTileState();
}

class _PathTileState extends State<PathTile> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    bool isDirectory = FileSystemEntity.isDirectorySync(widget.entity.data);
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
        width: 200,
        height: 100,
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
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 19, top: 15),
                child: GestureDetector(
                  onTap: () {
                    if (EntityUtils.isVideoOrAudio(widget.entity) &&
                        (Storage.get('open-media-on-click') ?? false)) {
                      Messenger.show("Opening in desktop");
                      launchUrlString('file://${widget.entity.data}');
                    } else {
                      EntityUtils.inject(widget.entity);
                    }
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    isDirectory
                                        ? AppIcons.folder
                                        : AppIcons.file,
                                    width: 32,
                                    height: 32,
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 130,
                                    child: Text(
                                      isDirectory
                                          ? "Directory"
                                          : _getRepresentableText(
                                              widget.entity.data),
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTheme.fontSize(14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              SizedBox(
                                width: 130,
                                child: Text(
                                  _getEntityName(widget.entity.data),
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.fontSize(12).makeBold(),
                                ),
                              ),
                              const SizedBox(height: 7),
                              SizedBox(
                                width: 130,
                                child: Tooltip(
                                  message: widget.entity.data,
                                  child: Text(
                                    widget.entity.data,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTheme.fontSize(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Transform.scale(
                scale: 0.6,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: hover ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.barrierColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.infoCardLowerDropShadowColor,
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            copy(widget.entity, mode: 'copy-file');
                          },
                          tooltip: "Copy File",
                          icon: Icon(
                            Icons.location_on_outlined,
                            color: AppTheme.foreground,
                          ),
                        ),
                        const Gap(5),
                        IconButton(
                          onPressed: () {
                            copy(widget.entity, mode: 'copy-path');
                          },
                          tooltip: "Copy Path",
                          icon: Icon(
                            Icons.content_paste_sharp,
                            color: AppTheme.foreground,
                          ),
                        ),
                      ],
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
      ),
    );
  }

  String _getRepresentableText(String data) {
    String res = "";
    String name = _getEntityName(data);
    if (name.contains('.')) {
      res = name.substring(name.lastIndexOf('.') + 1).toUpperCase();
      res = "$res File";
    } else {
      res = "File";
    }
    return res;
  }

  String _getEntityName(data) {
    return data.substring(data.lastIndexOf(Platform.pathSeparator) + 1);
  }
}
