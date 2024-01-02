import 'dart:io';

import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/core/powermode/power_data_handler.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final Map<PowerImageFilterType, double> commonAspectRatios = {
  PowerImageFilterType.i16By9: 16 / 9,
  PowerImageFilterType.i9By16: 9 / 16,
  PowerImageFilterType.i3By5: 3 / 5,
  PowerImageFilterType.i5By3: 5 / 3,
  PowerImageFilterType.i4By3: 4 / 3,
  PowerImageFilterType.i3By4: 3 / 4,
  PowerImageFilterType.i1: 1,
  PowerImageFilterType.i3By2: 3 / 2,
  PowerImageFilterType.i2By3: 2 / 3,
  PowerImageFilterType.i8By5: 8 / 5,
  PowerImageFilterType.i5By8: 5 / 8,
};

String convertDateFilterToText(PowerDateFilterType type) {
  switch (type) {
    case PowerDateFilterType.today:
      return "Today";
    case PowerDateFilterType.last7Days:
      return "Last 7 Days";
    case PowerDateFilterType.last30Days:
      return "Last 30 Days";
    case PowerDateFilterType.allTime:
      return "All Time";
    case PowerDateFilterType.custom:
      return "Custom (${DateFormat.yMMMMd('en_US').format(PowerDataHandler.date.startDate!)} - ${DateFormat.yMMMMd('en_US').format(PowerDataHandler.date.endDate!)})";
  }
}

PowerDateFilterType convertTextToDateFilter(String text) {
  switch (text) {
    case "Today":
      return PowerDateFilterType.today;
    case "Last 7 Days":
      return PowerDateFilterType.last7Days;
    case "Last 30 Days":
      return PowerDateFilterType.last30Days;
    case "All Time":
      return PowerDateFilterType.allTime;
    default:
      return PowerDateFilterType.custom;
  }
}

String convertImageFilterToText(PowerImageFilterType type) {
  switch (type) {
    case PowerImageFilterType.all:
      return "All Sizes";
    case PowerImageFilterType.i16By9:
      return "16 : 9";
    case PowerImageFilterType.i9By16:
      return "9 : 16";
    case PowerImageFilterType.i3By5:
      return "3 : 5";
    case PowerImageFilterType.i5By3:
      return "5 : 3";
    case PowerImageFilterType.i4By3:
      return "4 : 3";
    case PowerImageFilterType.i3By4:
      return "3 : 4";
    case PowerImageFilterType.i1:
      return "1 : 1";
    case PowerImageFilterType.i3By2:
      return "3 : 2";
    case PowerImageFilterType.i2By3:
      return "2 : 3";
    case PowerImageFilterType.i8By5:
      return "8 : 5";
    case PowerImageFilterType.i5By8:
      return "5 : 8";
  }
}

PowerImageFilterType getClosestAspectRatio(int width, int height) {
  double aspectRatio = width / height;

  PowerImageFilterType closestRatio = commonAspectRatios.keys.reduce((a, b) {
    if ((aspectRatio - commonAspectRatios[a]!).abs() <
        (aspectRatio - commonAspectRatios[b]!).abs()) {
      return a;
    }
    return b;
  });

  return closestRatio;
}

Size convertImageFilterTo2D(PowerImageFilterType type, {prefHeight = 128.57}) {
  double ratio = commonAspectRatios[type]!;
  double width = prefHeight * ratio;
  return Size(width, prefHeight);
}

Color? identifyColor(String data) {
  try {
    String hexCode = data.replaceAll("#", "").replaceAll("0x", "");

    int intValue = int.parse(hexCode, radix: 16);

    if (hexCode.length == 6) {
      return Color(intValue | 0xFF000000);
    } else if (hexCode.length == 8) {
      return Color(intValue);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

String colorToHex(Color color) {
  String alpha = color.alpha.toRadixString(16).padLeft(2, '0');
  String red = color.red.toRadixString(16).padLeft(2, '0');
  String green = color.green.toRadixString(16).padLeft(2, '0');
  String blue = color.blue.toRadixString(16).padLeft(2, '0');

  String hexCode = '#$red$green$blue$alpha';

  return hexCode;
}

class IncognitoLock {
  IncognitoLock._();

  static File lockFile =
      File(combineHomePath(['.config', 'cliptopia', '.incognito-mode']));

  static void apply() {
    if (!isLocked()) {
      lockFile.createSync();
    }
  }

  static void remove() {
    if (isLocked()) {
      lockFile.deleteSync();
    }
  }

  static bool isLocked() {
    return lockFile.existsSync();
  }
}

Duration getDuration({int milliseconds = 0, int seconds = 0, int minutes = 0}) {
  final isAnimationOn = Storage.get(StorageKeys.animationEnabledKey,
      fallback: StorageValues.defaultAnimationEnabledKey);

  if (!isAnimationOn) {
    return Duration.zero;
  }
  return Duration(milliseconds: milliseconds, seconds: seconds, minutes: minutes);
}