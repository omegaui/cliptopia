import 'dart:convert';
import 'dart:io';

import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/services.dart';

class Storage {
  static late final File copyScript;
  static late final File commandExecutorScript;
  static late final JsonConfigurator _storage;

  Storage._();

  static void initSpace() async {
    mkdir(combineHomePath(['.config', 'cliptopia']),
        "Creating Cliptopia Storage Route ...");
    mkdir(combineHomePath(['.config', 'cliptopia', 'bug-reports']),
        "Creating Cliptopia Bug Reports Route ...");
    mkdir(combineHomePath(['.config', 'cliptopia', 'scripts']),
        "Creating Scripts Storage ...");
    _storage = JsonConfigurator(configName: 'app-settings.json');

    // Writing Injector ...
    final injectorFile = File(
        combineHomePath(['.config', 'cliptopia', 'scripts', 'Injector.class']));
    if (!injectorFile.existsSync()) {
      prettyLog(value: "Writing Injector ...");
      final contents = await rootBundle.load('assets/scripts/Injector.class');
      injectorFile.writeAsBytesSync(contents.buffer.asUint8List(), flush: true);
    }

    // Writing Copy Script ...
    copyScript = File(combineHomePath(
        ['.config', 'cliptopia', 'scripts', 'cliptopia-copy.sh']));
    if (!copyScript.existsSync()) {
      prettyLog(value: "Writing a script to copy files to clipboard ...");
      final contents =
          await rootBundle.loadString('assets/scripts/cliptopia-copy.sh');
      copyScript.writeAsStringSync(contents, flush: true);
      // Making it executable
      Process.runSync(
        'chmod',
        ['+x', copyScript.path],
      );
    }

    // Writing Copy Script ...
    commandExecutorScript = File(combineHomePath(
        ['.config', 'cliptopia', 'scripts', 'cliptopia-command-executor.sh']));
    if (!commandExecutorScript.existsSync()) {
      prettyLog(value: "Writing a script to launch commands ...");
      final contents = await rootBundle
          .loadString('assets/scripts/cliptopia-command-executor.sh');
      commandExecutorScript.writeAsStringSync(contents, flush: true);
      // Making it executable
      Process.runSync(
        'chmod',
        ['+x', commandExecutorScript.path],
      );
    }
  }

  static dynamic get(String key, {fallback}) {
    return _storage.get(key) ?? fallback;
  }

  static void set(String key, dynamic value) {
    _storage.put(key, value);
  }

  static bool isSensitivityOn() {
    return get(StorageKeys.sensitivity, fallback: false);
  }
}

class TempStorage {
  static final dynamic _storage = jsonDecode("{}");

  static dynamic get(String key, {fallback}) {
    return _storage[key] ?? fallback;
  }

  static void set(String key, dynamic value) {
    _storage[key] = value;
  }

  static void toggle(String key, {fallback = false}) {
    _storage[key] = !(_storage[key] ?? !fallback);
  }

  static bool canShowSensitiveContent() {
    return get(StorageKeys.sensitivity, fallback: false);
  }
}

class StorageKeys {
  StorageKeys._();

  static const hideImagePanelKey = 'hide-image-panel';
  static const sensitivity = 'sensitivity';
  static const viewMode = 'view-mode';
  static const hideEmojiPanelKey = 'hide-emoji-panel';
  static const hideColorPanelKey = 'hide-color-panel';
  static const saveDateFilerKey = 'save-date-filter';
  static const dontShowDaemonSleepingDialogKey =
      'dont-show-daemon-sleeping-dialog';
}

class StorageValues {
  StorageValues._();

  static const defaultViewMode = 'default';
  static const backgroundViewMode = 'background';
}
