import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/group.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'group_list_viewmodel.g.dart';

abstract class GroupListViewModel
    implements Built<GroupListViewModel, GroupListViewModelBuilder> {
  BuiltList<Group> get groups;
  BuiltList<String> get updatedGroups;
  String get selectedGroupId;

  GroupListViewModel._();

  factory GroupListViewModel(
          [void Function(GroupListViewModelBuilder) updates]) =
      _$GroupListViewModel;

  static GroupListViewModel fromStore(Store<AppState> store) {
    final unreadGroupsMap = store.state.user.unreadUpdates.toMap();
    unreadGroupsMap.removeWhere((key, value) => value == null || value.length == 0);

    return GroupListViewModel((c) => c
      ..groups = ListBuilder(store.state.groups.values)
      ..selectedGroupId = store.state.selectedGroupId
      ..updatedGroups = ListBuilder(unreadGroupsMap.keys));
  }
}
