import "dart:async";

import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/domain/redux/channel/channel_middleware.dart";
import "package:circles_app/domain/redux/ui/ui_state.dart";
import "package:circles_app/model/channel_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart";
import "package:mockito/mockito.dart";
import "package:redux/redux.dart";

import "../../data/data_mocks.dart";
import "../redux_mocks.dart";

main() {
  group("Channel Middleware", () {
    test("select channel when loading channels and no other channel selected",
        () {
      final repo = MockChannelsRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((s) => s
          ..selectedGroupId = "groupId"
          ..user = mockUser.toBuilder()
          // No selected channel previously
          ..channelState = ChannelState.init().toBuilder()),
        middleware: createChannelsMiddleware(repo, null)..add(captor),
      );

      final controller = StreamController<List<Channel>>(sync: true);

      when(repo.getChannelsStream("groupId", "userId"))
          .thenAnswer((_) => controller.stream);

      when(repo.getStreamForChannel("groupId", "channel2", "userId"))
          .thenAnswer((_) => Stream.empty());

      store.dispatch(LoadChannels("groupId"));

      // Channel1 is closed, channel2 is open
      final channel1 = mockChannel.rebuild((c) => c
        ..id = "channel1"
        ..visibility = ChannelVisibility.CLOSED);
      final channel2 = mockChannel.rebuild((c) => c
        ..id = "channel2"
        ..visibility = ChannelVisibility.OPEN);

      // Load channels
      controller.add([channel1, channel2]);

      // Should select channel 2 because is first open
      final action = SelectChannel(
        previousChannelId: null,
        channel: channel2,
        groupId: "groupId",
        userId: "userId",
      );
      verify(captor.call(any, action, any) as dynamic);

      controller.close();
    });

    test("select channel when loading channels with last selected channel", () {
      final repo = MockChannelsRepository();
      final captor = MockMiddleware();
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((s) => s
          ..selectedGroupId = "groupId"
          ..user = mockUser.toBuilder()
          // previously selected channel for the group is the channel1
          ..uiState.groupUiState["groupId"] =
              GroupUiState((s) => s..lastSelectedChannel = "channel1")
          ..channelState = ChannelState.init().toBuilder()),
        middleware: createChannelsMiddleware(repo, null)..add(captor),
      );

      final controller = StreamController<List<Channel>>(sync: true);

      when(repo.getChannelsStream("groupId", "userId"))
          .thenAnswer((_) => controller.stream);

      when(repo.getStreamForChannel("groupId", "channel1", "userId"))
          .thenAnswer((_) => Stream.empty());

      store.dispatch(LoadChannels("groupId"));

      // Channel1 is closed, channel2 is open
      final channel1 = mockChannel.rebuild((c) => c
        ..id = "channel1"
        ..visibility = ChannelVisibility.CLOSED);
      final channel2 = mockChannel.rebuild((c) => c
        ..id = "channel2"
        ..visibility = ChannelVisibility.OPEN);

      // Load channels
      controller.add([channel1, channel2]);

      // Should select channel 1 because it is the previous selected one
      final action = SelectChannel(
        previousChannelId: null,
        channel: channel1,
        groupId: "groupId",
        userId: "userId",
      );
      verify(captor.call(any, action, any) as dynamic);

      controller.close();
    });

    test("handle RSVP.YES should update channel", () {
      final repo = MockChannelsRepository();
      final captor = MockMiddleware();
      final user = User((u) => u
        ..uid = "userId"
        ..name = "name"
        ..email = "email");
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((s) => s
          ..selectedGroupId = "groupId"
          ..user = user.toBuilder()
          ..groups.replace({"groupId": mockGroup})
          ..channelState = ChannelState.init()
              .rebuild((cs) => cs..selectedChannel = "channelId")
              .toBuilder()),
        middleware: createChannelsMiddleware(repo, null)..add(captor),
      );
      when(repo.rsvp("groupId", "channelId", "userId", RSVP.YES))
          .thenAnswer((_) => SynchronousFuture(0));

      final completer = Completer();

      store.dispatch(RsvpAction(RSVP.YES, completer));

      verify(repo.rsvp("groupId", "channelId", "userId", RSVP.YES));
      verifyNever(repo.leaveChannel("groupId", "channelId", "userId"));

      expect(completer.isCompleted, true);
    });

    test("handle RSVP.NO should leave channel", () async {
      final repo = MockChannelsRepository();
      final captor = MockMiddleware();
      final user = User((u) => u
        ..uid = "userId"
        ..name = "name"
        ..email = "email");
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((s) => s
          ..selectedGroupId = "groupId"
          ..user = user.toBuilder()
          ..groups.replace({"groupId": mockGroup})
          ..channelState = ChannelState.init()
              .rebuild((cs) => cs..selectedChannel = "channelId")
              .toBuilder()),
        middleware: createChannelsMiddleware(repo, null)..add(captor),
      );
      when(repo.rsvp("groupId", "channelId", "userId", RSVP.NO))
          .thenAnswer((_) => SynchronousFuture(0));
      when(repo.leaveChannel("groupId", "channelId", "userId"))
          .thenAnswer((_) => SynchronousFuture(0));
      final completer = Completer();

      store.dispatch(RsvpAction(RSVP.NO, completer));

      verify(repo.rsvp("groupId", "channelId", "userId", RSVP.NO));
      verify(repo.leaveChannel("groupId", "channelId", "userId"));
      verify(captor.call(
        any,
        TypeMatcher<LeftChannelAction>(),
        any,
      ) as dynamic);

      await completer.future;

      expect(completer.isCompleted, true);
    });
  });
}
