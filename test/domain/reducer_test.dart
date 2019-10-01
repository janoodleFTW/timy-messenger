import "package:built_collection/built_collection.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel_state.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:redux/redux.dart";
import "package:test/test.dart";

main() {
  group("State Reducer", () {
    final channel = Channel((c) => c
      ..type = ChannelType.TOPIC
      ..id = "CHANNELID"
      ..name = "CHANNEL"
      ..visibility = ChannelVisibility.OPEN
      ..users = ListBuilder<ChannelUser>()
      ..hasUpdates = true);

    final group = Group((c) => c
      ..id = "ID"
      ..name = "CIRCLE"
      ..hexColor = "FFFFFF"
      ..abbreviation = "CI"
      ..channels = MapBuilder());

    test("should load group into store", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      expect(store.state.groups, MapBuilder<String, Group>().build());

      store.dispatch(OnGroupsLoaded([group]));

      expect(
          store.state.groups, MapBuilder<String, Group>({"ID": group}).build());
      expect(store.state.selectedGroupId, null);
    });

    test("should load topics into store", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init()
            .rebuild((a) => a..groups = MapBuilder({"ID": group})),
      );

      expect(
          store.state.groups["ID"].channels, BuiltMap<String, Channel>.of({}));

      store.dispatch(OnChannelsLoaded("ID", [channel]));

      expect(store.state.groups["ID"].channels,
          BuiltMap<String, Channel>.of({"CHANNELID": channel}));
    });

    test("should select group", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init()
            .rebuild((a) => a..groups = MapBuilder({"ID": group})),
      );

      expect(store.state.selectedGroupId, null);

      store.dispatch(SelectGroup("ID"));

      expect(store.state.selectedGroupId, "ID");
    });

    test("should add created channel", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..selectedGroupId = "ID"
          ..groups = MapBuilder({"ID": group})),
      );

      expect(
          store.state.groups["ID"].channels, BuiltMap<String, Channel>.of({}));
      store.dispatch(OnChannelCreated(channel));
      expect(store.state.groups["ID"].channels,
          BuiltMap<String, Channel>.of({"CHANNELID": channel}));
    });

    test("should leave channel", () {
      final channel = Channel((c) => c
        ..type = ChannelType.TOPIC
        ..id = "CHANNELID"
        ..name = "CHANNEL"
        ..visibility = ChannelVisibility.OPEN
        ..users = ListBuilder<ChannelUser>([
          ChannelUser((u) => u
            ..id = "USERID"
            ..rsvp = RSVP.UNSET)
        ]));

      final channelState = ChannelState.init()
          .rebuild((cs) => cs..selectedChannel = channel.id)
          .toBuilder();

      final Map<String, Channel> channels = Map.fromIterable(
        [channel],
        key: (item) => item.id,
        value: (item) => item,
      );

      final initializedGroup =
          group.rebuild((c) => c..channels = MapBuilder(channels));

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..selectedGroupId = "ID"
          ..channelState = channelState
          ..groups = MapBuilder({"ID": initializedGroup})),
      );

      expect(getSelectedChannel(store.state).users, [
        ChannelUser((u) => u
          ..id = "USERID"
          ..rsvp = RSVP.UNSET)
      ]);
      expect(store.state.groups["ID"].channels["CHANNELID"].users, [
        ChannelUser((u) => u
          ..id = "USERID"
          ..rsvp = RSVP.UNSET)
      ]);
      store.dispatch(LeftChannelAction("ID", "CHANNELID", "USERID"));
      expect(getSelectedChannel(store.state).users, []);
      expect(store.state.groups["ID"].channels["CHANNELID"].users, []);
    });

    test("should join channel", () {
      final channelState = ChannelState.init()
          .rebuild((cs) => cs..selectedChannel = channel.id)
          .toBuilder();

      final Map<String, Channel> channels = Map.fromIterable(
        [channel],
        key: (item) => item.id,
        value: (item) => item,
      );

      final initializedCircle =
          group.rebuild((c) => c..channels = MapBuilder(channels));

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..selectedGroupId = "ID"
          ..channelState = channelState
          ..groups = MapBuilder({"ID": initializedCircle})),
      );

      expect(getSelectedChannel(store.state).users, []);
      expect(store.state.groups["ID"].channels["CHANNELID"].users, []);

      final channelWithUser = channel.rebuild((c) => c
        ..users.add(ChannelUser((cu) => cu
          ..id = "USERID"
          ..rsvp = RSVP.UNSET)));
      store.dispatch(JoinedChannelAction("ID", channelWithUser));

      expect(getSelectedChannel(store.state).users, [
        ChannelUser((u) => u
          ..id = "USERID"
          ..rsvp = RSVP.UNSET)
      ]);
      expect(store.state.groups["ID"].channels["CHANNELID"].users, [
        ChannelUser((u) => u
          ..id = "USERID"
          ..rsvp = RSVP.UNSET)
      ]);
    });

    test("should flag channel as read", () {
      final channel = Channel((c) => c
        ..type = ChannelType.TOPIC
        ..id = "CHANNELID"
        ..name = "CHANNEL"
        ..visibility = ChannelVisibility.OPEN
        ..users = ListBuilder<ChannelUser>()
        ..hasUpdates = true);

      final rebuildCircle = group
          .rebuild((c) => c..channels = MapBuilder({"CHANNELID": channel}));

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..selectedGroupId = "ID"
          ..groups = MapBuilder({"ID": group})),
      );

      store.dispatch(SelectChannel(
          channel: channel,
          groupId: rebuildCircle.id,
          userId: "UID",
          previousChannelId: "PCID"));
      final updatedCircle =
          store.state.groups.values.toList().firstWhere((c) => c.id == "ID");
      expect(
          updatedCircle.channels.values
              .firstWhere((i) => i.id == "CHANNELID")
              .hasUpdates,
          false);
    });

    test("should set join channel error flag", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..selectedGroupId = "ID"
          ..groups = MapBuilder({"ID": group})),
      );

      expect(store.state.channelState.joinChannelFailed, false);
      store.dispatch(JoinChannelFailedAction());
      expect(store.state.channelState.joinChannelFailed, true);
      store.dispatch(ClearFailedJoinAction());
      expect(store.state.channelState.joinChannelFailed, false);
    });
  });
}
