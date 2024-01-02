import 'package:cliptopia/app/powermode/domain/entity/text_entity.dart';
import 'package:cliptopia/app/powermode/presentation/dialogs/entity_info_dialog.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/tiles/text_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TextCard extends StatefulWidget {
  const TextCard({
    super.key,
    required this.textEntity,
    required this.onRebuildRequested,
  });

  final TextEntity textEntity;
  final VoidCallback onRebuildRequested;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  bool hover = false;
  bool isMultiLine = false;

  @override
  void initState() {
    super.initState();
    isMultiLine = widget.textEntity.text.contains('\n');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() => hover = true);
        PowerDataHandler.hoveringOn(widget.textEntity.entity);
      },
      onExit: (e) {
        setState(() => hover = false);
        PowerDataHandler.hoveringOn(null);
      },
      child: Tooltip(
        message: isMultiLine ? widget.textEntity.text : "",
        child: GestureDetector(
          onTap: () {
            EntityUtils.inject(widget.textEntity.entity);
          },
          onSecondaryTap: () {
            showInfoDialog(context, widget.textEntity.entity, "Text");
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
                      Expanded(
                        child: Text(
                          TextTile.getRepresentableText(widget.textEntity.text),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTheme.fontSize(14).makeMedium(),
                        ),
                      ),
                      if (isMultiLine) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.transit_enterexit,
                            color: AppTheme.foreground.withOpacity(0.3),
                            size: 14,
                          ),
                        ),
                      ],
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
                                  widget.textEntity.entity.markAsDeleted();
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
                                  copy(widget.textEntity.entity);
                                },
                                tooltip: 'Copy',
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.blue,
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
