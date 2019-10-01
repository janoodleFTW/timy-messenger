// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CalendarEntry extends CalendarEntry {
  @override
  final String channelId;
  @override
  final String channelName;
  @override
  final String groupId;
  @override
  final String groupName;
  @override
  final DateTime eventDate;
  @override
  final bool hasStartTime;

  factory _$CalendarEntry([void Function(CalendarEntryBuilder) updates]) =>
      (new CalendarEntryBuilder()..update(updates)).build();

  _$CalendarEntry._(
      {this.channelId,
      this.channelName,
      this.groupId,
      this.groupName,
      this.eventDate,
      this.hasStartTime})
      : super._() {
    if (channelId == null) {
      throw new BuiltValueNullFieldError('CalendarEntry', 'channelId');
    }
    if (channelName == null) {
      throw new BuiltValueNullFieldError('CalendarEntry', 'channelName');
    }
    if (groupId == null) {
      throw new BuiltValueNullFieldError('CalendarEntry', 'groupId');
    }
    if (groupName == null) {
      throw new BuiltValueNullFieldError('CalendarEntry', 'groupName');
    }
    if (eventDate == null) {
      throw new BuiltValueNullFieldError('CalendarEntry', 'eventDate');
    }
    if (hasStartTime == null) {
      throw new BuiltValueNullFieldError('CalendarEntry', 'hasStartTime');
    }
  }

  @override
  CalendarEntry rebuild(void Function(CalendarEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CalendarEntryBuilder toBuilder() => new CalendarEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalendarEntry &&
        channelId == other.channelId &&
        channelName == other.channelName &&
        groupId == other.groupId &&
        groupName == other.groupName &&
        eventDate == other.eventDate &&
        hasStartTime == other.hasStartTime;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, channelId.hashCode), channelName.hashCode),
                    groupId.hashCode),
                groupName.hashCode),
            eventDate.hashCode),
        hasStartTime.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CalendarEntry')
          ..add('channelId', channelId)
          ..add('channelName', channelName)
          ..add('groupId', groupId)
          ..add('groupName', groupName)
          ..add('eventDate', eventDate)
          ..add('hasStartTime', hasStartTime))
        .toString();
  }
}

class CalendarEntryBuilder
    implements Builder<CalendarEntry, CalendarEntryBuilder> {
  _$CalendarEntry _$v;

  String _channelId;
  String get channelId => _$this._channelId;
  set channelId(String channelId) => _$this._channelId = channelId;

  String _channelName;
  String get channelName => _$this._channelName;
  set channelName(String channelName) => _$this._channelName = channelName;

  String _groupId;
  String get groupId => _$this._groupId;
  set groupId(String groupId) => _$this._groupId = groupId;

  String _groupName;
  String get groupName => _$this._groupName;
  set groupName(String groupName) => _$this._groupName = groupName;

  DateTime _eventDate;
  DateTime get eventDate => _$this._eventDate;
  set eventDate(DateTime eventDate) => _$this._eventDate = eventDate;

  bool _hasStartTime;
  bool get hasStartTime => _$this._hasStartTime;
  set hasStartTime(bool hasStartTime) => _$this._hasStartTime = hasStartTime;

  CalendarEntryBuilder();

  CalendarEntryBuilder get _$this {
    if (_$v != null) {
      _channelId = _$v.channelId;
      _channelName = _$v.channelName;
      _groupId = _$v.groupId;
      _groupName = _$v.groupName;
      _eventDate = _$v.eventDate;
      _hasStartTime = _$v.hasStartTime;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalendarEntry other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CalendarEntry;
  }

  @override
  void update(void Function(CalendarEntryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CalendarEntry build() {
    final _$result = _$v ??
        new _$CalendarEntry._(
            channelId: channelId,
            channelName: channelName,
            groupId: groupId,
            groupName: groupName,
            eventDate: eventDate,
            hasStartTime: hasStartTime);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
