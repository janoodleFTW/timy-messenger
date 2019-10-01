// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UiState extends UiState {
  @override
  final BuiltMap<String, GroupUiState> groupUiState;

  factory _$UiState([void Function(UiStateBuilder) updates]) =>
      (new UiStateBuilder()..update(updates)).build();

  _$UiState._({this.groupUiState}) : super._() {
    if (groupUiState == null) {
      throw new BuiltValueNullFieldError('UiState', 'groupUiState');
    }
  }

  @override
  UiState rebuild(void Function(UiStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UiStateBuilder toBuilder() => new UiStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UiState && groupUiState == other.groupUiState;
  }

  @override
  int get hashCode {
    return $jf($jc(0, groupUiState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UiState')
          ..add('groupUiState', groupUiState))
        .toString();
  }
}

class UiStateBuilder implements Builder<UiState, UiStateBuilder> {
  _$UiState _$v;

  MapBuilder<String, GroupUiState> _groupUiState;
  MapBuilder<String, GroupUiState> get groupUiState =>
      _$this._groupUiState ??= new MapBuilder<String, GroupUiState>();
  set groupUiState(MapBuilder<String, GroupUiState> groupUiState) =>
      _$this._groupUiState = groupUiState;

  UiStateBuilder();

  UiStateBuilder get _$this {
    if (_$v != null) {
      _groupUiState = _$v.groupUiState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UiState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UiState;
  }

  @override
  void update(void Function(UiStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UiState build() {
    _$UiState _$result;
    try {
      _$result = _$v ?? new _$UiState._(groupUiState: groupUiState.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'groupUiState';
        groupUiState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UiState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$GroupUiState extends GroupUiState {
  @override
  final String lastSelectedChannel;
  @override
  final BuiltMap<String, ChannelUiState> channelUiState;

  factory _$GroupUiState([void Function(GroupUiStateBuilder) updates]) =>
      (new GroupUiStateBuilder()..update(updates)).build();

  _$GroupUiState._({this.lastSelectedChannel, this.channelUiState})
      : super._() {
    if (channelUiState == null) {
      throw new BuiltValueNullFieldError('GroupUiState', 'channelUiState');
    }
  }

  @override
  GroupUiState rebuild(void Function(GroupUiStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupUiStateBuilder toBuilder() => new GroupUiStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupUiState &&
        lastSelectedChannel == other.lastSelectedChannel &&
        channelUiState == other.channelUiState;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc(0, lastSelectedChannel.hashCode), channelUiState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GroupUiState')
          ..add('lastSelectedChannel', lastSelectedChannel)
          ..add('channelUiState', channelUiState))
        .toString();
  }
}

class GroupUiStateBuilder
    implements Builder<GroupUiState, GroupUiStateBuilder> {
  _$GroupUiState _$v;

  String _lastSelectedChannel;
  String get lastSelectedChannel => _$this._lastSelectedChannel;
  set lastSelectedChannel(String lastSelectedChannel) =>
      _$this._lastSelectedChannel = lastSelectedChannel;

  MapBuilder<String, ChannelUiState> _channelUiState;
  MapBuilder<String, ChannelUiState> get channelUiState =>
      _$this._channelUiState ??= new MapBuilder<String, ChannelUiState>();
  set channelUiState(MapBuilder<String, ChannelUiState> channelUiState) =>
      _$this._channelUiState = channelUiState;

  GroupUiStateBuilder();

  GroupUiStateBuilder get _$this {
    if (_$v != null) {
      _lastSelectedChannel = _$v.lastSelectedChannel;
      _channelUiState = _$v.channelUiState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupUiState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GroupUiState;
  }

  @override
  void update(void Function(GroupUiStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GroupUiState build() {
    _$GroupUiState _$result;
    try {
      _$result = _$v ??
          new _$GroupUiState._(
              lastSelectedChannel: lastSelectedChannel,
              channelUiState: channelUiState.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channelUiState';
        channelUiState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'GroupUiState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ChannelUiState extends ChannelUiState {
  @override
  final String inputDraft;

  factory _$ChannelUiState([void Function(ChannelUiStateBuilder) updates]) =>
      (new ChannelUiStateBuilder()..update(updates)).build();

  _$ChannelUiState._({this.inputDraft}) : super._();

  @override
  ChannelUiState rebuild(void Function(ChannelUiStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelUiStateBuilder toBuilder() =>
      new ChannelUiStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelUiState && inputDraft == other.inputDraft;
  }

  @override
  int get hashCode {
    return $jf($jc(0, inputDraft.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChannelUiState')
          ..add('inputDraft', inputDraft))
        .toString();
  }
}

class ChannelUiStateBuilder
    implements Builder<ChannelUiState, ChannelUiStateBuilder> {
  _$ChannelUiState _$v;

  String _inputDraft;
  String get inputDraft => _$this._inputDraft;
  set inputDraft(String inputDraft) => _$this._inputDraft = inputDraft;

  ChannelUiStateBuilder();

  ChannelUiStateBuilder get _$this {
    if (_$v != null) {
      _inputDraft = _$v.inputDraft;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelUiState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChannelUiState;
  }

  @override
  void update(void Function(ChannelUiStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChannelUiState build() {
    final _$result = _$v ?? new _$ChannelUiState._(inputDraft: inputDraft);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
