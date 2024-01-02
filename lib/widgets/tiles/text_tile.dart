import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/tiles/copy_item_button.dart';
import 'package:flutter/material.dart';

class TextTile extends StatelessWidget {
  const TextTile({
    super.key,
    required this.entity,
  });

  final ClipboardEntity entity;

  @override
  Widget build(BuildContext context) {
    bool emoji = isEmoji(entity.data);
    return AnimatedContainer(
      duration: getDuration(milliseconds: 250),
      curve: Curves.easeIn,
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
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
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 15),
              child: GestureDetector(
                onTap: () => EntityUtils.inject(entity),
                child: SizedBox(
                  width: 158,
                  height: 80,
                  child: Text(
                    getRepresentableText(entity.data),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTheme.fontSize(emoji ? 52 : 12).makeBold().copyWith(
                              color: AppTheme.foreground2,
                            ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CopyItemButton(entity: entity),
          ),
        ],
      ),
    );
  }

  static Iterable<String> removeNewLineUntilStatement(String line) sync* {
    int indexOfFirstChar = 0;
    for (final char in line.characters) {
      if (char != '\n') {
        indexOfFirstChar = line.indexOf(char);
        break;
      }
    }
    yield line.substring(indexOfFirstChar);
  }

  static String getRepresentableText(String data) {
    String res = "";
    final lines = data.split('\n');
    for (var line in lines) {
      line = removeNewLineUntilStatement(line).join();
      if (line.startsWith(' ')) {
        String newLine = "";
        bool gotNonWhitespace = false;
        for (final char in line.characters) {
          if (char == ' ' && !gotNonWhitespace) {
            newLine += '.';
          } else {
            gotNonWhitespace = true;
            newLine += char;
          }
        }
        line = newLine;
      }
      if (res.isEmpty && line.isNotEmpty) {
        bool onlyNewLineChars = line.endsWith('\n') && line.trim().length == 1;
        if (onlyNewLineChars) {
          continue;
        }
      }
      if (line.isNotEmpty) {
        res += '$line\n';
      }
    }
    return res;
  }
}
