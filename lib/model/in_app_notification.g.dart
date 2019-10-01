// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_notification.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InAppNotification extends InAppNotification {
  @override
  final String groupId;
  @override
  final String groupName;
  @override
  final String userName;
  @override
  final String message;
  @override
  final Channel channel;

  factory _$InAppNotification(
          [void Function(InAppNotificationBuilder) updates]) =>
      (new InAppNotificationBuilder()..update(updates)).build();

  _$InAppNotification._(
      {this.groupId, this.groupName, this.userName, this.message, this.channel})
      : super._() {
    if (groupId == null) {
      throw new BuiltValueNullFieldError('InAppNotification', 'groupId');
    }
    if (groupName == null) {
      throw new BuiltValueNullFieldError('InAppNotification', 'groupName');
    }
    if (userName == null) {
      throw new BuiltValueNullFieldError('InAppNotification', 'userName');
    }
    if (message == null) {
      throw new BuiltValueNullFieldError('InAppNotification', 'message');
    }
    if (channel == null) {
      throw new BuiltValueNullFieldError('InAppNotification', 'channel');
    }
  }

  @override
  InAppNotification rebuild(void Function(InAppNotificationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InAppNotificationBuilder toBuilder() =>
      new InAppNotificationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InAppNotification &&
        groupId == other.groupId &&
        groupName == other.groupName &&
        userName == other.userName &&
        message == other.message &&
        channel == other.channel;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, groupId.hashCode), groupName.hashCode),
                userName.hashCode),
            message.hashCode),
        channel.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('InAppNotification')
          ..add('groupId', groupId)
          ..add('groupName', groupName)
          ..add('userName', userName)
          ..add('message', message)
          ..add('channel', channel))
        .toString();
  }
}

class InAppNotificationBuilder
    implements Builder<InAppNotification, InAppNotificationBuilder> {
  _$InAppNotification _$v;

  String _groupId;
  String get groupId => _$this._groupId;
  set groupId(String groupId) => _$this._groupId = groupId;

  String _groupName;
  String get groupName => _$this._groupName;
  set groupName(String groupName) => _$this._groupName = groupName;

  String _userName;
  String get userName => _$this._userName;
  set userName(String userName) => _$this._userName = userName;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  ChannelBuilder _channel;
  ChannelBuilder get channel => _$this._channel ??= new ChannelBuilder();
  set channel(ChannelBuilder channel) => _$this._channel = channel;

  InAppNotificationBuilder();

  InAppNotificationBuilder get _$this {
    if (_$v != null) {
      _groupId = _$v.groupId;
      _groupName = _$v.groupName;
      _userName = _$v.userName;
      _message = _$v.message;
      _channel = _$v.channel?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InAppNotification other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$InAppNotification;
  }

  @override
  void update(void Function(InAppNotificationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$InAppNotification build() {
    _$InAppNotification _$result;
    try {
      _$result = _$v ??
          new _$InAppNotification._(
              groupId: groupId,
              groupName: groupName,
              userName: userName,
              message: message,
              channel: channel.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channel';
        channel.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'InAppNotification', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
