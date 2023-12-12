import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:cliptopia/widgets/tiles/image_tile.dart';
import 'package:cliptopia/widgets/tiles/path_tile.dart';
import 'package:cliptopia/widgets/tiles/text_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

class ContentBuilder {
  ContentBuilder._();

  static Widget buildTiles(List<ClipboardEntity> entities) {
    // removing objects marked for deletion by the Daemon

    List<Widget> rows = [];

    // Special Case Handle
    if (entities
            .where((entity) => entity.type == ClipboardEntityType.image)
            .length ==
        entities.length) {
      int count = 0;
      var i = 0;
      for (; i < entities.length; i++) {
        count++;
        if (count == 2) {
          final e1 = entities[i - 1];
          final e2 = entities[i];
          _addNoneType(rows, e1, e2, forceExpanded: true);
          rows.add(const SizedBox(height: 17));
          count = 0;
        }
      }

      if (count > 0) {
        if (count == 2) {
          final e1 = entities[i - 2];
          final e2 = entities[i - 1];
          _addNoneType(rows, e1, e2);
          rows.add(const SizedBox(height: 17));
        } else {
          final e1 = entities[i - 1];
          rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getTile(e1),
            ],
          ));
          rows.add(const SizedBox(height: 17));
        }
      }
    } else {
      int count = 0;
      var i = 0;
      for (; i < entities.length; i++) {
        count++;
        if (count == 3) {
          final e1 = entities[i - 2];
          final e2 = entities[i - 1];
          final e3 = entities[i];
          final classificationResult = EntitySetClassifier.classify(
            e1.type,
            e2.type,
            e3.type,
          );
          _addTile(classificationResult, rows, e1, e2, e3);
          count = 0;
        }
      }

      if (count > 0) {
        if (count == 3) {
          final e1 = entities[i - 3];
          final e2 = entities[i - 2];
          final e3 = entities[i - 1];
          _addTile(EntitySetClassificationType.none, rows, e1, e2, e3);
        } else if (count == 2) {
          final e1 = entities[i - 2];
          final e2 = entities[i - 1];
          _addNoneType(rows, e1, e2);
        } else {
          final e1 = entities[i - 1];
          rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getTile(e1),
            ],
          ));
        }
      }
    }
    return Column(
      children: rows,
    );
  }

  static Widget buildList(
      RebuildCallback onRebuild, List<ClipboardEntity> entities) {
    // removing objects marked for deletion by the Daemon
    List<Widget> rows = [];

    for (var entity in entities) {
      rows.add(Container(
        margin: const EdgeInsets.only(left: 36, right: 36, bottom: 20),
        height: 45,
        decoration: BoxDecoration(
          color: AppTheme.commandTileColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Icon(
                    entity.type == ClipboardEntityType.text
                        ? Icons.text_fields
                        : entity.type == ClipboardEntityType.path
                            ? Icons.route
                            : Icons.image_outlined,
                    color: Colors.grey,
                  ),
                  const Gap(8),
                  Tooltip(
                    message: entity.type != ClipboardEntityType.image
                        ? entity.data
                        : "",
                    child: GestureDetector(
                      onTap: () => EntityUtils.inject(entity),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: SizedBox(
                          width: 540,
                          child: Text(
                            entity.type == ClipboardEntityType.image
                                ? "Image (Copied on ${DateFormat("EEE, M/d/y").format(entity.time)} at ${DateFormat("K:mm:ss a").format(entity.time)})"
                                : entity.data.trim(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.fontSize(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                color: AppTheme.commandTileColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        entity.markAsDeleted();
                        onRebuild();
                        Messenger.show("Deleted Item from Cache",
                            type: MessageType.severe);
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () => copy(entity),
                      icon: Icon(
                        Icons.copy_sharp,
                        color: AppTheme.foreground,
                      ),
                      iconSize: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    }

    return Column(
      children: rows,
    );
  }

  static void _addTile(classificationResult, rows, e1, e2, e3) {
    switch (classificationResult) {
      case EntitySetClassificationType.allNote:
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTile(entity: e1),
            _buildTile(entity: e2),
            _buildTile(entity: e3, spacer: false),
          ],
        ));
        break;
      case EntitySetClassificationType.allImage:
        rows.add(SizedBox(
          width: 700,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Transform.scale(
                  scale: 0.82,
                  child: _buildTile(entity: e1, spacer: false),
                ),
                Transform.scale(
                  scale: 0.82,
                  child: _buildTile(entity: e2, spacer: false),
                ),
                Transform.scale(
                  scale: 0.82,
                  child: _buildTile(entity: e3, spacer: false),
                ),
              ],
            ),
          ),
        ));
        break;
      case EntitySetClassificationType.noteNoteImage:
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e1, spacer: false),
              ),
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e2, spacer: false),
              ),
            ]),
            _buildTile(entity: e3, forceExpanded: true),
          ],
        ));
        break;
      case EntitySetClassificationType.noteImageNote:
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTile(entity: e1),
            _buildTile(entity: e2, normalSize: true),
            _buildTile(entity: e3, spacer: false),
          ],
        ));
        break;
      case EntitySetClassificationType.imageNoteNote:
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTile(entity: e1, forceExpanded: true),
            Column(children: [
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e2, spacer: false),
              ),
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e3, spacer: false),
              ),
            ]),
          ],
        ));
        break;
      case EntitySetClassificationType.noteImageImage:
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e1, spacer: false),
              ),
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e2, spacer: false, normalSize: true),
              ),
            ]),
            _buildTile(entity: e3, forceExpanded: true),
          ],
        ));
        break;
      case EntitySetClassificationType.imageNoteImage:
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTile(entity: e1, normalSize: true),
            _buildTile(entity: e2),
            _buildTile(entity: e3, spacer: false, normalSize: true),
          ],
        ));
        break;
      case EntitySetClassificationType.imageImageNote:
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e3, spacer: false),
              ),
              Transform.scale(
                scale: 0.9,
                child: _buildTile(entity: e1, spacer: false, normalSize: true),
              ),
            ]),
            _buildTile(entity: e2, forceExpanded: true),
          ],
        ));
        break;
      case EntitySetClassificationType.none:
    }
    Widget widget = rows.last;
    rows.remove(widget);
    rows.add(Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: widget,
    ));
  }

  static Widget _buildTile(
      {entity,
      normalSize = false,
      forceCompact = false,
      forceExpanded = false,
      spacer = true}) {
    if (entity.type == ClipboardEntityType.text) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextTile(entity: entity),
          if (spacer) const SizedBox(width: 19),
        ],
      );
    } else if (entity.type == ClipboardEntityType.path) {
      final mime = lookupMimeType(entity.data) ?? "";
      if (mime.startsWith('image/')) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageTile(
              entity: entity,
              forceCompactMode: forceCompact,
              forceExpandedMode: forceExpanded,
              normalSizeMode: normalSize,
            ),
            if (spacer) const SizedBox(width: 19),
          ],
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PathTile(entity: entity),
          if (spacer) const SizedBox(width: 19),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageTile(
          entity: entity,
          forceCompactMode: forceCompact,
          forceExpandedMode: forceExpanded,
          normalSizeMode: normalSize,
        ),
        if (spacer) const SizedBox(width: 19),
      ],
    );
  }

  static void _addNoneType(rows, e1, e2, {forceExpanded = false}) {
    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getTile(e1, forceExpanded: forceExpanded),
        const SizedBox(width: 19),
        _getTile(e2, forceExpanded: forceExpanded),
      ],
    ));
  }

  static Widget _getTile(entity, {forceExpanded = false}) {
    if (entity.type == ClipboardEntityType.path) {
      final mime = lookupMimeType(entity.data) ?? "";
      if (mime.startsWith('image/')) {
        return ImageTile(
          entity: entity,
          forceExpandedMode: forceExpanded,
        );
      }
      return PathTile(entity: entity);
    } else if (entity.type == ClipboardEntityType.image) {
      return ImageTile(
        entity: entity,
        forceExpandedMode: forceExpanded,
      );
    }
    return TextTile(entity: entity);
  }
}

