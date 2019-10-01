import "package:built_collection/built_collection.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/domain/redux/ui/ui_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/group.dart";
import "package:redux/redux.dart";

final channelReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, OnChannelsLoaded>(_onChannelsLoaded),
  TypedReducer<AppState, OnChannelCreated>(_onChannelCreated),
  TypedReducer<AppState, SelectChannel>(_selectChannel),
  TypedReducer<AppState, OnUpdatedChannelAction>(_onUpdateSelectedChannel),
  TypedReducer<AppState, JoinedChannelAction>(_onJoinedChannel),
  TypedReducer<AppState, LeftChannelAction>(_onLeftChannel),
  TypedReducer<AppState, JoinChannelFailedAction>(_onJoinChannelFailed),
  TypedReducer<AppState, ClearFailedJoinAction>(_onClearFailedJoin),
  TypedReducer<AppState, RsvpAction>(_rsvp),
];

AppState _onJoinChannelFailed(AppState state, JoinChannelFailedAction action) {
  return state.rebuild(
      (a) => a..channelState.update((s) => s..joinChannelFailed = true));
}

AppState _onClearFailedJoin(AppState state, ClearFailedJoinAction action) {
  return state.rebuild(
      (a) => a..channelState.update((s) => s..joinChannelFailed = false));
}

AppState _onJoinedChannel(AppState state, JoinedChannelAction action) {
  return _updateChannel(state, action.channel, action.groupId);
}

AppState _onLeftChannel(AppState state, LeftChannelAction action) {
  final channel = getSelectedChannel(state).rebuild((c) =>
      c..users.update((uid) => uid.removeWhere((u) => u.id == action.userId)));

  return _updateChannel(state, channel, action.groupId);
}

AppState _onUpdateSelectedChannel(
    AppState state, OnUpdatedChannelAction action) {
  return _updateChannel(state, action.selectedChannel, action.groupId);
}

AppState _updateChannel(
  AppState state,
  Channel channel,
  String groupId,
) {
  final groupChannels = (GroupBuilder c) {
    return c
      ..channels.update((channels) {
        channels[channel.id] = channel;
      });
  };

  return state.rebuild((s) {
    return s
      ..groups.update((groups) {
        groups[groupId] = groups[groupId].rebuild(groupChannels);
      });
  });
}

AppState _onChannelsLoaded(AppState state, OnChannelsLoaded action) {
  final groupId = action.groupId;
  final Map<String, Channel> channels = Map.fromIterable(
    action.channels,
    key: (item) => item.id,
    value: (item) => item,
  );
  final updateChannels = (GroupBuilder c) => c..channels = MapBuilder(channels);
  return _updateCircle(state, groupId, updateChannels);
}

AppState _updateCircle(
  AppState state,
  String groupId,
  update(GroupBuilder c),
) {
  return state.rebuild((a) => a
    ..groups.update((groups) {
      groups[groupId] = groups[groupId].rebuild(update);
    }));
}

AppState _onChannelCreated(AppState state, OnChannelCreated action) {
  final groupId = state.selectedGroupId;
  final updateChannels = (GroupBuilder c) => c
    ..channels.update((channels) {
      channels[action.channel.id] = action.channel;
    });
  return _updateCircle(state, groupId, updateChannels);
}

AppState _selectChannel(AppState state, SelectChannel action) {
  final GroupUiStateBuilder Function(GroupUiStateBuilder value)
      updateLastSelectedChannel =
      (g) => g..lastSelectedChannel = action.channel.id;

  final updatedState = state.rebuild(
    (s) => s
      ..channelState.selectedChannel = action.channel.id
      ..uiState.groupUiState.updateValue(
            action.groupId,
            (g) => g.rebuild(updateLastSelectedChannel),
            ifAbsent: () => GroupUiState(updateLastSelectedChannel),
          ),
  );

  // Mark channel as read
  final channel = action.channel.rebuild((c) => c..hasUpdates = false);
  return _updateChannel(updatedState, channel, action.groupId);
}

AppState _rsvp(AppState state, RsvpAction action) {
  final users = getSelectedChannel(state).users;
  final channel = getSelectedChannel(state).toBuilder();
  final channelUser = users.firstWhere((u) => u.id == state.user.uid);
  final channelUserRsvp = channelUser.rebuild((c) => c..rsvp = action.rsvp);
  channel.update((c) => c
    ..users.remove(channelUser)
    ..users.add(channelUserRsvp));
  return _updateChannel(state, channel.build(), state.selectedGroupId);
}
