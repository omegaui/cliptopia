import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/emojis/domain/emoji_entity.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';

class EmojiTile extends StatefulWidget {
  const EmojiTile({
    super.key,
    required this.entity,
  });

  final EmojiEntity entity;

  @override
  State<EmojiTile> createState() => _EmojiTileState();
}

class _EmojiTileState extends State<EmojiTile> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () => EntityUtils.inject(ClipboardEntity('#internal',
            widget.entity.text, DateTime.now(), ClipboardEntityType.text)),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(20),
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
          child: Center(
            child: AnimatedScale(
              duration: getDuration(milliseconds: 150),
              curve: Curves.easeIn,
              scale: hover ? 1.2 : 1.0,
              child: Text(
                widget.entity.text,
                style: AppTheme.fontSize(32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
