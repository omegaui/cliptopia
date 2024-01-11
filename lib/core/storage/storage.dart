import 'dart:convert';
import 'dart:io';

import 'package:cliptopia/core/argument_handler.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/services.dart';

class Storage {
  static late final File copyScript;
  static late final File commandExecutorScript;
  static final File monitorIndexFile =
      File(combineHomePath(['.config', 'cliptopia', 'monitor.index']));
  static late final JsonConfigurator _storage;

  Storage._();

  static Future<void> initSpace() async {
    mkdir(combineHomePath(['.config', 'cliptopia']),
        "Creating Cliptopia Storage Route ...");
    mkdir(combineHomePath(['.config', 'cliptopia', 'bug-reports']),
        "Creating Cliptopia Bug Reports Route ...");
    mkdir(combineHomePath(['.config', 'cliptopia', 'scripts']),
        "Creating Scripts Storage ...");
    mkdir(combineHomePath(['.config', 'cliptopia', 'cache']),
        "Creating Cliptopia Cache Storage ...");
    mkdir(combineHomePath(['.config', 'cliptopia', 'cache', 'images']),
        "Creating Cliptopia Image Cache Storage ...");

    // Initializing session logger ...
    if (!ArgumentHandler.isDebugMode()) {
      initSessionLog();
    }

    // Initializing preferences storage ...
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

    // Writing Launch Script ...
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

    // Writing Exclusion Config ...
    final exclusionConfig = File(
        combineHomePath(['.config', 'cliptopia', 'exclusion-config.json']));

    if (!exclusionConfig.existsSync()) {
      prettyLog(value: "Writing the default exclusion-config ...");
      final contents =
          await rootBundle.loadString('assets/exclusion-config.json');
      exclusionConfig.writeAsStringSync(contents, flush: true);
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

  static int getSelectedMonitorIndex() {
    if (!monitorIndexFile.existsSync()) {
      return 0;
    }
    return int.tryParse(monitorIndexFile.readAsStringSync()) ?? 0;
  }

  static void setSelectedMonitorIndex(int index) {
    monitorIndexFile.writeAsStringSync("$index");
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

  static const cliptopiaPath = 'cliptopia-path';
  static const animationEnabledKey = 'animationEnabled';
  static const hideImagePanelKey = 'hide-image-panel';
  static const sensitivity = 'sensitivity';
  static const viewMode = 'view-mode';
  static const hideEmojiPanelKey = 'hide-emoji-panel';
  static const hideColorPanelKey = 'hide-color-panel';
  static const saveDateFilerKey = 'save-date-filter';
  static const clipboardLoadedKey = 'clipboard-loaded';
  static const dontShowDaemonSleepingDialogKey =
      'dont-show-daemon-sleeping-dialog';
}

class StorageValues {
  StorageValues._();

  static const defaultViewMode = 'default';
  static const backgroundViewMode = 'background';
  static const defaultCliptopiaPath =
      '/usr/bin/cliptopia'; // manual installer default
  static const defaultAnimationEnabledKey = true;
  static const defaultClipboardLoadedValue = false;
}
