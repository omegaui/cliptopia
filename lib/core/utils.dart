import 'dart:io';
import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/app_session.dart';
import 'package:cliptopia/core/argument_handler.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:dart_emoji/dart_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';

Map<String, Size> decodedImages = {};

String combinePath(List<String> locations, {bool absolute = false}) {
  String path = locations.join(Platform.pathSeparator);
  return absolute ? File(path).absolute.path : path;
}

String combineHomePath(List<String> locations, {bool absolute = false}) {
  locations.insert(0, Platform.environment['HOME']!);
  return combinePath(locations, absolute: absolute);
}

void mkdir(String path, String logMessage) {
  var dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync();
    prettyLog(value: logMessage);
  }
}

bool containsIgnoreCase(String mainString, String subString) {
  final mainLower = mainString.toLowerCase();
  final subLower = subString.toLowerCase();
  return mainLower.contains(subLower);
}

String _pgrep(pattern) {
  return Process.runSync('pgrep', ['-x', pattern]).stdout;
}

int getMonitorCount() {
  if (ArgumentHandler.isDebugMode()) {
    return 3; // for enabling the full settings interface
  }
  return WidgetsBinding.instance.platformDispatcher.views.length;
}

bool isMultiMonitorSetup() {
  return getMonitorCount() > 1;
}

bool isDaemonAlive() {
  final daemonProcess = _pgrep('cliptopia-daemon');
  final devProcess = _pgrep('dart:cliptopia_');
  final prodProcess = _pgrep('dart:cliptopia-');
  return daemonProcess.isNotEmpty ||
      devProcess.isNotEmpty ||
      prodProcess.isNotEmpty;
}

// String getSystemTheme() {
//   ProcessResult result = Process.runSync('gsettings', [
//     'get',
//     'org.gnome.desktop.interface',
//     'color-scheme',
//   ]);
//   return result.stdout.contains('dark') ? 'dark' : 'light';
// }

void copy(ClipboardEntity entity, {mode = "default"}) {
  final temp = File('/tmp/.cliptopia-temp-text-data');
  ProcessResult? result;
  prettyLog(value: "Copying data ...");
  if (entity.type != ClipboardEntityType.image) {
    final sourceFile = File(entity.data);
    if (mode == 'copy-file') {
      temp.writeAsStringSync("file://${entity.data}", flush: true);
    } else if (mode != 'copy-path' &&
        sourceFile.existsSync() &&
        (Storage.get('copy-contents') ?? false) &&
        lookupMimeType(entity.data) != 'application/octet-stream') {
      temp.writeAsStringSync(sourceFile.readAsStringSync(), flush: true);
    } else {
      temp.writeAsStringSync(entity.data, flush: true);
    }
    // copying using xclip
    result = Process.runSync(
      Storage.copyScript.path,
      mode == 'copy-file' ? ['text/uri-list'] : ['text/plain'],
    );
  } else {
    temp.writeAsBytesSync(File(entity.data).readAsBytesSync(), flush: true);
    // copying using xclip
    result = Process.runSync(
      Storage.copyScript.path,
      ['image/png'],
    );
  }
  prettyLog(
      value: "Copy Operation completed with exit code ${result.exitCode}",
      type: DebugType.statusCode);
  Messenger.show("Copied to Clipboard!");
  prettyLog(value: "Copied to clipboard ... ");
}

void paste(ClipboardEntity entity) {
  Future.delayed(const Duration(milliseconds: 250), () {
    prettyLog(value: "Pasting data ...");
    final result = Process.runSync(
      'java',
      entity.type == ClipboardEntityType.image
          ? ['Injector', '--standard']
          : ['Injector'],
      workingDirectory: combineHomePath(['.config', 'cliptopia', 'scripts']),
    );
    prettyLog(
        value: "Paste Operation completed with exit code ${result.exitCode}",
        type: DebugType.statusCode);
    if (ArgumentHandler.isSilentMode() &&
        (Storage.get('exit-on-paste') ?? true)) {
      Injector.find<AppSession>().endSession();
    } else {
      appWindow.show();
    }
  });
}

String getBugReportPath(String reportID) {
  return "file://${Platform.environment['HOME']}/.config/cliptopia/bug-reports/$reportID.md";
}

Future<Size> getImageSize(String path) async {
  if (decodedImages.containsKey(path)) {
    return decodedImages[path]!;
  }
  final decodedImage = await decodeImageFromList(File(path).readAsBytesSync());
  final size =
      Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
  decodedImages[path] = size;
  return size;
}

class CommandUtils {
  CommandUtils._();

  static void execute(command) async {
    final process = await Process.start(
      Storage.commandExecutorScript.path,
      [command],
    );
    if ((await process.exitCode) == 1) {
      Messenger.show("No Supported Terminal Found", type: MessageType.severe);
    }
  }
}

class EntityUtils {
  EntityUtils._();

  static final RegExp _commandRegex = RegExp(r'^[a-z][a-zA-Z0-9_"-]*\s+.*$');