class EntitySetClassifier {
  EntitySetClassifier._();

  static final _allNoteOrder = [
    ClipboardEntityType.text,
    ClipboardEntityType.text,
    ClipboardEntityType.text,
  ];
  static final _noteNoteImageOrder = [
    ClipboardEntityType.text,
    ClipboardEntityType.text,
    ClipboardEntityType.image,
  ];
  static final _noteImageNoteOrder = [
    ClipboardEntityType.text,
    ClipboardEntityType.image,
    ClipboardEntityType.text,
  ];
  static final _imageNoteNoteOrder = [
    ClipboardEntityType.image,
    ClipboardEntityType.text,
    ClipboardEntityType.text,
  ];
  static final _noteImageImageOrder = [
    ClipboardEntityType.text,
    ClipboardEntityType.image,
    ClipboardEntityType.image,
  ];
  static final _imageNoteImageOrder = [
    ClipboardEntityType.image,
    ClipboardEntityType.text,
    ClipboardEntityType.image,
  ];
  static final _imageImageNoteOrder = [
    ClipboardEntityType.image,
    ClipboardEntityType.image,
    ClipboardEntityType.text,
  ];

  static EntitySetClassificationType classify(
    ClipboardEntityType type1,
    ClipboardEntityType type2,
    ClipboardEntityType type3,
  ) {
    final t1 = changeToTextIfPath(type1);
    final t2 = changeToTextIfPath(type2);
    final t3 = changeToTextIfPath(type3);
    if (_listEquals([t1, t2, t3], _allNoteOrder)) {
      return EntitySetClassificationType.allNote;
    } else if (_listEquals([t1, t2, t3], _noteNoteImageOrder)) {
      return EntitySetClassificationType.noteNoteImage;
    } else if (_listEquals([t1, t2, t3], _noteImageNoteOrder)) {
      return EntitySetClassificationType.noteImageNote;
    } else if (_listEquals([t1, t2, t3], _imageNoteNoteOrder)) {
      return EntitySetClassificationType.imageNoteNote;
    } else if (_listEquals([t1, t2, t3], _noteImageImageOrder)) {
      return EntitySetClassificationType.noteImageImage;
    } else if (_listEquals([t1, t2, t3], _imageNoteImageOrder)) {
      return EntitySetClassificationType.imageNoteImage;
    } else if (_listEquals([t1, t2, t3], _imageImageNoteOrder)) {
      return EntitySetClassificationType.imageImageNote;
    } else {
      return EntitySetClassificationType.allImage;
    }
  }

  static bool _listEquals(
      List<ClipboardEntityType> list1, List<ClipboardEntityType> list2) {
    // Utility function to check if two lists are equal.
    if (list1.length != list2.length) return false;
    for (var i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  static ClipboardEntityType changeToTextIfPath(ClipboardEntityType t) {
    if (t == ClipboardEntityType.path) {
      t = ClipboardEntityType.text;
    }
    return t;
  }
}

enum EntitySetClassificationType {
  allNote,
  allImage,
  noteNoteImage,
  noteImageNote,
  imageNoteNote,
  noteImageImage,
  imageNoteImage,
  imageImageNote,
  none,
}
