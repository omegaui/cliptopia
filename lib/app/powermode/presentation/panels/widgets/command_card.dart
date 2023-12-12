import 'package:cliptopia/app/powermode/domain/entity/command_entity.dart';
import 'package:cliptopia/app/powermode/presentation/dialogs/entity_info_dialog.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/tiles/text_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CommandCard extends StatefulWidget {
  const CommandCard({
    super.key,
    required this.commandEntity,
    required this.onRebuildRequested,
  });

  final CommandEntity commandEntity;
  final VoidCallback onRebuildRequested;

  @override
  State<CommandCard> createState() => _CommandCardState();
}

class _CommandCardState extends State<CommandCard> {
  bool hover = false;
  bool isMultiLine = false;

  @override
  void initState() {
    super.initState();
    isMultiLine = widget.commandEntity.command.contains('\n');
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() => hover = true);
        PowerDataHandler.hoveringOn(widget.commandEntity.entity);
      },
      onExit: (e) {
        setState(() => hover = false);
        PowerDataHandler.hoveringOn(null);
      },
      child: Tooltip(
        message: isMultiLine ? widget.commandEntity.command : "",
        child: GestureDetector(
          onTap: () {
            EntityUtils.inject(widget.commandEntity.entity);
          },
          onSecondaryTap: () {
            showInfoDialog(
                context, widget.commandEntity.entity, "Executable Command");
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
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
                          TextTile.getRepresentableText(
                              widget.commandEntity.command),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: AppTheme.fontSize(14).makeMedium(),
                        ),
                      ),
                      if (isMultiLine)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.transit_enterexit,
                            color: AppTheme.foreground.withOpacity(0.3),
                            size: 14,
                          ),
                        ),
                      const Gap(40),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: hover ? null : 40,
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
                        if (hover) ...[
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                            opacity: hover ? 1.0 : 0.0,
                            child: IconButton(
                              onPressed: () {
                                widget.commandEntity.entity.markAsDeleted();
                                widget.onRebuildRequested();
                              },
                              tooltip: 'Delete',
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              iconSize: 20,
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                            opacity: hover ? 1.0 : 0.0,
                            child: IconButton(
                              onPressed: () {
                                copy(widget.commandEntity.entity);
                              },
                              tooltip: 'Copy',
                              icon: const Icon(
                                Icons.copy,
                                color: Colors.blue,
                              ),
                              iconSize: 20,
                            ),
                          ),
                        ],
                        IconButton(
                          onPressed: () {
                            CommandUtils.execute(widget.commandEntity.command);
                          },
                          tooltip: 'Run',
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.green,
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
        ),
      ),
    );
  }
}
