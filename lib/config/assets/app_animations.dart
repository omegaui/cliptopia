import 'package:cliptopia/constants/typedefs.dart';

class AppAnimations {
  AppAnimations._();

  static const loading = 'assets/animations/loading.json';
  static const downloading = 'assets/animations/downloading.json';
  static const empty = 'assets/animations/empty.json';
  static const filesEmpty = 'assets/animations/files-empty.json';
  static const filterEmpty = 'assets/animations/filter-empty.json';
  static const imagesEmpty = 'assets/animations/images-empty.json';
  static const notesEmpty = 'assets/animations/notes-empty.json';
  static const searchEmpty = 'assets/animations/search-empty.json';
  static const dateEmpty = 'assets/animations/date-empty.json';
  static const commandsEmpty = 'assets/animations/commands-empty.json';
  static const emojis = 'assets/animations/emojis.json';
  static const audiosEmpty = 'assets/animations/audios-empty.json';
  static const videosEmpty = 'assets/animations/videos-empty.json';
  static const space = 'assets/animations/space.json';
  static const shield = 'assets/animations/shield.json';
  static const connection = 'assets/animations/connection.json';
  static const sleeping = 'assets/animations/sleeping.json';

  static String getEmptyAnimationOnCause(EmptyCause cause) {
    switch (cause) {
      case EmptyCause.noInitialElements:
        return empty;
      case EmptyCause.noElementsOnDate:
        return dateEmpty;
      case EmptyCause.noElementsOnFilter:
        return filterEmpty;
      case EmptyCause.noElementsOnSearch:
        return searchEmpty;
      case EmptyCause.noImageElements:
        return imagesEmpty;
      case EmptyCause.noAudioElements:
        return audiosEmpty;
      case EmptyCause.noVideoElements:
        return videosEmpty;
      case EmptyCause.noNoteElements:
        return notesEmpty;
      case EmptyCause.noFileElements:
        return filesEmpty;
      case EmptyCause.noCommandsElements:
        return commandsEmpty;
      case EmptyCause.none:
        return loading;
    }
  }
}
