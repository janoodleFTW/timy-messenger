// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_screen_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChannelScreenViewModel extends ChannelScreenViewModel {
  @override
  final bool isAuthor;
  @override
  final bool userIsMember;
  @override
  final String groupId;
  @override
  final Channel channel;
  @override
  final User user;
  @override
  final bool failedToJoin;
  @override
  final RSVP rsvpStatus;

  factory _$ChannelScreenViewModel(
          [void Function(ChannelScreenViewModelBuilder) updates]) =>
      (new ChannelScreenViewModelBuilder()..update(updates)).build();

  _$ChannelScreenViewModel._(
      {this.isAuthor,
      this.userIsMember,
      this.groupId,
      this.channel,
      this.user,
      this.failedToJoin,
      this.rsvpStatus})
      : super._() {
    if (isAuthor == null) {
      throw new BuiltValueNullFieldError('ChannelScreenViewModel', 'isAuthor');
    }
    if (userIsMember == null) {
      throw new BuiltValueNullFieldError(
          'ChannelScreenViewModel', 'userIsMember');
    }
    if (groupId == null) {
      throw new BuiltValueNullFieldError('ChannelScreenViewModel', 'groupId');
    }
    if (channel == null) {
      throw new BuiltValueNullFieldError('ChannelScreenViewModel', 'channel');
    }
    if (user == null) {
      throw new BuiltValueNullFieldError('ChannelScreenViewModel', 'user');
    }
    if (failedToJoin == null) {
      throw new BuiltValueNullFieldError(
          'ChannelScreenViewModel', 'failedToJoin');
    }
    if (rsvpStatus == null) {
      throw new BuiltValueNullFieldError(
          'ChannelScreenViewModel', 'rsvpStatus');
    }
  }

  @override
  ChannelScreenViewModel rebuild(
          void Function(ChannelScreenViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelScreenViewModelBuilder toBuilder() =>
      new ChannelScreenViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelScreenViewModel &&
        isAuthor == other.isAuthor &&
        userIsMember == other.userIsMember &&
        groupId == other.groupId &&
        channel == other.channel &&
        user == other.user &&
        failedToJoin == other.failedToJoin &&
        rsvpStatus == other.rsvpStatus;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, isAuthor.hashCode), userIsMember.hashCode),
                        groupId.hashCode),
                    channel.hashCode),
                user.hashCode),
            failedToJoin.hashCode),
        rsvpStatus.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChannelScreenViewModel')
          ..add('isAuthor', isAuthor)
          ..add('userIsMember', userIsMember)
          ..add('groupId', groupId)
          ..add('channel', channel)
          ..add('user', user)
          ..add('failedToJoin', failedToJoin)
          ..add('rsvpStatus', rsvpStatus))
        .toString();
  }
}

class ChannelScreenViewModelBuilder
    implements Builder<ChannelScreenViewModel, ChannelScreenViewModelBuilder> {
  _$ChannelScreenViewModel _$v;

  bool _isAuthor;
  bool get isAuthor => _$this._isAuthor;
  set isAuthor(bool isAuthor) => _$this._isAuthor = isAuthor;

  bool _userIsMember;
  bool get userIsMember => _$this._userIsMember;
  set userIsMember(bool userIsMember) => _$this._userIsMember = userIsMember;

  String _groupId;
  String get groupId => _$this._groupId;
  set groupId(String groupId) => _$this._groupId = groupId;

  ChannelBuilder _channel;
  ChannelBuilder get channel => _$this._channel ??= new ChannelBuilder();
  set channel(ChannelBuilder channel) => _$this._channel = channel;

  UserBuilder _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder user) => _$this._user = user;

  bool _failedToJoin;
  bool get failedToJoin => _$this._failedToJoin;
  set failedToJoin(bool failedToJoin) => _$this._failedToJoin = failedToJoin;

  RSVP _rsvpStatus;
  RSVP get rsvpStatus => _$this._rsvpStatus;
  set rsvpStatus(RSVP rsvpStatus) => _$this._rsvpStatus = rsvpStatus;

  ChannelScreenViewModelBuilder();

  ChannelScreenViewModelBuilder get _$this {
    if (_$v != null) {
      _isAuthor = _$v.isAuthor;
      _userIsMember = _$v.userIsMember;
      _groupId = _$v.groupId;
      _channel = _$v.channel?.toBuilder();
      _user = _$v.user?.toBuilder();
      _failedToJoin = _$v.failedToJoin;
      _rsvpStatus = _$v.rsvpStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelScreenViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChannelScreenViewModel;
  }

  @override
  void update(void Function(ChannelScreenViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChannelScreenViewModel build() {
    _$ChannelScreenViewModel _$result;
    try {
      _$result = _$v ??
          new _$ChannelScreenViewModel._(
              isAuthor: isAuthor,
              userIsMember: userIsMember,
              groupId: groupId,
              channel: channel.build(),
              user: user.build(),
              failedToJoin: failedToJoin,
              rsvpStatus: rsvpStatus);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channel';
        channel.build();
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ChannelScreenViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
