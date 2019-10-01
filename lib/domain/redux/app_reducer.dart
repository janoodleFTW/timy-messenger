import "package:built_collection/built_collection.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/authentication/auth_reducer.dart";
import "package:circles_app/domain/redux/calendar/calendar_reducer.dart";
import "package:circles_app/domain/redux/channel/channel_reducer.dart";
import "package:circles_app/domain/redux/ui/ui_reducer.dart";
import "package:circles_app/model/channel_state.dart";
import "package:circles_app/domain/redux/message/message_reducer.dart";
import "package:circles_app/domain/redux/push/push_reducer.dart";
import "package:circles_app/domain/redux/user/user_reducer.dart";
import "package:circles_app/model/group.dart";
import "package:redux/redux.dart";

/// Reducers specify how the application"s state changes in response to actions
/// sent to the store.
///
/// Each reducer returns a new [AppState].
///
final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, OnGroupsLoaded>(_onGroupsLoaded),
  TypedReducer<AppState, SelectGroup>(_onSelectGroup),
  ...authReducers,
  ...userReducers,
  ...calendarReducer,
  ...channelReducers,
  ...messageReducers,
  ...pushReducers,
  ...uiReducers,
]);

AppState _onGroupsLoaded(AppState state, OnGroupsLoaded action) {
  if (action.groups.isNotEmpty) {
    final selectedGroup = state.selectedGroupId;
    final Map<String, Group> groups = Map.fromIterable(
      action.groups,
      key: (item) => item.id,
      value: (item) => item,
    );
    return state.rebuild((a) => a
      ..selectedGroupId = selectedGroup
      ..groups = MapBuilder(groups));
  } else {
    return state.rebuild((a) => a
      ..channelState = ChannelState.init().toBuilder()
      ..groups = MapBuilder());
  }
}

AppState _onSelectGroup(AppState state, SelectGroup action) {
  return state.rebuild((a) => a..selectedGroupId = action.groupId);
}
