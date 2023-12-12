import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final String message;
  final Color color;

  const Tag({
    super.key,
    required this.text,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Messenger.show(message);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Text(
          text,
          style: AppTheme.fontSize(12).withColor(Colors.white).makeMedium(),
        ),
      ),
    );
  }
}
