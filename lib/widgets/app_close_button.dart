import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/app_session.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:flutter/material.dart';

class AppCloseButton extends StatefulWidget {
  const AppCloseButton({
    super.key,
  });

  @override
  State<AppCloseButton> createState() => _AppCloseButtonState();
}

class _AppCloseButtonState extends State<AppCloseButton> {
  bool hover = false;

  void onMouseEnter(e) {
    setState(() => hover = true);
  }

  void onMouseExit(e) {
    setState(() => hover = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: onMouseEnter,
      onExit: onMouseExit,
      child: GestureDetector(
        onTap: () {
          Injector.find<AppSession>().endSession();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.closeButtonSurfaceColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(0),
            ),
          ),
          child: Center(
            child: AnimatedScale(
              duration: getDuration(milliseconds: 250),
              scale: hover ? 1.0 : 1.3,
              curve: Curves.decelerate,
              child: const Icon(
                Icons.close,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
