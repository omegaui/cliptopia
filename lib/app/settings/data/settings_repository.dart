import 'dart:io';

import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:flutter/services.dart';

class SettingsRepository {
  final daemonConfig = JsonConfigurator(configName: 'daemon-config.json');

  final desktopEntryPath = combinePath([
    Platform.environment['HOME']!,
    '.config',
    'autostart',
    'cliptopia-daemon.desktop',
  ]);

  void setMaintainState(bool value) {
    daemonConfig.put('maintain-state', value);
  }

  bool isMaintainingState() {
    return daemonConfig.get('maintain-state') ?? true;
  }

  void setCacheSize(value) {
    num size = num.tryParse(value) ?? 0;
    if (size == 0) {
      daemonConfig.put('limit-cache', false);
    } else {
      daemonConfig.put('limit-cache', true);
    }
    daemonConfig.put('cache-size', num.parse(value));
  }

  void setCacheUnit(value) {
    daemonConfig.put('unit', value);
  }

  void setKeepHistory(value) {
    daemonConfig.put('keep-history', value);
  }

  bool isKeepingHistory() {
    return daemonConfig.get('keep-history') ?? true;
  }

  bool isForcingXClip() {
    return daemonConfig.get('force-xclip') ?? true;
  }

  void setForceXClip(value) {
    daemonConfig.put('force-xclip', value);
  }

  int getCacheSize() {
    return daemonConfig.get('cache-size') ?? 0;
  }

  String getCacheUnit() {
    return daemonConfig.get('unit') ?? "KB";
  }

  bool isDaemonAutostart() {
    return FileSystemEntity.isFileSync(desktopEntryPath);
  }

  Future<void> setDaemonAutostart(bool value) async {
    final desktopEntry = File(desktopEntryPath);
    if (value) {
      if (desktopEntry.existsSync()) {
        desktopEntry.deleteSync();
      }
    } else {
      // Making Sure `autostart` directory already exists
      Directory autostartDir = Directory(combinePath([
        Platform.environment['HOME']!,
        '.config',
        'autostart',
      ]));
      if (!autostartDir.existsSync()) {
        autostartDir.createSync();
      }
      String desktopEntryContents =
          await rootBundle.loadString('assets/cliptopia-daemon.desktop');
      desktopEntry.writeAsStringSync(desktopEntryContents, flush: true);
    }
  }
}
