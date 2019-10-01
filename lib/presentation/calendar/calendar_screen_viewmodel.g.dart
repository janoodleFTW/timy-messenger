// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_screen_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CalendarScreenViewModel extends CalendarScreenViewModel {
  @override
  final BuiltList<CalendarItem> calendar;
  @override
  final int selectedEventHeaderIndex;
  @override
  final int upcomingEventHeaderIndex;
  @override
  final BuiltMap<int, int> headerItemSizeMap;

  factory _$CalendarScreenViewModel(
          [void Function(CalendarScreenViewModelBuilder) updates]) =>
      (new CalendarScreenViewModelBuilder()..update(updates)).build();

  _$CalendarScreenViewModel._(
      {this.calendar,
      this.selectedEventHeaderIndex,
      this.upcomingEventHeaderIndex,
      this.headerItemSizeMap})
      : super._() {
    if (calendar == null) {
      throw new BuiltValueNullFieldError('CalendarScreenViewModel', 'calendar');
    }
    if (selectedEventHeaderIndex == null) {
      throw new BuiltValueNullFieldError(
          'CalendarScreenViewModel', 'selectedEventHeaderIndex');
    }
    if (upcomingEventHeaderIndex == null) {
      throw new BuiltValueNullFieldError(
          'CalendarScreenViewModel', 'upcomingEventHeaderIndex');
    }
    if (headerItemSizeMap == null) {
      throw new BuiltValueNullFieldError(
          'CalendarScreenViewModel', 'headerItemSizeMap');
    }
  }

  @override
  CalendarScreenViewModel rebuild(
          void Function(CalendarScreenViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalendarScreenViewModelBuilder toBuilder() =>
      new CalendarScreenViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalendarScreenViewModel &&
        calendar == other.calendar &&
        selectedEventHeaderIndex == other.selectedEventHeaderIndex &&
        upcomingEventHeaderIndex == other.upcomingEventHeaderIndex &&
        headerItemSizeMap == other.headerItemSizeMap;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, calendar.hashCode), selectedEventHeaderIndex.hashCode),
            upcomingEventHeaderIndex.hashCode),
        headerItemSizeMap.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CalendarScreenViewModel')
          ..add('calendar', calendar)
          ..add('selectedEventHeaderIndex', selectedEventHeaderIndex)
          ..add('upcomingEventHeaderIndex', upcomingEventHeaderIndex)
          ..add('headerItemSizeMap', headerItemSizeMap))
        .toString();
  }
}

class CalendarScreenViewModelBuilder
    implements
        Builder<CalendarScreenViewModel, CalendarScreenViewModelBuilder> {
  _$CalendarScreenViewModel _$v;

  ListBuilder<CalendarItem> _calendar;
  ListBuilder<CalendarItem> get calendar =>
      _$this._calendar ??= new ListBuilder<CalendarItem>();
  set calendar(ListBuilder<CalendarItem> calendar) =>
      _$this._calendar = calendar;

  int _selectedEventHeaderIndex;
  int get selectedEventHeaderIndex => _$this._selectedEventHeaderIndex;
  set selectedEventHeaderIndex(int selectedEventHeaderIndex) =>
      _$this._selectedEventHeaderIndex = selectedEventHeaderIndex;

  int _upcomingEventHeaderIndex;
  int get upcomingEventHeaderIndex => _$this._upcomingEventHeaderIndex;
  set upcomingEventHeaderIndex(int upcomingEventHeaderIndex) =>
      _$this._upcomingEventHeaderIndex = upcomingEventHeaderIndex;

  MapBuilder<int, int> _headerItemSizeMap;
  MapBuilder<int, int> get headerItemSizeMap =>
      _$this._headerItemSizeMap ??= new MapBuilder<int, int>();
  set headerItemSizeMap(MapBuilder<int, int> headerItemSizeMap) =>
      _$this._headerItemSizeMap = headerItemSizeMap;

  CalendarScreenViewModelBuilder();

  CalendarScreenViewModelBuilder get _$this {
    if (_$v != null) {
      _calendar = _$v.calendar?.toBuilder();
      _selectedEventHeaderIndex = _$v.selectedEventHeaderIndex;
      _upcomingEventHeaderIndex = _$v.upcomingEventHeaderIndex;
      _headerItemSizeMap = _$v.headerItemSizeMap?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalendarScreenViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CalendarScreenViewModel;
  }

  @override
  void update(void Function(CalendarScreenViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CalendarScreenViewModel build() {
    _$CalendarScreenViewModel _$result;
    try {
      _$result = _$v ??
          new _$CalendarScreenViewModel._(
              calendar: calendar.build(),
              selectedEventHeaderIndex: selectedEventHeaderIndex,
              upcomingEventHeaderIndex: upcomingEventHeaderIndex,
              headerItemSizeMap: headerItemSizeMap.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'calendar';
        calendar.build();

        _$failedField = 'headerItemSizeMap';
        headerItemSizeMap.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CalendarScreenViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
