import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/image_entity.dart';
import 'package:cliptopia/app/powermode/presentation/dialogs/entity_info_dialog.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({
    super.key,
    required this.imageEntity,
    required this.onRebuildRequested,
  });

  final ImageEntity imageEntity;
  final RebuildCallback onRebuildRequested;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: GestureDetector(
        onTap: () {
          EntityUtils.inject(widget.imageEntity.entity);
        },
        onSecondaryTap: () {
          showInfoDialog(context, widget.imageEntity.entity, "Image Card");
        },
        child: MouseRegion(
          onEnter: (e) {
            setState(() => hover = true);
            PowerDataHandler.hoveringOn(widget.imageEntity.entity);
          },
          onExit: (e) {
            setState(() => hover = false);
            PowerDataHandler.hoveringOn(null);
          },
          child: Tooltip(
            message: widget.imageEntity.entity.info.comment,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn,
              width: widget.imageEntity.size.width,
              height: widget.imageEntity.size.height,
              decoration: BoxDecoration(
                color: PowerModeTheme.background,
                borderRadius: BorderRadius.circular(10),
                boxShadow: hover
                    ? [
                        BoxShadow(
                          color: PowerModeTheme.imageCardDropShadowColor,
                          blurRadius: 8,
                        )
                      ]
                    : [],
              ),
              child: Stack(
                children: [
                  Align(
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: PowerModeTheme.cardBorderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox.fromSize(
                          size: widget.imageEntity.size,
                          child: Image.memory(
                            widget.imageEntity.bytes,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeIn,
                      opacity: hover ? 1.0 : 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: PowerModeTheme.background,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  PowerModeTheme.dropShadowOpacity),
                              blurRadius: 16,
                            )
                          ],
                        ),
                        child: Wrap(
                          spacing: 8,
                          runAlignment: WrapAlignment.center,
                          alignment: WrapAlignment.center,
                          children: [
                            if (widget.imageEntity.entity.type ==
                                ClipboardEntityType.image)
                              IconButton(
                                onPressed: () {
                                  widget.imageEntity.entity.markAsDeleted();
                                  widget.onRebuildRequested();
                                },
                                tooltip: 'Delete',
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                iconSize: 20,
                              ),
                            IconButton(
                              onPressed: () {
                                copy(widget.imageEntity.entity);
                              },
                              tooltip: 'Copy',
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.blue,
                              ),
                              iconSize: 20,
                            ),
                            IconButton(
                              onPressed: () {
                                launchUrlString(
                                    'file://${widget.imageEntity.entity.data}');
                              },
                              tooltip: 'Open',
                              icon: const Icon(
                                Icons.open_in_new,
                                color: Colors.grey,
                              ),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeIn,
                      opacity: hover ? 1.0 : 0.0,
                      child: FittedBox(
                        child: Container(
                          decoration: BoxDecoration(
                            color: PowerModeTheme.background,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: PowerModeTheme.cardDropShadowColor,
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Center(
                            child: Text(
                              "${widget.imageEntity.originalSize.width.toStringAsFixed(0)} x ${widget.imageEntity.originalSize.height.toStringAsFixed(0)}",
                              style: AppTheme.fontSize(12).makeBold(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
