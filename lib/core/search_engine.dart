import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/logger.dart';

class SearchEngine {
  String _searchText = "";
  final List<SearchWatcher> _watchers = [];

  static final SearchWatcher primary = SearchWatcher(onEvent: (text) {
    // this part will be reimplemented in search supported states
    prettyLog(
      value: "Search Engine switched to default",
      type: DebugType.response,
    );
  });

  SearchEngine() {
    addWatcher(primary);
  }

  void search(String text) {
    if (_searchText == text) {
      return;
    }
    _searchText = text;
    _signal();
  }

  void addWatcher(SearchWatcher watcher) {
    _watchers.add(watcher);
    if (watcher.forceCall) {
      _signal();
    }
  }

  void signal() {
    // this explicit call should be omitted when possible
    _signal();
  }

  void _signal() {
    for (final watcher in _watchers) {
      if (!watcher.isDisposed()) {
        watcher.watch(_searchText);
      }
    }
  }
}
