import "package:built_collection/built_collection.dart";
import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/presentation/channel/create/create_channel.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart" as matcher;
import "package:mockito/mockito.dart";
import "package:redux/redux.dart";

import "../../../data/data_mocks.dart";
import "../../../domain/redux_mocks.dart";

void main() {
  group("CreateChannelScreen tests", () {
    testWidgets("create open channel", (WidgetTester tester) async {
      final MockMiddleware captor = await _pumpCreateChannelScreen(tester);
      final topicName = "topic name";
      final purpose = "purpose";

      // Enter channel name and purpose
      await tester.enterText(find.byKey(Key("TopicName")), topicName);
      await tester.enterText(find.byKey(Key("Purpose")), purpose);

      // Tap on create channel button
      await tester.tap(find.byKey(Key("Create")));
      await tester.pumpAndSettle();

      final channel = Channel((c) => c
        ..name = topicName
        ..description = purpose
        ..type = ChannelType.TOPIC
        ..authorId = mockUser.uid
        ..visibility = ChannelVisibility.OPEN);
      final createChannel = CreateChannel(
        channel,
        BuiltList<String>(),
        null,
      );
      verify(captor.call(
        any,
        createChannel,
        any,
      ) as dynamic);
    });

    testWidgets("missing topic name", (WidgetTester tester) async {
      final MockMiddleware captor = await _pumpCreateChannelScreen(tester);

      // Everything is empty (channel name is empty)
      await tester.tap(find.byKey(Key("Create")));
      await tester.pumpAndSettle();

      // Tapping on Create should no nothing
      verifyNever(captor.call(
        any,
        matcher.TypeMatcher<CreateChannel>(),
        any,
      ) as dynamic);
    });

    testWidgets("create closed channel", (WidgetTester tester) async {
      final MockMiddleware captor = await _pumpCreateChannelScreen(tester);
      final topicName = "topic name";
      final purpose = "purpose";

      // Enter channel name and purpose
      await tester.enterText(find.byKey(Key("TopicName")), topicName);
      await tester.enterText(find.byKey(Key("Purpose")), purpose);

      //  Change Switch to Closed
      await tester.tap(find.byKey(Key("Visibility")));
      // Wait to load user list
      await tester.pumpAndSettle();
      // Select user with name "User2"
      await tester.tap(find.text("User2"));
      await tester.pumpAndSettle();

      // Create channel
      await tester.tap(find.byKey(Key("Create")));
      await tester.pumpAndSettle();

      final channel = Channel((c) => c
        ..name = topicName
        ..description = purpose
        ..type = ChannelType.TOPIC
        ..authorId = mockUser.uid
        ..visibility = ChannelVisibility.CLOSED);
      final createChannel = CreateChannel(
        channel,
        BuiltList<String>(["userId2"]),
        null,
      );
      verify(captor.call(
        any,
        createChannel,
        any,
      ) as dynamic);
    });
  });
}

Future<MockMiddleware> _pumpCreateChannelScreen(WidgetTester tester) async {
  final captor = MockMiddleware();
  Store<AppState> store;
  store = Store<AppState>(
    appReducer,
    initialState: AppState.init().rebuild((a) => a
      ..user = mockUser.toBuilder()
      ..groupUsers.addAll([
        mockUser,
        mockUser.rebuild((u) => u
          ..uid = "userId2"
          ..name = "User2")
      ])),
    middleware: [captor],
  );
  await tester.pumpWidget(StoreProvider(
    store: store,
    child: MaterialApp(
      localizationsDelegates: localizationsDelegates,
      home: CreateChannelScreen(),
    ),
  ));
  return captor;
}
