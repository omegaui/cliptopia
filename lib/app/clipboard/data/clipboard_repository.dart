import 'dart:io';

import 'package:cliptopia/constants/meta_info.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:http/http.dart';

class ClipboardRepository {
  final _database = Injector.find<Database>();

  void integrateDaemon() {
    Process.runSync('chmod', [
      '+x',
      MetaInfo.daemonDownloadedBinaryPath,
    ]);
    Process.runSync('pkexec', [
      'mv',
      MetaInfo.daemonDownloadedBinaryPath,
      '/usr/bin/cliptopia-daemon',
    ]);
  }

  void downloadDaemon({
    required RebuildCallback onDownloadComplete,
    required RebuildCallback onError,
  }) async {
    Response? response;
    try {
      response = await get(Uri.parse(MetaInfo.daemonDownloadUrl));
    } on Exception {
      onError();
      return;
    }
    if (response.statusCode == 200) {
      File(MetaInfo.daemonDownloadedBinaryPath)
          .writeAsBytesSync(response.bodyBytes);
      onDownloadComplete();
    } else {
      onError();
      throw Exception(
          "Got ${response.statusCode} from raw.githubusercontent.com");
    }
  }

  bool isDaemonIntegrated() {
    const command = 'cliptopia-daemon';
    try {
      final output = Process.runSync(command, ['--version']).stdout;
      final containsVersion = output.contains('version');
      return containsVersion;
    } catch (_) {
      return false;
    }
  }

  Future<void> startDaemonIfNotRunning() async {
    if (isDaemonAlive()) {
      prettyLog(value: "Daemon is already running ...");
      return;
    }
    prettyLog(value: "Starting Daemon ...");
    final lockFile = File('/tmp/.cliptopia-daemon-lock');
    if (lockFile.existsSync()) {
      lockFile.deleteSync();
    }
    const command = 'cliptopia-daemon';
    await Process.start(command, ['--start']);
    // Giving time to Daemon to read the clipboard and create the first entry
    await Future.delayed(const Duration(seconds: 2));
  }

  bool hasObjects() {
    return _database.isNotEmpty;
  }
}
