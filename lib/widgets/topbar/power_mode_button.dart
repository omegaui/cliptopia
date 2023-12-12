import 'dart:io';

import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:cliptopia/core/app_session.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:flutter/material.dart';

class PowerModeButton extends StatefulWidget {
  const PowerModeButton({
    super.key,
  });

  @override
  State<PowerModeButton> createState() => _PowerModeButtonState();
}

class _PowerModeButtonState extends State<PowerModeButton> {
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
        onTap: () async {
          await Process.start('cliptopia', ['--silent', '--power']);
          Injector.find<AppSession>().endSession();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.buttonSurfaceColor,
            borderRadius: BorderRadius.circular(hover ? 15 : 30),
          ),
          child: Center(
            child: Image.asset(
              AppIcons.tiny,
              width: 32,
              height: 32,
            ),
          ),
        ),
      ),
    );
  }
}
