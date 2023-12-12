import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/core/database/database.dart';
import 'package:cliptopia/core/services/injector.dart';
import 'package:cliptopia/core/utils.dart';

class NotesRepository {
  final _database = Injector.find<Database>();

  bool hasObjects() {
    if (!_database.hasEntities(ClipboardEntityType.text)) {
      return false;
    }
    final notes = _database.entities;
    EntityUtils.filterOnlyNotes(notes);
    return notes.isNotEmpty;
  }
}
