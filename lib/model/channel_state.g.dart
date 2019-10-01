// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChannelState extends ChannelState {
  @override
  final String selectedChannel;
  @override
  final bool joinChannelFailed;

  factory _$ChannelState([void Function(ChannelStateBuilder) updates]) =>
      (new ChannelStateBuilder()..update(updates)).build();

  _$ChannelState._({this.selectedChannel, this.joinChannelFailed}) : super._() {
    if (joinChannelFailed == null) {
      throw new BuiltValueNullFieldError('ChannelState', 'joinChannelFailed');
    }
  }

  @override
  ChannelState rebuild(void Function(ChannelStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelStateBuilder toBuilder() => new ChannelStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelState &&
        selectedChannel == other.selectedChannel &&
        joinChannelFailed == other.joinChannelFailed;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc(0, selectedChannel.hashCode), joinChannelFailed.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChannelState')
          ..add('selectedChannel', selectedChannel)
          ..add('joinChannelFailed', joinChannelFailed))
        .toString();
  }
}

class ChannelStateBuilder
    implements Builder<ChannelState, ChannelStateBuilder> {
  _$ChannelState _$v;

  String _selectedChannel;
  String get selectedChannel => _$this._selectedChannel;
  set selectedChannel(String selectedChannel) =>
      _$this._selectedChannel = selectedChannel;

  bool _joinChannelFailed;
  bool get joinChannelFailed => _$this._joinChannelFailed;
  set joinChannelFailed(bool joinChannelFailed) =>
      _$this._joinChannelFailed = joinChannelFailed;

  ChannelStateBuilder();

  ChannelStateBuilder get _$this {
    if (_$v != null) {
      _selectedChannel = _$v.selectedChannel;
      _joinChannelFailed = _$v.joinChannelFailed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChannelState;
  }

  @override
  void update(void Function(ChannelStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChannelState build() {
    final _$result = _$v ??
        new _$ChannelState._(
            selectedChannel: selectedChannel,
            joinChannelFailed: joinChannelFailed);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
