import 'dart:ui';

import 'package:cliptopia/app/clipboard/data/clipboard_repository.dart';
import 'package:cliptopia/app/commands/data/commands_repository.dart';
import 'package:cliptopia/app/emojis/data/emojis_repository.dart';
import 'package:cliptopia/app/filter/data/filter_repository.dart';
import 'package:cliptopia/app/notes/data/notes_repository.dart';
import 'package:cliptopia/app/settings/data/settings_repository.dart';
import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/app_session.dart';
import 'package:cliptopia/core/clipboard_engine.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/database/exclusion_database.dart';
import 'package:cliptopia/core/search_engine.dart';
import 'package:cliptopia/core/services/route_service.dart';

class _InjectionContainer {
  Set<dynamic> dependencies = {};

  void put<T>(T t) {
    dependencies.add(t);
  }

  T find<T>() {
    return dependencies.firstWhere((element) => element.runtimeType == T);
  }
}

class Injector {
  Injector._();

  static final _container = _InjectionContainer();

  static void init({
    required RebuildCallback onRebuild,
    required VoidCallback onFinished,
  }) {
    _container.put<AppSession>(AppSession(onRebuild: onRebuild));
    _container.put<RouteService>(RouteService.withState(onRebuild: onRebuild));
    _container.put<Database>(Database());
    _container.put<ExclusionDatabase>(ExclusionDatabase());
    _container.put<ClipboardEngine>(ClipboardEngine());
    _container.put<SearchEngine>(SearchEngine());

    // Repositories
    _container.put<FilterRepository>(FilterRepository());
    _container.put<ClipboardRepository>(ClipboardRepository());
    _container.put<NotesRepository>(NotesRepository());
    _container.put<CommandsRepository>(CommandsRepository());
    _container.put<EmojisRepository>(EmojisRepository());
    _container.put<SettingsRepository>(SettingsRepository());
    onFinished();
  }

  static T find<T>() {
    return _container.find<T>();
  }
}
