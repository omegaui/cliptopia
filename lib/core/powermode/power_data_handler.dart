import 'dart:io';

import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/color_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/command_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/file_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/image_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/recent_emoji_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/text_entity.dart';
import 'package:cliptopia/app/powermode/domain/entity/typedefs.dart';
import 'package:cliptopia/app/powermode/presentation/power_mode_app.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/logger.dart';
import 'package:cliptopia/core/powermode/power_data_store.dart';
import 'package:cliptopia/core/powermode/power_utils.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';
import 'package:cliptopia/core/storage/storage.dart';
import 'package:cliptopia/core/utils.dart';
import 'package:cliptopia/widgets/message_bird.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class PowerDataHandler {
  PowerDataHandler._();

  static final dateStorage = JsonConfigurator(configName: 'date-filter.json');

  static final List<RebuildCallback> dateFilterChangeListeners = [];
  static final List<RebuildCallback> hoverChangeListeners = [];
  static final List<RebuildCallback> searchTextChangeListeners = [];
  static final List<RebuildCallback> searchTypeChangeListeners = [];

  static ClipboardEntity? hoveringEntity;

  static PowerSearchType searchType = PowerSearchType.Text;

  static SortingMode sortingMode = SortingMode.NewestFirst;

  static String searchText = "";

  static PowerDateFilterType dateFilterType = PowerDateFilterType.last7Days;

  static DateRange date = DateRange(
    startDate: DateTime.now().subtract(const Duration(days: 6)),
    endDate: DateTime.now(),
  );

  static PowerImageFilterType imageFilterType = PowerImageFilterType.all;

  static final List<ImageEntity> _images = [];
  static final List<ColorEntity> _colors = [];
  static final List<TextEntity> _texts = [];
  static final List<RecentEmojiEntity> _recentEmojis = [];
  static final List<CommandEntity> _commands = [];
  static final List<FileEntity> _files = [];

  static List<ImageEntity> get images => _images
      .where((e) =>
          (Storage.get('show-images-from-files') ?? false) ||
          e.entity.type == ClipboardEntityType.image)
      .where((e) => e.entity.time.isBetween(PowerDataHandler.date))
      .toList();

  static List<ColorEntity> get colors => _colors
      .where((e) => e.entity.time.isBetween(PowerDataHandler.date))
      .toList();

  static List<TextEntity> get texts => _texts
      .where((e) => e.entity.time.isBetween(PowerDataHandler.date))
      .toList();

  static List<RecentEmojiEntity> get recentEmojis => _recentEmojis
      .where((e) => e.entity.time.isBetween(PowerDataHandler.date))
      .toList();

  static List<CommandEntity> get commands => _commands
      .where((e) => e.entity.time.isBetween(PowerDataHandler.date))
      .toList();

  static List<FileEntity> get files => _files
      .where((e) => e.entity.time.isBetween(PowerDataHandler.date))
      .toList();

  static void init() {
    if (Storage.get('save-date-filter') ?? false) {
      if (dateStorage.get('range') != null) {
        PowerDataHandler.dateFilterType =
            convertTextToDateFilter(dateStorage.get('type'));
        useDate(PowerDataHandler.dateFilterType);
      }
    }
  }

  static void _sort(List<dynamic> list) {
    if (sortingMode == SortingMode.OldestFirst) {
      list.sort((a, b) => a.entity.time.compareTo(b.entity.time));
    } else {
      list.sort((a, b) => b.entity.time.compareTo(a.entity.time));
    }
  }

  static void toggleSortMode() {
    if (sortingMode == SortingMode.NewestFirst) {
      sortingMode = SortingMode.OldestFirst;
    } else {
      sortingMode = SortingMode.NewestFirst;
    }
    Messenger.show("Changed Sorting Mode to ${sortingMode.name}");
    _sort(_images);
    _sort(_colors);
    _sort(_texts);
    _sort(_recentEmojis);
    _sort(_commands);
    _sort(_files);
    rebuildView(message: "Switched to SortingMode.${sortingMode.name}");
  }

  static void searchTypeUpdate(PowerSearchType type) {
    searchType = type;
    Future.delayed(const Duration(milliseconds: 100), () {
      for (var fn in searchTypeChangeListeners) {
        fn();
      }
    });
  }

  static void searchTextUpdate(String text) {
    searchText = text;
    for (var fn in searchTextChangeListeners) {
      fn();
    }
  }

  static void hoveringOn(ClipboardEntity? entity) {
    hoveringEntity = entity;
    for (var fn in hoverChangeListeners) {
      fn();
    }
  }

  static void useDate(PowerDateFilterType dateFilterType, [date]) {
    PowerDataHandler.dateFilterType = dateFilterType;
    if (date != null) {
      PowerDataHandler.date = date;
    } else {
      final now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
      switch (dateFilterType) {
        case PowerDateFilterType.today:
          PowerDataHandler.date = DateRange(
              startDate: now.subtract(const Duration(days: 1)), endDate: now);
          break;
        case PowerDateFilterType.last7Days:
          PowerDataHandler.date = DateRange(
              startDate: now.subtract(const Duration(days: 6)), endDate: now);
          break;
        case PowerDateFilterType.last30Days:
          PowerDataHandler.date = DateRange(
              startDate: now.subtract(const Duration(days: 29)), endDate: now);
          break;
        case PowerDateFilterType.allTime:
          PowerDataHandler.date =
              DateRange(startDate: DateTime(1947, 1, 1), endDate: now);
          break;
        default:
      }
    }
    prettyLog(
        value:
            "${PowerDataHandler.date.startDate} : ${PowerDataHandler.date.endDate}");
    for (var fn in dateFilterChangeListeners) {
      fn();
    }
    dateStorage.put('range', PowerDataHandler.date.toMap());
    dateStorage.put(
        'type', convertDateFilterToText(PowerDataHandler.dateFilterType));
  }

  static Future<void> prepareImages() async {
    _images.clear();
    final entities = PowerDataStore.entities.where((e) =>
        e.type == ClipboardEntityType.image ||
        e.type == ClipboardEntityType.path);
    for (final entity in entities) {
      final file = File(entity.data);
      if (!file.existsSync()) {
        // possibly marked deleted
        continue;
      }

      final ext = file.path.contains('.')
          ? file.path.substring(file.path.lastIndexOf('.') + 1)
          : "none";
      if (!EntityUtils.imageExtensions.contains(ext)) {
        continue;
      }

      final bytes = file.readAsBytesSync();
      try {
        var decodedImage = await decodeImageFromList(bytes);
        final type = getClosestAspectRatio(
          decodedImage.width,
          decodedImage.height,
        );
        _images.add(
          ImageEntity(
            entity,
            bytes,
            convertImageFilterTo2D(
              type,
            ),
            Size(
              decodedImage.width.toDouble(),
              decodedImage.height.toDouble(),
            ),
            type,
          ),
        );
      } catch (e) {
        // ignore corrupt images
      }
    }
  }

  static void prepareColors() {
    _colors.clear();
    final entities = PowerDataStore.entities.where((e) =>
        e.type == ClipboardEntityType.text &&
        e.data.length >= 7 &&
        e.data.length <= 10);
    for (final entity in entities) {
      Color? color = identifyColor(entity.data);
      if (color != null) {
        _colors.add(ColorEntity(entity, color));
      }
    }
  }

  static void prepareTexts() {
    _texts.clear();
    final entities = PowerDataStore.entities
        .where((e) =>
            e.type == ClipboardEntityType.text &&
            !EntityUtils.isCommand(e) &&
            !isEmoji(e.data) &&
            (identifyColor(e.data) == null) &&
            e.data.trim().isNotEmpty)
        .map((e) => TextEntity(e, e.data));
    _texts.addAll(entities);
  }

  static void prepareEmojis() {
    _recentEmojis.clear();

    final parser = EmojiParser();
    final Map<String, Set<String>> parsedEmojisMap = {};

    List<RecentEmojiEntity> getEmojis() {
      List<RecentEmojiEntity> emojis = [];
      final texts = PowerDataStore.entities
          .where((e) => e.type == ClipboardEntityType.text);

      bool exists(String text) {
        return emojis.any((e) => e.emoji == text);
      }

      for (final entity in texts) {
        String contents = entity.data;
        if (parsedEmojisMap.containsKey(contents)) {
          final emojiSet = parsedEmojisMap[contents]!;
          for (final text in emojiSet) {
            if (!exists(text)) {
              emojis.add(RecentEmojiEntity(text, entity));
            }
          }
        } else {
          if (entity.data.length == 2 && isEmoji(entity.data)) {
            if (!exists(entity.data)) {
              emojis.add(RecentEmojiEntity(entity.data, entity));
            }
          } else {
            final emojiSet = parser.parseEmojis(contents);
            parsedEmojisMap[contents] = emojiSet.toSet();
            for (final text in emojiSet) {
              if (!exists(text)) {
                emojis.add(RecentEmojiEntity(text, entity));
              }
            }
          }
        }
      }
      return emojis;
    }

    _recentEmojis.addAll(getEmojis());
  }

  static void prepareCommands() {
    _commands.clear();
    final entities = PowerDataStore.entities;
    EntityUtils.filterOnlyCommands(entities);
    for (final entity in entities) {
      _commands.add(CommandEntity(entity, entity.data));
    }
  }

  static void prepareFiles({onComplete}) async {
    _files.clear();
    final entities = PowerDataStore.entities
        .where((e) => e.type == ClipboardEntityType.path);
    for (final entity in entities) {
      bool directory = true;
      String path = entity.data;
      if (await FileSystemEntity.isFile(path)) {
        directory = false;
      }
      String name =
          path.substring(path.lastIndexOf(Platform.pathSeparator) + 1);

      String parentPath = FileSystemEntity.parentOf(path);

      _files.add(FileEntity(directory, name, parentPath, path, entity));
    }
    onComplete();
  }
}
