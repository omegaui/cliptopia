import 'dart:io';

class Usage {
  static void logUsage({describe = true}) {
    if (describe) {
      stdout.writeln("The state-of-the-art clipboard manager.");
      stdout.writeln(
          "See Project on GitHub: https://github.com/omegaui/cliptopia");
      stdout.writeln();
    }
    stdout.writeln("Usage: cliptopia [OPTIONS]");
    stdout.writeln("where OPTIONS could be one of these:");
    stdout.writeln();
    stdout.writeln(
        "\t--debug                              Enable printing logs to the terminal");
    stdout.writeln(
        "\t--silent                             Closes the GUI once an insertion choice is made");
    stdout.writeln(
        "\t--version                            Prints program version");
    stdout.writeln(
        "\t--silent                             Closes the app once you make a selection");
    stdout.writeln(
        "\t--power                              An Effective Mode can be triggered with Super + V");
    stdout.writeln(
        "\t--daemon-compatible-version          Prints the required daemon version");
    stdout.writeln(
        "\t--help                               Prints this help message");
  }
}
