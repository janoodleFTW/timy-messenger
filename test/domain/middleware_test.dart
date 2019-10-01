import "dart:async";

import "package:built_collection/built_collection.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/domain/redux/channel/channel_middleware.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_middleware.dart";
import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:flutter/foundation.dart";
import "package:redux/redux.dart";
import "package:mockito/mockito.dart";
import "package:test/test.dart";

import "redux_mocks.dart";

class FutureCallbackMock extends Mock implements Function {
  Future<void> call();
}

main() {
  group("Middleware", () {
    final repository = MockGroupRepository();
    final channelsRepository = MockChannelsRepository();
    final captor = MockMiddleware();
    final user = User((u) => u
      ..uid = "USERID"
      ..name = "NAME"
      ..email = "EMAIL");
    final group = Group((c) => c
      ..id = "ID"
      ..name = "CIRCLE"
      ..hexColor = "FFFFFF"
      ..abbreviation = "CI");
    final channel = Channel((c) => c
      ..type = ChannelType.TOPIC
      ..id = "CHANNELID"
      ..name = "CHANNEL"
      ..visibility = ChannelVisibility.OPEN
      ..users = ListBuilder<ChannelUser>());

    test("should load user data", () {
      final store = Store<AppState>(
        appReducer,
        initialState:
            AppState.init().rebuild((a) => a..user = user.toBuilder()),
        middleware: createStoreMiddleware(repository)
          ..addAll(createChannelsMiddleware(channelsRepository, null))
          ..add(captor),
      );

      // Loads all groups for user and selects one.
      final groupController = StreamController<List<Group>>(sync: true);
      when(repository.getGroupStream("USERID"))
          .thenAnswer((_) => groupController.stream);

      final channelResult = [channel];
      // Load all channels for group and selects one.
      final controller = StreamController<List<Channel>>(sync: true);
      when(channelsRepository.getChannelsStream("ID", "USERID"))
          .thenAnswer((_) => controller.stream);

      // Subscribe to selected channel.
      final selectedChannelController = StreamController<Channel>(sync: true);
      when(channelsRepository.getStreamForChannel("ID", "CHANNELID", "USERID"))
          .thenAnswer((_) => selectedChannelController.stream);

      store.dispatch(ConnectToDataSource());
      groupController.add([group]);

      verify(repository.getGroupStream("USERID"));
      verify(captor.call(
        any,
        TypeMatcher<OnGroupsLoaded>(),
        any,
      ) as dynamic);

      verify(channelsRepository.getChannelsStream("ID", "USERID"));
      controller.add(channelResult);

      verify(captor.call(
        any,
        TypeMatcher<OnChannelsLoaded>(),
        any,
      ) as dynamic);

      verify(captor.call(
        any,
        TypeMatcher<SelectChannel>(),
        any,
      ) as dynamic);

      selectedChannelController.close();
      groupController.close();
      controller.close();
    });

    test("should create channel", () async {
      final globalKey = MockGlobalKey();

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..groups = MapBuilder({"ID": group})
          ..selectedGroupId = "ID"
          ..user = user.toBuilder()),
        middleware: createStoreMiddleware(repository)
          ..addAll(createChannelsMiddleware(channelsRepository, globalKey))
          ..add(captor),
      );

      final channel = Channel((c) => c
        ..id = "CHANNELID"
        ..type = ChannelType.TOPIC
        ..name = "CHANNEL"
        ..users = ListBuilder([])
        ..visibility = ChannelVisibility.OPEN);

      final channelResult = Channel((c) => c
        ..id = "CHANNELID"
        ..type = ChannelType.TOPIC
        ..name = "CHANNEL"
        ..users = ListBuilder([
          ChannelUser((cu) => cu
            ..id = "MEMBERID1"
            ..rsvp = RSVP.UNSET),
          ChannelUser((cu) => cu
            ..id = "USERID"
            ..rsvp = RSVP.YES)
        ])
        ..visibility = ChannelVisibility.OPEN);

      when(channelsRepository.createChannel(
        "ID",
        channel,
        ["USERID", "MEMBERID1"],
        "USERID",
      )).thenAnswer((_) => SynchronousFuture(channelResult));

      when(channelsRepository.markChannelRead("ID", channel.id, "USERID"))
          .thenAnswer((_) => SynchronousFuture(null));

      store.dispatch(CreateChannel(
        channel,
        BuiltList<String>(["MEMBERID1"]),
        Completer(),
      ));

      verify(channelsRepository.createChannel(
          "ID", channel, ["USERID", "MEMBERID1"], "USERID"));

      verify(captor.call(
        any,
        TypeMatcher<OnChannelCreated>(),
        any,
      ) as dynamic);

      await Future.delayed(const Duration(milliseconds: 1000));

      verify(captor.call(
        any,
        TypeMatcher<SelectChannel>(),
        any,
      ) as dynamic);

      // Verify mark channel read.
      verify(channelsRepository.markChannelRead(
        "ID",
        "CHANNELID",
        "USERID",
      ));

      // ignore: close_sinks
      final selectedChannelController = StreamController<Channel>(sync: true);
      when(channelsRepository.getStreamForChannel(
        "ID",
        "CHANNELID",
        "USERID",
      )).thenAnswer((_) => selectedChannelController.stream);

      // Verify channel subscription
      verify(channelsRepository.getStreamForChannel(
        "ID",
        "CHANNELID",
        "USERID",
      ));
    });

    test("should leave channel", () {
      final globalKey = MockGlobalKey();

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..groups = MapBuilder({"CIID": group})
          ..selectedGroupId = "ID"
          ..user = user.toBuilder()),
        middleware: createStoreMiddleware(repository)
          ..addAll(createChannelsMiddleware(channelsRepository, globalKey))
          ..add(captor),
      );

      when(channelsRepository.leaveChannel("CIID", channel.id, "USERID"))
          .thenAnswer((_) => SynchronousFuture(channel));

      store.dispatch(LeaveChannelAction("CIID", channel, "USERID"));
      verify(channelsRepository.leaveChannel("CIID", channel.id, "USERID"));
      verify(captor.call(
        any,
        TypeMatcher<LeftChannelAction>(),
        any,
      ) as dynamic);
    });

    test("should join channel", () {
      //JoinChannelAction
      final globalKey = MockGlobalKey();

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..groups = MapBuilder({"CIID": group})
          ..selectedGroupId = "ID"
          ..user = user.toBuilder()),
        middleware: createStoreMiddleware(repository)
          ..addAll(createChannelsMiddleware(channelsRepository, globalKey))
          ..add(captor),
      );

      when(channelsRepository.joinChannel("CIID", channel, "USERID"))
          .thenAnswer((_) => SynchronousFuture(channel));
      store.dispatch(
          JoinChannelAction(groupId: "CIID", channel: channel, user: user));
      verify(channelsRepository.joinChannel("CIID", channel, "USERID"));
      verify(captor.call(
        any,
        TypeMatcher<JoinedChannelAction>(),
        any,
      ) as dynamic);
    });

    test("should subscribe to selected channel", () {
      //JoinChannelAction
      final globalKey = MockGlobalKey();

      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) => a
          ..groups = MapBuilder({"CIID": group})
          ..selectedGroupId = "ID"
          ..user = user.toBuilder()),
        middleware: createStoreMiddleware(repository)
          ..addAll(createChannelsMiddleware(channelsRepository, globalKey))
          ..add(captor),
      );

      final selectedChannelController = StreamController<Channel>(sync: true);
      when(channelsRepository.getStreamForChannel("ID", "CHANNELID", "USERID"))
          .thenAnswer((_) => selectedChannelController.stream);

      store.dispatch(
          SelectChannel(channel: channel, groupId: "ID", userId: "USERID"));

      verify(
          channelsRepository.getStreamForChannel("ID", "CHANNELID", "USERID"));

      selectedChannelController.close();
    });
  });
}
