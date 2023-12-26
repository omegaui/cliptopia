import 'dart:io';

import 'package:cliptopia/constants/meta_info.dart';
import 'package:cliptopia/core/argument_handler.dart';

enum DebugType { error, info, warning, url, response, statusCode }

final _sessionLog = File(MetaInfo.sessionLogFilePath);

void initSessionLog() {
  if (_sessionLog.existsSync()) {
    _sessionLog.deleteSync();
    _sessionLog.writeAsStringSync(
        "-----------------Logs of Cliptopia running in release mode-----------------\n",
        flush: true);
    _sessionLog.writeAsStringSync(">> Date: ${DateTime.now()}\n", flush: true);
  }
}

prettyLog({
  String? tag,
  required dynamic value,
  DebugType type = DebugType.info,
}) {
  if (!ArgumentHandler.isDebugMode()) {
    _sessionLog.writeAsStringSync(
      "[${tag ?? "LOG"}] $value\n",
      flush: true,
      mode: FileMode.append,
    );
    return;
  }
  switch (type) {
    case DebugType.statusCode:
      stdout.writeln(
          '\x1B[33m${"💎 STATUS CODE ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.info:
      stdout.writeln("⚡ ${tag != null ? "$tag: " : ""}$value");
      break;
    case DebugType.warning:
      stdout.writeln(
          '\x1B[36m${"⚠️ Warning ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.error:
      stdout.writeln(
          '\x1B[31m${">> ERROR ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.response:
      stdout.writeln(
          '\x1B[36m${">> ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.url:
      stdout.writeln(
          '\x1B[34m${">> URL ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
  }
}
