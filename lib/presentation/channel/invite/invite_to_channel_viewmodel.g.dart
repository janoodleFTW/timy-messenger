// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_to_channel_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InviteToChannelViewModel extends InviteToChannelViewModel {
  @override
  final BuiltList<User> newUsers;
  @override
  final void Function(Iterable<String>, Completer) inviteToChannel;

  factory _$InviteToChannelViewModel(
          [void Function(InviteToChannelViewModelBuilder) updates]) =>
      (new InviteToChannelViewModelBuilder()..update(updates)).build();

  _$InviteToChannelViewModel._({this.newUsers, this.inviteToChannel})
      : super._() {
    if (newUsers == null) {
      throw new BuiltValueNullFieldError(
          'InviteToChannelViewModel', 'newUsers');
    }
    if (inviteToChannel == null) {
      throw new BuiltValueNullFieldError(
          'InviteToChannelViewModel', 'inviteToChannel');
    }
  }

  @override
  InviteToChannelViewModel rebuild(
          void Function(InviteToChannelViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InviteToChannelViewModelBuilder toBuilder() =>
      new InviteToChannelViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InviteToChannelViewModel && newUsers == other.newUsers;
  }

  @override
  int get hashCode {
    return $jf($jc(0, newUsers.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('InviteToChannelViewModel')
          ..add('newUsers', newUsers)
          ..add('inviteToChannel', inviteToChannel))
        .toString();
  }
}

class InviteToChannelViewModelBuilder
    implements
        Builder<InviteToChannelViewModel, InviteToChannelViewModelBuilder> {
  _$InviteToChannelViewModel _$v;

  ListBuilder<User> _newUsers;
  ListBuilder<User> get newUsers =>
      _$this._newUsers ??= new ListBuilder<User>();
  set newUsers(ListBuilder<User> newUsers) => _$this._newUsers = newUsers;

  void Function(Iterable<String>, Completer) _inviteToChannel;
  void Function(Iterable<String>, Completer) get inviteToChannel =>
      _$this._inviteToChannel;
  set inviteToChannel(
          void Function(Iterable<String>, Completer) inviteToChannel) =>
      _$this._inviteToChannel = inviteToChannel;

  InviteToChannelViewModelBuilder();

  InviteToChannelViewModelBuilder get _$this {
    if (_$v != null) {
      _newUsers = _$v.newUsers?.toBuilder();
      _inviteToChannel = _$v.inviteToChannel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InviteToChannelViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$InviteToChannelViewModel;
  }

  @override
  void update(void Function(InviteToChannelViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$InviteToChannelViewModel build() {
    _$InviteToChannelViewModel _$result;
    try {
      _$result = _$v ??
          new _$InviteToChannelViewModel._(
              newUsers: newUsers.build(), inviteToChannel: inviteToChannel);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'newUsers';
        newUsers.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'InviteToChannelViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
