// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic_details_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TopicDetailsViewModel extends TopicDetailsViewModel {
  @override
  final String name;
  @override
  final String description;
  @override
  final ChannelVisibility visibility;
  @override
  final BuiltList<User> members;
  @override
  final String groupId;
  @override
  final Channel channel;
  @override
  final String userId;

  factory _$TopicDetailsViewModel(
          [void Function(TopicDetailsViewModelBuilder) updates]) =>
      (new TopicDetailsViewModelBuilder()..update(updates)).build();

  _$TopicDetailsViewModel._(
      {this.name,
      this.description,
      this.visibility,
      this.members,
      this.groupId,
      this.channel,
      this.userId})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('TopicDetailsViewModel', 'name');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError(
          'TopicDetailsViewModel', 'description');
    }
    if (visibility == null) {
      throw new BuiltValueNullFieldError('TopicDetailsViewModel', 'visibility');
    }
    if (members == null) {
      throw new BuiltValueNullFieldError('TopicDetailsViewModel', 'members');
    }
    if (groupId == null) {
      throw new BuiltValueNullFieldError('TopicDetailsViewModel', 'groupId');
    }
    if (channel == null) {
      throw new BuiltValueNullFieldError('TopicDetailsViewModel', 'channel');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('TopicDetailsViewModel', 'userId');
    }
  }

  @override
  TopicDetailsViewModel rebuild(
          void Function(TopicDetailsViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TopicDetailsViewModelBuilder toBuilder() =>
      new TopicDetailsViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TopicDetailsViewModel &&
        name == other.name &&
        description == other.description &&
        visibility == other.visibility &&
        members == other.members &&
        groupId == other.groupId &&
        channel == other.channel &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, name.hashCode), description.hashCode),
                        visibility.hashCode),
                    members.hashCode),
                groupId.hashCode),
            channel.hashCode),
        userId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TopicDetailsViewModel')
          ..add('name', name)
          ..add('description', description)
          ..add('visibility', visibility)
          ..add('members', members)
          ..add('groupId', groupId)
          ..add('channel', channel)
          ..add('userId', userId))
        .toString();
  }
}

class TopicDetailsViewModelBuilder
    implements Builder<TopicDetailsViewModel, TopicDetailsViewModelBuilder> {
  _$TopicDetailsViewModel _$v;

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

  String _groupId;
  String get groupId => _$this._groupId;
  set groupId(String groupId) => _$this._groupId = groupId;

  ChannelBuilder _channel;
  ChannelBuilder get channel => _$this._channel ??= new ChannelBuilder();
  set channel(ChannelBuilder channel) => _$this._channel = channel;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  TopicDetailsViewModelBuilder();

  TopicDetailsViewModelBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _description = _$v.description;
      _visibility = _$v.visibility;
      _members = _$v.members?.toBuilder();
      _groupId = _$v.groupId;
      _channel = _$v.channel?.toBuilder();
      _userId = _$v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TopicDetailsViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TopicDetailsViewModel;
  }

  @override
  void update(void Function(TopicDetailsViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TopicDetailsViewModel build() {
    _$TopicDetailsViewModel _$result;
    try {
      _$result = _$v ??
          new _$TopicDetailsViewModel._(
              name: name,
              description: description,
              visibility: visibility,
              members: members.build(),
              groupId: groupId,
              channel: channel.build(),
              userId: userId);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'members';
        members.build();

        _$failedField = 'channel';
        channel.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TopicDetailsViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