  static final imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'ico',
  ];

  static final _videoExtensions = [
    '.mp4',
    '.avi',
    '.mkv',
    '.mov',
    '.wmv',
    '.flv',
    '.webm',
    '.mpg',
    '.mpeg',
    '.m4v',
    '.3gp',
    '.ogg',
    '.ogv',
    '.vob',
    '.divx',
  ];

  static final _audioExtensions = [
    '.mp3',
    '.wav',
    '.flac',
    '.aac',
    '.m4a',
    '.ogg',
    '.wma',
    '.amr',
    '.aiff',
    '.mid',
    '.midi',
    '.ac3',
    '.ape',
  ];

  static bool isVideo(ClipboardEntity entity) {
    if (entity.type != ClipboardEntityType.path) {
      return false;
    }
    String path = entity.data;
    String name = path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
    String ext = "";
    if (name.contains('.')) {
      ext = name.substring(name.lastIndexOf('.'));
    }
    return _videoExtensions.contains(ext);
  }

  static bool isAudio(ClipboardEntity entity) {
    if (entity.type != ClipboardEntityType.path) {
      return false;
    }
    String path = entity.data;
    String name = path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
    String ext = "";
    if (name.contains('.')) {
      ext = name.substring(name.lastIndexOf('.'));
    }
    return _audioExtensions.contains(ext);
  }

  static bool isVideoOrAudio(ClipboardEntity entity) {
    return isVideo(entity) || isAudio(entity);
  }

  static bool isFilterPatternApplicable(
      String pattern, ClipboardEntity entity) {
    if (entity.type != ClipboardEntityType.path) {
      return false;
    }
    String path = entity.data;
    String name = path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);
    String ext = "";
    if (name.contains('.')) {
      ext = name.substring(name.lastIndexOf('.'));
    }
    return ext.isNotEmpty && ext.endsWith(pattern);
  }

  static void filter(List<ClipboardEntity> entities, Filter currentFilter) {
    switch (currentFilter.filterMode) {
      case FilterMode.builtin:
        BuiltinFilterPattern pattern = currentFilter.pattern;
        switch (pattern) {
          case BuiltinFilterPattern.image:
            entities.removeWhere(
                (entity) => entity.type != ClipboardEntityType.image);
            break;
          case BuiltinFilterPattern.video:
            entities.removeWhere((entity) => !EntityUtils.isVideo(entity));
            break;
          case BuiltinFilterPattern.audio:
            entities.removeWhere((entity) => !EntityUtils.isAudio(entity));
            break;
          case BuiltinFilterPattern.files:
            entities.removeWhere(
                (entity) => entity.type != ClipboardEntityType.path);
            break;
          case BuiltinFilterPattern.none:
          // no filter applied
        }
        break;
      case FilterMode.custom:
        entities
            .removeWhere((entity) => entity.type != ClipboardEntityType.path);
        entities.removeWhere((entity) => !EntityUtils.isFilterPatternApplicable(
            currentFilter.pattern, entity));
    }
  }

  static void search(List<ClipboardEntity> entities, String text) {
    entities.removeWhere((entity) {
      if (entity.type == ClipboardEntityType.image) {
        return true;
      }
      return !entity.data.contains(text);
    });
  }

  static void filterOnlyNotes(List<ClipboardEntity> entities) {
    entities.removeWhere((entity) {
      if (entity.type != ClipboardEntityType.text) {
        return true;
      }
      final data = entity.data;
      if (data.length == 1 || isEmoji(data) || _commandRegex.hasMatch(data)) {
        return true;
      }
      return false;
    });
  }

  static void filterOnlyCommands(List<ClipboardEntity> entities) {
    entities.removeWhere((entity) {
      if (entity.type != ClipboardEntityType.text) {
        return true;
      }
      return !isCommandImpl(entity.data);
    });
  }

  static bool isCommandImpl(String data) {
    if (data.length == 1 ||
        !data.contains(" ") ||
        isEmoji(data) ||
        !_commandRegex.hasMatch(data)) {
      return false;
    }
    String executable = data.substring(0, data.indexOf(' '));
    return doesCommandExists(executable);
  }

  static bool doesCommandExists(String command) {
    final output = Process.runSync('whereis', [command]).stdout.toString();
    final hasPathAfterColon = output[output.indexOf(':') + 1] == ' ';
    return hasPathAfterColon;
  }

  static void inject(ClipboardEntity entity) {
    copy(entity);
    appWindow.hide();
    paste(entity);
  }

  static bool isCommand(ClipboardEntity entity) {
    return isCommandImpl(entity.data);
  }
}

bool isEmoji(String data) {
  return EmojiUtil.hasOnlyEmojis(data);
}

Future<bool> isImageValid(List<int> rawList) async {
  final uInt8List =
      rawList is Uint8List ? rawList : Uint8List.fromList(rawList);

  try {
    final codec = await instantiateImageCodec(uInt8List);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image.width > 0;
  } catch (e) {
    return false;
  }
}

Future<bool> doesCommandExists(String executable, String helpFlag) async {
  final result = await Process.run(executable, [helpFlag]);
  return (result.exitCode == 0 || result.stderr.toString().isEmpty);
}
