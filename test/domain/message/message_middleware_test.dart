import "dart:async";

import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel_state.dart";
import "package:circles_app/domain/redux/message/message_actions.dart";
import "package:circles_app/domain/redux/message/message_middleware.dart";
import "package:circles_app/model/message.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart";
import "package:mockito/mockito.dart";
import "package:redux/redux.dart";

import "../../data/data_mocks.dart";
import "../redux_mocks.dart";

main() {
  group("Message Middleware", () {
    final user = mockUser;
    final repository = MockMessageRepository();
    final captor = MockMiddleware();
    final channel = mockChannel;
    final store = Store<AppState>(
      appReducer,
      initialState: AppState.init().rebuild((a) => a
        ..selectedGroupId = "groupId"
        ..user = user.toBuilder()
        ..groups.replace({"groupId": mockGroup})
        ..channelState = ChannelState.init()
            .rebuild((cs) => cs..selectedChannel = "channelId")
            .toBuilder()),
      middleware: createMessagesMiddleware(repository)..add(captor),
    );
    final message = Message((m) => m
      ..body = "BODY"
      ..timestamp = DateTime(2019)
      ..authorId = "authorId");

    test("should send message", () {
      when(repository.sendMessage(
        "groupId",
        channel.id,
        any,
      )).thenAnswer((_) => SynchronousFuture(message));
      store.dispatch(SendMessage("BODY"));
      verify(
        repository.sendMessage(
          "groupId",
          channel.id,
          any,
        ),
      );
    });

    test("should receive message", () {
      // ignore: close_sinks
      final controller = StreamController<List<Message>>(sync: true);
      when(repository.getMessagesStream(
        "groupId",
        "channelId",
        "userId",
      )).thenAnswer((_) => controller.stream);
      store.dispatch(SelectChannel(
          channel: channel,
          groupId: "groupdId",
          userId: "userId",
          previousChannelId: "PCID"));

      verify(
        repository.getMessagesStream(
          "groupId",
          channel.id,
          "userId",
        ),
      );

      controller.add([message]);

      verify(
        captor.call(
          any,
          TypeMatcher<UpdateAllMessages>(),
          any,
        ) as dynamic,
      );
    });

    test("should set emoji reaction", () {
      when(repository.addReaction(
        groupId: "groupId",
        channelId: "channelId",
        messageId: "ID",
        reaction: anyNamed("reaction"),
      )).thenAnswer((_) => SynchronousFuture(null));

      store.dispatch(EmojiReaction("ID", "EMOJI"));

      verify(
        repository.addReaction(
          reaction: anyNamed("reaction"),
          messageId: "ID",
          groupId: "groupId",
          channelId: "channelId",
        ),
      );
    });

    test("should remove emoji reaction", () {
      when(repository.removeReaction(
        groupId: "groupId",
        channelId: "channelId",
        messageId: "ID",
        userId: "userId",
      )).thenAnswer((_) => SynchronousFuture(null));

      store.dispatch(RemoveEmojiReaction("ID"));

      verify(
        repository.removeReaction(
          userId: "userId",
          messageId: "ID",
          groupId: "groupId",
          channelId: "channelId",
        ),
      );
    });
  });
}
