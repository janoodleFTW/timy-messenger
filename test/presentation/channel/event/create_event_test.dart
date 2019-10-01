import "package:built_collection/built_collection.dart";
import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/presentation/channel/event/create_event.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart" as matcher;
import "package:mockito/mockito.dart";
import "package:redux/redux.dart";

import "../../../data/data_mocks.dart";
import "../../../domain/redux_mocks.dart";

void main() {
  group("CreateEventScreen tests", () {
    testsLogger();

    testWidgets("create open event", (WidgetTester tester) async {
      final MockMiddleware captor = await _pumpCreateEventScreen(tester);
      final topicName = "topic name";
      final purpose = "purpose";

      await _fillCommonValues(tester, topicName, purpose);

      // Tap on create channel button
      await tester.tap(find.byKey(Key("Create")));
      await tester.pumpAndSettle();

      final now = DateTime.now();
      final channel = Channel((c) => c
        ..name = topicName
        ..description = purpose
        ..type = ChannelType.EVENT
        ..authorId = mockUser.uid
        ..venue = ""
        ..startDate = DateTime(now.year, now.month, now.day, 23, 59)
        ..hasStartTime = false
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
      final MockMiddleware captor = await _pumpCreateEventScreen(tester);

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

    testWidgets("create closed event", (WidgetTester tester) async {
      final MockMiddleware captor = await _pumpCreateEventScreen(tester);
      final topicName = "topic name";
      final purpose = "purpose";

      await _fillCommonValues(tester, topicName, purpose);

      // Change Switch to Closed
      await tester.tap(find.byKey(Key("Visibility")));
      // to load user list
      await tester.pumpAndSettle();

      // TODO: There seems to be a bug in this tap action, skipping test
      // Select user with name "User2"
      await tester.tap(find.byKey(Key("userId2.InkWell")));
      await tester.pumpAndSettle();

      // Create channel
      await tester.tap(find.byKey(Key("Create")));
      await tester.pumpAndSettle();

      final now = DateTime.now();
      final channel = Channel((c) => c
        ..name = topicName
        ..description = purpose
        ..type = ChannelType.EVENT
        ..authorId = mockUser.uid
        ..venue = ""
        ..startDate = DateTime(now.year, now.month, now.day, 23, 59)
        ..hasStartTime = false
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
    }, skip: true);
  });

  // REF: https://github.com/janoodleFTW/flutter-app/issues/275
  testWidgets("allow change dates multiple times", (WidgetTester tester) async {
    await _pumpCreateEventScreen(tester);
    final topicName = "topic name";
    final purpose = "purpose";

    await _fillCommonValues(tester, topicName, purpose);

    // Pick a date
    // Simply select today (selected by default)
    await tester.tap(find.byKey(Key("EventDate")));
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();
  });
}

Future _fillCommonValues(
    WidgetTester tester, String topicName, String purpose) async {
  // Enter channel name and purpose
  await tester.enterText(find.byKey(Key("TopicName")), topicName);
  await tester.enterText(find.byKey(Key("Purpose")), purpose);

  // Pick a date
  // Simply select today (selected by default)
  await tester.tap(find.byKey(Key("EventDate")));
  await tester.pumpAndSettle();
  await tester.tap(find.text("OK"));
  await tester.pumpAndSettle();
}

Future<MockMiddleware> _pumpCreateEventScreen(WidgetTester tester) async {
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
      home: CreateEventScreen(),
    ),
  ));
  return captor;
}
