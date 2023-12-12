import 'package:cliptopia/app/clipboard/domain/entity/clipboard_entity.dart';
import 'package:cliptopia/core/parser.dart';

typedef RebuildCallback = void Function();

typedef OptionChangedCallback = void Function(bool enabled);

typedef OptionValueChangedCallback = void Function(String value);

typedef AppSessionCallback = void Function();

class DatabaseWatcher {
  String _status = 'alive';
  final List<ClipboardEntityType> filters;
  final void Function(List<ClipboardEntity> entities) onEvent;
  final bool watchOnce;
  final bool forceCall;

  DatabaseWatcher(
      {required this.onEvent, required this.filters, this.forceCall = true})
      : watchOnce = false;

  DatabaseWatcher.temp(
      {required this.onEvent,
      List<ClipboardEntityType>? filters,
      this.forceCall = true})
      : watchOnce = true,
        filters = filters ??
            [
              ClipboardEntityType.text,
              ClipboardEntityType.image,
              ClipboardEntityType.path,
            ];

  DatabaseWatcher.permanent(
      {required this.onEvent,
      List<ClipboardEntityType>? filters,
      this.forceCall = true})
      : watchOnce = false,
        filters = filters ??
            [
              ClipboardEntityType.text,
              ClipboardEntityType.image,
              ClipboardEntityType.path,
            ];

  void watch(List<ClipboardEntity> entities) {
    if (entities.isEmpty) {
      return;
    }
    onEvent(entities);
    if (watchOnce) {
      dispose();
    }
  }

  void dispose() {
    _status = 'disposed';
  }

  bool isDisposed() {
    return _status == 'disposed';
  }

  bool listensTo(type) {
    return filters.contains(type);
  }
}

class FilterWatcher {
  String _status = 'alive';
  bool _forceCall = false;
  final void Function(Filter filter) onEvent;

  FilterWatcher({required this.onEvent});

  FilterWatcher.forceCall({required this.onEvent}) : _forceCall = true;

  bool shouldForceCall() {
    return _forceCall;
  }

  void watch(Filter filter) {
    onEvent(filter);
  }

  void dispose() {
    _status = 'disposed';
  }

  bool isDisposed() {
    return _status == 'disposed';
  }
}

class Filter {
  static final defaultFilter = Filter(
    filterMode: FilterMode.builtin,
    viewMode: ViewMode.tiles,
    dateRange: DateRange(),
    pattern: BuiltinFilterPattern.none,
  );

  static final imageFilter = Filter(
    filterMode: FilterMode.builtin,
    viewMode: ViewMode.tiles,
    dateRange: DateRange(),
    pattern: BuiltinFilterPattern.image,
  );

  static final videoFilter = Filter(
    filterMode: FilterMode.builtin,
    viewMode: ViewMode.tiles,
    dateRange: DateRange(),
    pattern: BuiltinFilterPattern.video,
  );

  static final audioFilter = Filter(
    filterMode: FilterMode.builtin,
    viewMode: ViewMode.tiles,
    dateRange: DateRange(),
    pattern: BuiltinFilterPattern.audio,
  );

  static final filesFilter = Filter(
    filterMode: FilterMode.builtin,
    viewMode: ViewMode.tiles,
    dateRange: DateRange(),
    pattern: BuiltinFilterPattern.files,
  );

  final FilterMode filterMode;
  final ViewMode viewMode;
  final DateRange dateRange;
  dynamic pattern;

  Filter({
    required this.filterMode,
    required this.viewMode,
    required this.dateRange,
    this.pattern = "",
  });

  Filter.clone(Filter filter,
      {FilterMode? filterMode,
      ViewMode? viewMode,
      DateRange? dateRange,
      dynamic pattern})
      : filterMode = filterMode ?? filter.filterMode,
        dateRange = dateRange ?? filter.dateRange,
        pattern = pattern ?? filter.pattern,
        viewMode = viewMode ?? filter.viewMode;

  bool isCustomFilter() {
    return filterMode == FilterMode.custom;
  }

  Map<String, dynamic> toMap() {
    return {
      'pattern': pattern.toString(),
      'filterMode': filterMode.toString(),
      'viewMode': viewMode.toString(),
    };
  }

  static Filter fromMap(Map<String, dynamic> data) {
    return Filter(
      pattern: Parser.parseBuiltinFilterPattern(data['pattern']),
      filterMode: Parser.parseFilterMode(data['filterMode']),
      viewMode: Parser.parseViewMode(data['viewMode']),
      dateRange: DateRange(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is Filter) {
      return other.filterMode == filterMode &&
          other.viewMode == viewMode &&
          other.pattern == pattern &&
          other.dateRange == dateRange;
    }
    return super == other;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      filterMode.hashCode ^
      viewMode.hashCode ^
      dateRange.hashCode ^
      pattern.hashCode;
}

enum FilterMode { builtin, custom }

enum BuiltinFilterPattern { image, video, audio, files, none }

enum ViewMode { tiles, list }

class DateRange {
  final DateTime? _startDate;
  final DateTime? _endDate;

  DateRange({DateTime? startDate, DateTime? endDate})
      : _startDate = startDate,
        _endDate = endDate;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate ?? _startDate;

  bool isCustom() {
    return startDate != null;
  }

  DateRange? getIfCustom() {
    if (isCustom()) {
      this;
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (other is DateRange) {
      return other.startDate == startDate && other.endDate == endDate;
    }
    return super == other;
  }

  @override
  int get hashCode => super.hashCode ^ startDate.hashCode ^ endDate.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
    };
  }

  static DateRange fromMap(data) {
    return DateRange(
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
    );
  }
}

extension DateRangeExtension on DateTime {
  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isBefore(dateTime);
  }

  bool isBetween(DateRange range) {
    final date = DateTime(year, month, day, 0, 0);
    final isAfter = date.isAfterOrEqualTo(range.startDate ?? DateTime.now());
    final isBefore = date.isBeforeOrEqualTo(range.endDate ?? DateTime.now());
    return isAfter && isBefore;
  }
}

enum EmptyCause {
  noInitialElements,
  noElementsOnDate,
  noElementsOnFilter,
  noElementsOnSearch,
  noImageElements,
  noAudioElements,
  noVideoElements,
  noNoteElements,
  noFileElements,
  noCommandsElements,
  none,
}

class SearchWatcher {
  String _status = 'alive';
  void Function(String text) onEvent;
  final bool watchOnce;
  final bool forceCall;

  SearchWatcher({required this.onEvent, this.forceCall = true})
      : watchOnce = false;

  SearchWatcher.temp({required this.onEvent, this.forceCall = true})
      : watchOnce = true;

  void watch(String text) {
    onEvent(text);
    if (watchOnce) {
      dispose();
    }
  }

  void dispose() {
    _status = 'disposed';
  }

  bool isDisposed() {
    return _status == 'disposed';
  }
}
