import 'package:cliptopia/app/powermode/domain/entity/text_entity.dart';
import 'package:cliptopia/app/powermode/domain/text_type.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/tiles/text_tile.dart';
import 'package:flutter/material.dart';

class StyledTextCard extends StatefulWidget {
  const StyledTextCard({
    super.key,
    required this.entity,
    required this.type,
  });

  final TextEntity entity;
  final TextType type;

  @override
  State<StyledTextCard> createState() => _StyledTextCardState();
}

class _StyledTextCardState extends State<StyledTextCard> {
  bool hover = false;

  Color getCardBackgroundColor() {
    switch (widget.type) {
      case TextType.code:
        return Colors.blue;
      case TextType.url:
        return Colors.green;
      case TextType.word:
        return Colors.brown;
      case TextType.sentence:
        return Colors.black;
      case TextType.paragraph:
        return Colors.blueGrey;
    }
  }

  Color getCardForegroundColor() {
    switch (widget.type) {
      case TextType.code:
      case TextType.url:
      case TextType.word:
      case TextType.sentence:
      case TextType.paragraph:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        EntityUtils.inject(widget.entity.entity);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (e) => setState(() => hover = true),
        onExit: (e) => setState(() => hover = false),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                    minWidth: 500,
                    minHeight: 120,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: hover ? null : 500.0,
                    height: hover ? null : 120.0,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PowerModeTheme.collectionCardColor,
                      border: Border.all(color: PowerModeTheme.cardBorderColor),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: hover
                          ? [
                              BoxShadow(
                                color: PowerModeTheme
                                    .collectionCardDropShadowColor,
                                blurRadius: 16,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      hover
                          ? widget.entity.text
                          : TextTile.getRepresentableText(widget.entity.text),
                      style: AppTheme.fontSize(14),
                    ),
                  ),
                ),
              ),
            ),
            FittedBox(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: getCardBackgroundColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    widget.type.name,
                    style: AppTheme.fontSize(14)
                        .makeMedium()
                        .withColor(getCardForegroundColor()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
