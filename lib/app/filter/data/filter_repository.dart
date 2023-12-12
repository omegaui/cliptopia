import 'package:cliptopia/constants/typedefs.dart';
import 'package:cliptopia/core/storage/json_configurator.dart';

class FilterRepository {
  final _filterStorage = JsonConfigurator(configName: 'filter.json');
  final List<FilterWatcher> _watchers = [];
  late Filter activeFilter;

  FilterRepository() {
    final recentFilter = _filterStorage.get('filter');
    if (recentFilter != null) {
      activeFilter = Filter.fromMap(recentFilter);
    } else {
      activeFilter = Filter.defaultFilter;
    }
  }

  void setFilter(Filter filter) {
    activeFilter = filter;
    _filterStorage.put('filter', activeFilter.toMap());
    _signal();
  }

  void clearPattern() {
    activeFilter = Filter.clone(activeFilter,
        pattern: BuiltinFilterPattern.none, filterMode: FilterMode.builtin);
    _filterStorage.put('filter', activeFilter.toMap());
    _signal();
  }

  void _signal() {
    for (final watcher in _watchers) {
      if (!watcher.isDisposed()) {
        watcher.watch(activeFilter);
      }
    }
  }

  void addWatcher(FilterWatcher watcher) {
    _watchers.add(watcher);
    if (watcher.shouldForceCall()) {
      watcher.watch(activeFilter);
    }
  }

  void useImageFilter() {
    final filter = Filter.clone(activeFilter,
        pattern: BuiltinFilterPattern.image, filterMode: FilterMode.builtin);
    setFilter(filter);
  }

  void useVideoFilter() {
    final filter = Filter.clone(activeFilter,
        pattern: BuiltinFilterPattern.video, filterMode: FilterMode.builtin);
    setFilter(filter);
  }

  void useAudioFilter() {
    final filter = Filter.clone(activeFilter,
        pattern: BuiltinFilterPattern.audio, filterMode: FilterMode.builtin);
    setFilter(filter);
  }

  void useFilesFilter() {
    final filter = Filter.clone(activeFilter,
        pattern: BuiltinFilterPattern.files, filterMode: FilterMode.builtin);
    setFilter(filter);
  }

  void createFilterFromCustomPattern(String pattern) {
    if (pattern.trim().isEmpty) {
      setFilter(Filter.clone(
        activeFilter,
        pattern: BuiltinFilterPattern.none,
        filterMode: FilterMode.builtin,
      ));
    } else {
      setFilter(Filter.clone(
        activeFilter,
        pattern: pattern,
        filterMode: FilterMode.custom,
      ));
    }
  }

  void useTileMode() {
    setFilter(Filter.clone(
      activeFilter,
      viewMode: ViewMode.tiles,
    ));
  }

  void useListMode() {
    setFilter(Filter.clone(
      activeFilter,
      viewMode: ViewMode.list,
    ));
  }

  void useDateRange(DateRange dateRange) {
    setFilter(Filter.clone(
      activeFilter,
      dateRange: dateRange,
    ));
  }

  void clearDateRange() {
    setFilter(Filter.clone(
      activeFilter,
      dateRange: DateRange(),
    ));
  }
}
