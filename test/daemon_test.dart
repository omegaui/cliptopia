// Daemon Integration Test

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "Checking Daemon Integration ...",
    () {
      final daemonBin = File('/usr/bin/cliptopia-daemon');
      final exists = daemonBin.existsSync();
      expect(exists, true);
    },
  );

  test(
    "Checking Daemon Binary ...",
    () {
      const command = '/usr/bin/cliptopia-daemon';
      final output = Process.runSync(command, ['--version']).stdout;
      final containsVersion = output.contains('version');
      expect(containsVersion, true);
    },
  );

  test(
    "Starting Daemon ...",
    () async {
      const command = '/usr/bin/cliptopia-daemon';
      await Process.start(command, ['--start']);
      await Future.delayed(const Duration(seconds: 1));
      final lockFile = File(
          "${Directory.systemTemp.path}${Platform.pathSeparator}.cliptopia-daemon-lock");
      expect(lockFile.existsSync(), true);
    },
  );

  test(
    "Checking Daemon Status ...",
    () async {
      const command = '/usr/bin/cliptopia-daemon';
      final output = Process.runSync(command, ['--status']).stdout;
      final containsVersion = output.contains('Alive');
      expect(containsVersion, true);
    },
  );

  test(
    "Stopping Daemon ...",
    () async {
      const command = '/usr/bin/cliptopia-daemon';
      final output = Process.runSync(command, ['--stop']).stdout;
      final isStopped = output.contains('Stopped');
      expect(isStopped, true);
    },
  );

  test(
    "Resetting Cache ...",
    () async {
      const command = '/usr/bin/cliptopia-daemon';
      final output = Process.runSync(command, ['--reset-cache']).stdout;
      final cleared = output.contains('Cleared') || output.contains("Nothing");
      expect(cleared, true);
    },
  );
}
