import 'package:cliptopia/core/utils.dart';

class MetaInfo {
  MetaInfo._();

  static String get version => "v1.0.0+3";
  static String get daemonCompatibleVersion => "v0.0.3";
  static const daemonDownloadUrl =
      "https://github.com/omegaui/cliptopia_daemon/raw/master/cliptopia-daemon";
  static final daemonDownloadedBinaryPath = combineHomePath([
    '.config',
    'cliptopia',
    'cliptopia-daemon',
  ]);
  static final sessionLogFilePath = combineHomePath([
    '.config',
    'cliptopia',
    'session.log',
  ]);
}
