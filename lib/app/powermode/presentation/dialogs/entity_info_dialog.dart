import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity_info.dart';
import 'package:cliptopia/app/powermode/presentation/power_mode_app.dart';
import 'package:cliptopia/app/settings/presentation/widgets/option.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

final _localFocusNode = FocusNode();

class EntityInfoDialog extends StatefulWidget {
  const EntityInfoDialog({
    super.key,
    required this.entity,
    required this.info,
    required this.representationType,
    required this.onSave,
    required this.onClear,
  });

  final ClipboardEntity entity;
  final EntityInfo info;
  final String representationType;
  final VoidCallback onSave;
  final VoidCallback onClear;

  @override
  State<EntityInfoDialog> createState() => _EntityInfoDialogState();
}

class _EntityInfoDialogState extends State<EntityInfoDialog> {
  late final TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController(text: widget.info.comment);
  }

  Widget _buildKeyValuePair(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Text(
            "$key:",
            style: AppTheme.fontSize(16).makeMedium(),
          ),
          const Gap(10),
          Expanded(
            child: Tooltip(
              message: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.fontSize(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 600,
          height: 450,
          decoration: BoxDecoration(
            color: PowerModeTheme.background,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(PowerModeTheme.dropShadowOpacity),
                blurRadius: 48,
              ),
            ],
          ),
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Clipboard Item Info",
                    style: AppTheme.fontSize(32).makeMedium(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: "Clear this item's preferences",
                        onPressed: () {
                          widget.onClear();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cleaning_services,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                      ),
                      const Gap(10),
                      IconButton(
                        onPressed: () {
                          widget.info.comment = commentController.text;
                          widget.onSave();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.done,
                          color: AppTheme.foreground,
                        ),
                        iconSize: 32,
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(4),
              _buildKeyValuePair("Type", widget.representationType),
              _buildKeyValuePair("Item ID", widget.info.refID),
              _buildKeyValuePair("Last Used At",
                  "${DateFormat.yMMMMEEEEd('en_us').format(widget.entity.time)} ${DateFormat('K:mm:ss a').format(widget.entity.time)}"),
              if (widget.entity.type != ClipboardEntityType.text) ...[
                _buildKeyValuePair("Storage Location", widget.entity.data),
              ],
              const Gap(20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Option(
                      title: "Mark as sensitive",
                      description:
                          "Helps you to hide any sensitive item from appearing",
                      active: widget.info.sensitive,
                      icon: AppIcons.hide,
                      noPadding: true,
                      onChanged: (enabled) {
                        setState(() {
                          widget.info.sensitive = !widget.info.sensitive;
                        });
                      },
                    ),
                    const Gap(20),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppIcons.comment,
                            width: 48,
                            height: 48,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(width: 11),
                          SizedBox(
                            width: 400,
                            height: 45,
                            child: TextField(
                              controller: commentController,
                              focusNode: _localFocusNode,
                              style: AppTheme.fontSize(14).makeBold(),
                              onSubmitted: (_) {
                                widget.info.comment = commentController.text;
                                widget.onSave();
                                Navigator.pop(context);
                              },
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurpleAccent,
                                      width: 1.5),
                                ),
                                labelText: "Comment on this item",
                                labelStyle: AppTheme.fontSize(16),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    commentController.text = "";
                                  },
                                  icon: Icon(
                                    Icons.delete_sweep_outlined,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showInfoDialog(
    BuildContext context, ClipboardEntity entity, String representationType) {
  EntityInfo infoObject = entity.info;
  EntityInfo info = EntityInfo.clone(infoObject);
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return EntityInfoDialog(
        entity: entity,
        info: info,
        representationType: representationType,
        onSave: () {
          if (info != infoObject) {
            infoObject.use(info);
            rebuildView(message: "An Item's info has been modified");
          }
        },
        onClear: () {
          infoObject.remove();
        },
      );
    },
  );
  Future.delayed(
    getDuration(milliseconds: 100),
    () => _localFocusNode.requestFocus(),
  );
}
