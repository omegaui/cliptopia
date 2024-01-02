import 'package:cliptopia/app/powermode/domain/entity/recent_emoji_entity.dart';
import 'package:cliptopia/app/powermode/presentation/dialogs/entity_info_dialog.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/material.dart';

class EmojiCard extends StatefulWidget {
  const EmojiCard({
    super.key,
    required this.emojiEntity,
  });

  final RecentEmojiEntity emojiEntity;

  @override
  State<EmojiCard> createState() => _EmojiCardState();
}

class _EmojiCardState extends State<EmojiCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) {
        setState(() => hover = true);
        PowerDataHandler.hoveringOn(widget.emojiEntity.entity);
      },
      onExit: (e) {
        setState(() => hover = false);
        PowerDataHandler.hoveringOn(null);
      },
      child: GestureDetector(
        onTap: () {
          EntityUtils.inject(widget.emojiEntity.entity);
        },
        onSecondaryTap: () {
          showInfoDialog(context, widget.emojiEntity.entity, "Emoji");
        },
        child: AnimatedContainer(
          duration: getDuration(milliseconds: 250),
          curve: Curves.easeIn,
          width: 48,
          height: 48,
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
          child: Center(
            child: Text(
              widget.emojiEntity.emoji,
              style: const TextStyle(
                fontFamily: "EmojiOne",
                fontSize: 32,
                fontFamilyFallback: ["EmojiOne"],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
