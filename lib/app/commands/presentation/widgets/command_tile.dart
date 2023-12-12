import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';

class CommandTile extends StatelessWidget {
  const CommandTile({
    super.key,
    required this.entity,
  });

  final ClipboardEntity entity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 640,
      height: 52,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.commandTileColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Align(
            child: GestureDetector(
              onTap: () {
                EntityUtils.inject(entity);
              },
              onSecondaryTap: () {
                CommandUtils.execute(entity.data);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Tooltip(
                  message: entity.data,
                  child: Row(
                    children: [
                      const SizedBox(width: 17),
                      Text(
                        "\$ ",
                        style: AppTheme.fontSize(16).makeBold(),
                      ),
                      SizedBox(
                        width: 540,
                        child: Text(
                          _getRepresentableText(entity.data).trim(),
                          overflow: TextOverflow.fade,
                          style: AppTheme.fontSize(16),
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
            child: Padding(
              padding: const EdgeInsets.only(right: 7.0, top: 7.0),
              child: GestureDetector(
                onTap: () => copy(entity),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Icon(
                    Icons.copy,
                    color: AppTheme.commandTileCopyButtonColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRepresentableText(String data) {
    if (data.contains('\n')) {
      return data.substring(0, data.indexOf('\n'));
    }
    return data;
  }
}
