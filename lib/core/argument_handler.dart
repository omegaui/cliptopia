late List<String> _arguments;

class ArgumentHandler {
  ArgumentHandler._();

  static const _args = [
    '--debug',
    '--silent',
    '--power',
    '--version',
    '--daemon-compatible-version',
    '--help',
  ];

  static void init(List<String> arguments) {
    _arguments = arguments;
  }

  static bool shouldShowHelp() {
    return _arguments.contains('--help');
  }

  static bool shouldShowVersion() {
    return _arguments.contains('--version');
  }

  static bool shouldShowDaemonCompatibleVersion() {
    return _arguments.contains('--daemon-compatible-version');
  }

  static bool isDebugMode() {
    return _arguments.contains('--debug');
  }

  static bool isSilentMode() {
    return _arguments.contains('--silent');
  }

  static bool isPowerMode() {
    return _arguments.contains('--power');
  }

  static bool validate() {
    for (final arg in _arguments) {
      if (!_args.contains(arg)) {
        return false;
      }
    }
    return true;
  }

  static Iterable<String> getUnknownOptions() sync* {
    for (final arg in _arguments) {
      if (!_args.contains(arg)) {
        yield arg;
      }
    }
  }
}
