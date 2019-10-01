// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_app_bar_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HomeAppBarViewModel extends HomeAppBarViewModel {
  @override
  final bool hasUpdatedChannelsInGroup;
  @override
  final String title;
  @override
  final bool memberOfChannel;
  @override
  final bool isEvent;
  @override
  final String eventDate;

  factory _$HomeAppBarViewModel(
          [void Function(HomeAppBarViewModelBuilder) updates]) =>
      (new HomeAppBarViewModelBuilder()..update(updates)).build();

  _$HomeAppBarViewModel._(
      {this.hasUpdatedChannelsInGroup,
      this.title,
      this.memberOfChannel,
      this.isEvent,
      this.eventDate})
      : super._() {
    if (hasUpdatedChannelsInGroup == null) {
      throw new BuiltValueNullFieldError(
          'HomeAppBarViewModel', 'hasUpdatedChannelsInGroup');
    }
    if (title == null) {
      throw new BuiltValueNullFieldError('HomeAppBarViewModel', 'title');
    }
    if (memberOfChannel == null) {
      throw new BuiltValueNullFieldError(
          'HomeAppBarViewModel', 'memberOfChannel');
    }
    if (isEvent == null) {
      throw new BuiltValueNullFieldError('HomeAppBarViewModel', 'isEvent');
    }
    if (eventDate == null) {
      throw new BuiltValueNullFieldError('HomeAppBarViewModel', 'eventDate');
    }
  }

  @override
  HomeAppBarViewModel rebuild(
          void Function(HomeAppBarViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HomeAppBarViewModelBuilder toBuilder() =>
      new HomeAppBarViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeAppBarViewModel &&
        hasUpdatedChannelsInGroup == other.hasUpdatedChannelsInGroup &&
        title == other.title &&
        memberOfChannel == other.memberOfChannel &&
        isEvent == other.isEvent &&
        eventDate == other.eventDate;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, hasUpdatedChannelsInGroup.hashCode), title.hashCode),
                memberOfChannel.hashCode),
            isEvent.hashCode),
        eventDate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('HomeAppBarViewModel')
          ..add('hasUpdatedChannelsInGroup', hasUpdatedChannelsInGroup)
          ..add('title', title)
          ..add('memberOfChannel', memberOfChannel)
          ..add('isEvent', isEvent)
          ..add('eventDate', eventDate))
        .toString();
  }
}

class HomeAppBarViewModelBuilder
    implements Builder<HomeAppBarViewModel, HomeAppBarViewModelBuilder> {
  _$HomeAppBarViewModel _$v;

  bool _hasUpdatedChannelsInGroup;
  bool get hasUpdatedChannelsInGroup => _$this._hasUpdatedChannelsInGroup;
  set hasUpdatedChannelsInGroup(bool hasUpdatedChannelsInGroup) =>
      _$this._hasUpdatedChannelsInGroup = hasUpdatedChannelsInGroup;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  bool _memberOfChannel;
  bool get memberOfChannel => _$this._memberOfChannel;
  set memberOfChannel(bool memberOfChannel) =>
      _$this._memberOfChannel = memberOfChannel;

  bool _isEvent;
  bool get isEvent => _$this._isEvent;
  set isEvent(bool isEvent) => _$this._isEvent = isEvent;

  String _eventDate;
  String get eventDate => _$this._eventDate;
  set eventDate(String eventDate) => _$this._eventDate = eventDate;

  HomeAppBarViewModelBuilder();

  HomeAppBarViewModelBuilder get _$this {
    if (_$v != null) {
      _hasUpdatedChannelsInGroup = _$v.hasUpdatedChannelsInGroup;
      _title = _$v.title;
      _memberOfChannel = _$v.memberOfChannel;
      _isEvent = _$v.isEvent;
      _eventDate = _$v.eventDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeAppBarViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$HomeAppBarViewModel;
  }

  @override
  void update(void Function(HomeAppBarViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$HomeAppBarViewModel build() {
    final _$result = _$v ??
        new _$HomeAppBarViewModel._(
            hasUpdatedChannelsInGroup: hasUpdatedChannelsInGroup,
            title: title,
            memberOfChannel: memberOfChannel,
            isEvent: isEvent,
            eventDate: eventDate);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
