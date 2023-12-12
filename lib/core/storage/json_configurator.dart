import 'dart:convert';
import 'dart:io';

import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/utils.dart';

const jsonEncoder = JsonEncoder.withIndent("  ");

class JsonConfigurator {
  final String configName;
  late String configPath;
  dynamic config;

  JsonConfigurator({
    required this.configName,
    this.config,
  }) {
    configPath = combineHomePath([".config", "cliptopia", configName]);
    _load();
  }

  void _load() {
    config = jsonDecode("{}");
    try {
      File file = File(configPath);
      if (file.existsSync()) {
        config = jsonDecode(file.readAsStringSync());
      } else {
        // Creating raw session config
        file.createSync();
        file.writeAsStringSync("{}", flush: true);
        onNewCreation();
      }
    } catch (error, stackTrace) {
      prettyLog(
          value:
              "Permission Denied when Creating Configuration: $configName, cannot continue!",
          type: DebugType.error);
      stdout.writeln(stackTrace);
      rethrow;
    }
  }

  void onNewCreation() {
    // called when the config file is auto created!
  }

  void reload() {
    _load();
  }

  void overwriteAndReload(String content) {
    File file = File(configPath);
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsStringSync(content, flush: true);
    _load();
  }

  void put(key, value) {
    config[key] = value;
    save();
  }

  void add(key, value) {
    var list = config[key];
    if (list != null) {
      config[key] = {...list, value}.toList();
    } else {
      config[key] = [value];
    }
    save();
  }

  void remove(key, value) {
    var list = config[key];
    if (list != null) {
      list.remove(value);
      config[key] = list;
    } else {
      config[key] = [];
    }
    save();
  }

  dynamic get(key) {
    return config[key];
  }

  void save() {
    try {
      File(configPath)
          .writeAsStringSync(jsonEncoder.convert(config), flush: true);
    } catch (error, stackTrace) {
      prettyLog(
          value: "Permission Denied when Saving Configuration: $configName",
          type: DebugType.error);
      stdout.writeln(error);
      stdout.writeln(stackTrace);
    }
  }
}
