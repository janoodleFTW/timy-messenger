// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_details_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EventDetailsViewModel extends EventDetailsViewModel {
  @override
  final String name;
  @override
  final String description;
  @override
  final ChannelVisibility visibility;
  @override
  final BuiltList<User> members;
  @override
  final BuiltMap<String, RSVP> rsvpStatus;
  @override
  final int guestCount;
  @override
  final String groupId;
  @override
  final Channel channel;
  @override
  final String eventDate;
  @override
  final String eventTime;
  @override
  final String venue;
  @override
  final User user;
  @override
  final RSVP userRsvp;
  @override
  final bool editable;
  @override
  final bool canChangeRsvp;

  factory _$EventDetailsViewModel(
          [void Function(EventDetailsViewModelBuilder) updates]) =>
      (new EventDetailsViewModelBuilder()..update(updates)).build();

  _$EventDetailsViewModel._(
      {this.name,
      this.description,
      this.visibility,
      this.members,
      this.rsvpStatus,
      this.guestCount,
      this.groupId,
      this.channel,
      this.eventDate,
      this.eventTime,
      this.venue,
      this.user,
      this.userRsvp,
      this.editable,
      this.canChangeRsvp})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'name');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError(
          'EventDetailsViewModel', 'description');
    }
    if (visibility == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'visibility');
    }
    if (members == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'members');
    }
    if (rsvpStatus == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'rsvpStatus');
    }
    if (guestCount == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'guestCount');
    }
    if (groupId == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'groupId');
    }
    if (channel == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'channel');
    }
    if (eventDate == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'eventDate');
    }
    if (eventTime == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'eventTime');
    }
    if (venue == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'venue');
    }
    if (user == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'user');
    }
    if (userRsvp == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'userRsvp');
    }
    if (editable == null) {
      throw new BuiltValueNullFieldError('EventDetailsViewModel', 'editable');
    }
    if (canChangeRsvp == null) {
      throw new BuiltValueNullFieldError(
          'EventDetailsViewModel', 'canChangeRsvp');
    }
  }

  @override
  EventDetailsViewModel rebuild(
          void Function(EventDetailsViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventDetailsViewModelBuilder toBuilder() =>
      new EventDetailsViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventDetailsViewModel &&
        name == other.name &&
        description == other.description &&
        visibility == other.visibility &&
        members == other.members &&
        rsvpStatus == other.rsvpStatus &&
        guestCount == other.guestCount &&
        groupId == other.groupId &&
        channel == other.channel &&
        eventDate == other.eventDate &&
        eventTime == other.eventTime &&
        venue == other.venue &&
        user == other.user &&
        userRsvp == other.userRsvp &&
        editable == other.editable &&
        canChangeRsvp == other.canChangeRsvp;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(0,
                                                                name.hashCode),
                                                            description
                                                                .hashCode),
                                                        visibility.hashCode),
                                                    members.hashCode),
                                                rsvpStatus.hashCode),
                                            guestCount.hashCode),
                                        groupId.hashCode),
                                    channel.hashCode),
                                eventDate.hashCode),
                            eventTime.hashCode),
                        venue.hashCode),
                    user.hashCode),
                userRsvp.hashCode),
            editable.hashCode),
        canChangeRsvp.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('EventDetailsViewModel')
          ..add('name', name)
          ..add('description', description)
          ..add('visibility', visibility)
          ..add('members', members)
          ..add('rsvpStatus', rsvpStatus)
          ..add('guestCount', guestCount)
          ..add('groupId', groupId)
          ..add('channel', channel)
          ..add('eventDate', eventDate)
          ..add('eventTime', eventTime)
          ..add('venue', venue)
          ..add('user', user)
          ..add('userRsvp', userRsvp)
          ..add('editable', editable)
          ..add('canChangeRsvp', canChangeRsvp))
        .toString();
  }
}

class EventDetailsViewModelBuilder
    implements Builder<EventDetailsViewModel, EventDetailsViewModelBuilder> {
  _$EventDetailsViewModel _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  ChannelVisibility _visibility;
  ChannelVisibility get visibility => _$this._visibility;
  set visibility(ChannelVisibility visibility) =>
      _$this._visibility = visibility;

  ListBuilder<User> _members;
  ListBuilder<User> get members => _$this._members ??= new ListBuilder<User>();
  set members(ListBuilder<User> members) => _$this._members = members;

  MapBuilder<String, RSVP> _rsvpStatus;
  MapBuilder<String, RSVP> get rsvpStatus =>
      _$this._rsvpStatus ??= new MapBuilder<String, RSVP>();
  set rsvpStatus(MapBuilder<String, RSVP> rsvpStatus) =>
      _$this._rsvpStatus = rsvpStatus;

  int _guestCount;
  int get guestCount => _$this._guestCount;
  set guestCount(int guestCount) => _$this._guestCount = guestCount;

  String _groupId;
  String get groupId => _$this._groupId;
  set groupId(String groupId) => _$this._groupId = groupId;

  ChannelBuilder _channel;
  ChannelBuilder get channel => _$this._channel ??= new ChannelBuilder();
  set channel(ChannelBuilder channel) => _$this._channel = channel;

  String _eventDate;
  String get eventDate => _$this._eventDate;
  set eventDate(String eventDate) => _$this._eventDate = eventDate;

  String _eventTime;
  String get eventTime => _$this._eventTime;
  set eventTime(String eventTime) => _$this._eventTime = eventTime;

  String _venue;
  String get venue => _$this._venue;
  set venue(String venue) => _$this._venue = venue;

  UserBuilder _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder user) => _$this._user = user;

  RSVP _userRsvp;
  RSVP get userRsvp => _$this._userRsvp;
  set userRsvp(RSVP userRsvp) => _$this._userRsvp = userRsvp;

  bool _editable;
  bool get editable => _$this._editable;
  set editable(bool editable) => _$this._editable = editable;

  bool _canChangeRsvp;
  bool get canChangeRsvp => _$this._canChangeRsvp;
  set canChangeRsvp(bool canChangeRsvp) =>
      _$this._canChangeRsvp = canChangeRsvp;

  EventDetailsViewModelBuilder();

  EventDetailsViewModelBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _description = _$v.description;
      _visibility = _$v.visibility;
      _members = _$v.members?.toBuilder();
      _rsvpStatus = _$v.rsvpStatus?.toBuilder();
      _guestCount = _$v.guestCount;
      _groupId = _$v.groupId;
      _channel = _$v.channel?.toBuilder();
      _eventDate = _$v.eventDate;
      _eventTime = _$v.eventTime;
      _venue = _$v.venue;
      _user = _$v.user?.toBuilder();
      _userRsvp = _$v.userRsvp;
      _editable = _$v.editable;
      _canChangeRsvp = _$v.canChangeRsvp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventDetailsViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$EventDetailsViewModel;
  }

  @override
  void update(void Function(EventDetailsViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$EventDetailsViewModel build() {
    _$EventDetailsViewModel _$result;
    try {
      _$result = _$v ??
          new _$EventDetailsViewModel._(
              name: name,
              description: description,
              visibility: visibility,
              members: members.build(),
              rsvpStatus: rsvpStatus.build(),
              guestCount: guestCount,
              groupId: groupId,
              channel: channel.build(),
              eventDate: eventDate,
              eventTime: eventTime,
              venue: venue,
              user: user.build(),
              userRsvp: userRsvp,
              editable: editable,
              canChangeRsvp: canChangeRsvp);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'members';
        members.build();
        _$failedField = 'rsvpStatus';
        rsvpStatus.build();

        _$failedField = 'channel';
        channel.build();

        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'EventDetailsViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
