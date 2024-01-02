import 'package:cliptopia/app/powermode/domain/entity/file_entity.dart';
import 'package:cliptopia/app/powermode/presentation/dialogs/entity_info_dialog.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileCard extends StatefulWidget {
  const FileCard({
    super.key,
    required this.fileEntity,
    required this.onRebuildRequested,
  });

  final FileEntity fileEntity;
  final VoidCallback onRebuildRequested;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  bool hover = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() => hover = true);
        PowerDataHandler.hoveringOn(widget.fileEntity.entity);
      },
      onExit: (e) {
        setState(() => hover = false);
        PowerDataHandler.hoveringOn(null);
      },
      child: Tooltip(
        message: widget.fileEntity.path,
        child: GestureDetector(
          onTap: () {
            EntityUtils.inject(widget.fileEntity.entity);
          },
          onSecondaryTap: () {
            showInfoDialog(
                context, widget.fileEntity.entity, "File System Object");
          },
          child: AnimatedContainer(
            duration: getDuration(milliseconds: 250),
            curve: Curves.easeIn,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: PowerModeTheme.collectionCardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: hover
                  ? [
                      BoxShadow(
                        color: PowerModeTheme.collectionCardDropShadowColor,
                        blurRadius: 16,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                Align(
                  child: Row(
                    children: [
                      const Gap(20),
                      LimitedBox(
                        maxWidth: 300,
                        child: Text(
                          widget.fileEntity.name,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.fontSize(14).makeMedium(),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedOpacity(
                        duration: getDuration(milliseconds: 250),
                        curve: Curves.easeIn,
                        opacity: hover ? 1.0 : 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: PowerModeTheme.background,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: PowerModeTheme.cardDropShadowColor,
                                blurRadius: 16,
                              )
                            ],
                          ),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.fileEntity.entity.markAsDeleted();
                                  widget.onRebuildRequested();
                                },
                                tooltip: 'Remove',
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                iconSize: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  copy(widget.fileEntity.entity);
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
                                      'file://${widget.fileEntity.parentPath}');
                                },
                                tooltip: 'Open Containing Folder',
                                icon: Icon(
                                  Icons.folder_copy_outlined,
                                  color: Colors.grey.shade600,
                                ),
                                iconSize: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  launchUrlString(
                                      'file://${widget.fileEntity.path}');
                                },
                                tooltip: 'Open',
                                icon: const Icon(
                                  Icons.open_in_new_rounded,
                                  color: Colors.grey,
                                ),
                                iconSize: 20,
                              ),
                            ],
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
    );
  }
}
