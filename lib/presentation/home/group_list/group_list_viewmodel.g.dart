// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_list_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupListViewModel extends GroupListViewModel {
  @override
  final BuiltList<Group> groups;
  @override
  final BuiltList<String> updatedGroups;
  @override
  final String selectedGroupId;

  factory _$GroupListViewModel(
          [void Function(GroupListViewModelBuilder) updates]) =>
      (new GroupListViewModelBuilder()..update(updates)).build();

  _$GroupListViewModel._(
      {this.groups, this.updatedGroups, this.selectedGroupId})
      : super._() {
    if (groups == null) {
      throw new BuiltValueNullFieldError('GroupListViewModel', 'groups');
    }
    if (updatedGroups == null) {
      throw new BuiltValueNullFieldError('GroupListViewModel', 'updatedGroups');
    }
    if (selectedGroupId == null) {
      throw new BuiltValueNullFieldError(
          'GroupListViewModel', 'selectedGroupId');
    }
  }

  @override
  GroupListViewModel rebuild(
          void Function(GroupListViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupListViewModelBuilder toBuilder() =>
      new GroupListViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupListViewModel &&
        groups == other.groups &&
        updatedGroups == other.updatedGroups &&
        selectedGroupId == other.selectedGroupId;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, groups.hashCode), updatedGroups.hashCode),
        selectedGroupId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GroupListViewModel')
          ..add('groups', groups)
          ..add('updatedGroups', updatedGroups)
          ..add('selectedGroupId', selectedGroupId))
        .toString();
  }
}

class GroupListViewModelBuilder
    implements Builder<GroupListViewModel, GroupListViewModelBuilder> {
  _$GroupListViewModel _$v;

  ListBuilder<Group> _groups;
  ListBuilder<Group> get groups => _$this._groups ??= new ListBuilder<Group>();
  set groups(ListBuilder<Group> groups) => _$this._groups = groups;

  ListBuilder<String> _updatedGroups;
  ListBuilder<String> get updatedGroups =>
      _$this._updatedGroups ??= new ListBuilder<String>();
  set updatedGroups(ListBuilder<String> updatedGroups) =>
      _$this._updatedGroups = updatedGroups;

  String _selectedGroupId;
  String get selectedGroupId => _$this._selectedGroupId;
  set selectedGroupId(String selectedGroupId) =>
      _$this._selectedGroupId = selectedGroupId;

  GroupListViewModelBuilder();

  GroupListViewModelBuilder get _$this {
    if (_$v != null) {
      _groups = _$v.groups?.toBuilder();
      _updatedGroups = _$v.updatedGroups?.toBuilder();
      _selectedGroupId = _$v.selectedGroupId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupListViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GroupListViewModel;
  }

  @override
  void update(void Function(GroupListViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GroupListViewModel build() {
    _$GroupListViewModel _$result;
    try {
      _$result = _$v ??
          new _$GroupListViewModel._(
              groups: groups.build(),
              updatedGroups: updatedGroups.build(),
              selectedGroupId: selectedGroupId);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'groups';
        groups.build();
        _$failedField = 'updatedGroups';
        updatedGroups.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'GroupListViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
