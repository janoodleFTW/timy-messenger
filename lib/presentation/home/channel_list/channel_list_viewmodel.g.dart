// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_list_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChannelListViewModel extends ChannelListViewModel {
  @override
  final User user;
  @override
  final BuiltList<ChannelListItem> items;

  factory _$ChannelListViewModel(
          [void Function(ChannelListViewModelBuilder) updates]) =>
      (new ChannelListViewModelBuilder()..update(updates)).build();

  _$ChannelListViewModel._({this.user, this.items}) : super._() {
    if (user == null) {
      throw new BuiltValueNullFieldError('ChannelListViewModel', 'user');
    }
    if (items == null) {
      throw new BuiltValueNullFieldError('ChannelListViewModel', 'items');
    }
  }

  @override
  ChannelListViewModel rebuild(
          void Function(ChannelListViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChannelListViewModelBuilder toBuilder() =>
      new ChannelListViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChannelListViewModel &&
        user == other.user &&
        items == other.items;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, user.hashCode), items.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChannelListViewModel')
          ..add('user', user)
          ..add('items', items))
        .toString();
  }
}

class ChannelListViewModelBuilder
    implements Builder<ChannelListViewModel, ChannelListViewModelBuilder> {
  _$ChannelListViewModel _$v;

  UserBuilder _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder user) => _$this._user = user;

  ListBuilder<ChannelListItem> _items;
  ListBuilder<ChannelListItem> get items =>
      _$this._items ??= new ListBuilder<ChannelListItem>();
  set items(ListBuilder<ChannelListItem> items) => _$this._items = items;

  ChannelListViewModelBuilder();

  ChannelListViewModelBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _items = _$v.items?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChannelListViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChannelListViewModel;
  }

  @override
  void update(void Function(ChannelListViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChannelListViewModel build() {
    _$ChannelListViewModel _$result;
    try {
      _$result = _$v ??
          new _$ChannelListViewModel._(
              user: user.build(), items: items.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ChannelListViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
