import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

enum MessageType {
  normal,
  severe,
  warning,
}

class Messenger {
  Messenger._();

  static final GlobalKey<_MessageBirdState> _birdKey = GlobalKey();

  static void show(String message, {MessageType type = MessageType.normal}) {
    if (_birdKey.currentState != null) {
      _birdKey.currentState!.show(message, type);
    }
  }
}

class MessageBird extends StatefulWidget {
  const MessageBird({super.key});

  @override
  State<MessageBird> createState() => _MessageBirdState();

  static MessageBird create() {
    return MessageBird(key: Messenger._birdKey);
  }
}

class _MessageBirdState extends State<MessageBird>
    with SingleTickerProviderStateMixin<MessageBird> {
  late AnimationController flightController;

  String message = "";
  MessageType type = MessageType.normal;

  bool flightCompleted = true;
  bool descending = false;
  bool ascending = false;
  bool hangInMiddle = false;

  @override
  void initState() {
    super.initState();
    flightController = AnimationController(
      vsync: this,
    );
  }

  void show(String message, MessageType type) {
    if (!flightCompleted) {
      return;
    }
    setState(() {
      this.message = message;
      this.type = type;
      flightCompleted = false;
    });
    Future(() async {
      // ascending to the top ...
      flightController
          .animateTo(1,
              duration: const Duration(milliseconds: 500), curve: Curves.easeIn)
          .whenComplete(() async {
        setState(() {
          ascending = true;
          descending = false;
          hangInMiddle = false;
        });
        await Future.delayed(const Duration(milliseconds: 250));
        setState(() {
          hangInMiddle = true;
        });
        await Future.delayed(const Duration(milliseconds: 1500));
        flightController
            .animateBack(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn)
            .whenComplete(() async {
          setState(() {
            ascending = false;
            descending = true;
            hangInMiddle = false;
          });
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              descending = false;
              flightCompleted = true;
              flightController.reset();
            });
          });
        });
      });
    });
  }

  Offset _getOffset() {
    if (hangInMiddle) {
      return const Offset(0, -3);
    }
    if (ascending) {
      return const Offset(0, -3);
    } else if (descending) {
      return const Offset(2, 3);
    }
    return const Offset(-2, 1);
  }

  double _getTurns() {
    if (!hangInMiddle) {
      if (ascending) {
        return -0.139626;
      } else if (descending) {
        return 0.139626;
      }
    }
    return 0;
  }

  double _getScale() {
    if (ascending) {
      return 1.0;
    } else if (descending) {
      return 0.0;
    } else if (hangInMiddle) {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case MessageType.normal:
        return Icons.notifications_on_outlined;
      case MessageType.severe:
        return Icons.error_outline;
      case MessageType.warning:
        return Icons.warning_outlined;
    }
  }

  Color _getColor() {
    switch (type) {
      case MessageType.normal:
        return AppTheme.messageBirdColor;
      case MessageType.severe:
        return AppTheme.messageBirdErrorColor;
      case MessageType.warning:
        return AppTheme.messageBirdWarningColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedScale(
        scale: _getScale(),
        duration: const Duration(milliseconds: 500),
        child: AnimatedSlide(
          offset: _getOffset(),
          duration: const Duration(milliseconds: 500),
          child: AnimatedRotation(
            turns: _getTurns(),
            duration: const Duration(seconds: 1),
            child: FittedBox(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIcon(),
                        color: Colors.white,
                      ),
                      const Gap(5),
                      Text(
                        message,
                        style: AppTheme.fontSize(16).withColor(Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
