import 'package:cliptopia/config/assets/app_icons.dart';
import 'package:cliptopia/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Widget buildFeatureList() {
  Widget createHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTheme.fontSize(12),
      ),
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: 100,
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppIcons.smooth,
            ),
            createHeading("Silent & Smooth"),
          ],
        ),
      ),
      const Gap(20),
      SizedBox(
        width: 100,
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppIcons.filtering,
            ),
            createHeading("Ultimate Filtering"),
          ],
        ),
      ),
      const Gap(20),
      SizedBox(
        width: 100,
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppIcons.cache,
            ),
            createHeading("Advanced Cache Management"),
          ],
        ),
      ),
      const Gap(20),
      SizedBox(
        width: 100,
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppIcons.magic,
            ),
            createHeading("You'll Love it!"),
          ],
        ),
      ),
    ],
  );
}
