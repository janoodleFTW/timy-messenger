import "package:built_collection/built_collection.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel_state.dart";
import "package:circles_app/domain/redux/push/push_actions.dart";
import "package:circles_app/domain/redux/push/push_middleware.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/model/in_app_notification.dart";
import "package:flutter/foundation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart";
import "package:mockito/mockito.dart";
import "package:redux/redux.dart";

import "../redux_mocks.dart";

main() {
  group("Push Middleware", () {
    final userRepo = MockUserRepository();
    final firebaseMessaging = MockFirebaseMessaging();
    final groupRepo = MockGroupRepository();
    final channelRepo = MockChannelsRepository();
    final captor = MockMiddleware();
    final store = Store<AppState>(
      appReducer,
      initialState: AppState.init().rebuild((a) => a
        ..user.update((u) => u
          ..uid = "USERID"
          ..email = "EMAIL"
          ..name = "NAME")),
      middleware: createPushMiddleware(
        userRepo,
        firebaseMessaging,
        groupRepo,
        channelRepo,
      )..add(captor),
    );
    final group = Group((c) => c
      ..id = "groupId"
      ..name = "CIRCLE"
      ..hexColor = "FFFFFF"
      ..abbreviation = "CI");
    final channel = Channel((c) => c
      ..type = ChannelType.TOPIC
      ..visibility = ChannelVisibility.OPEN
      ..id = "CHANNELID"
      ..users = ListBuilder([])
      ..name = "CHANNEL");

    test("should ignore empty payload", () {
      final Map<String, dynamic> payload = {};
      store.dispatch(OnPushNotificationReceivedAction(payload));

      verifyNever(
        captor.call(
          any,
          TypeMatcher<ShowPushNotificationAction>(),
          any,
        ) as dynamic,
      );
    });

    test("should ignore missing important data", () {
      final Map<String, dynamic> payload = {"notification": {}, "data": {}};
      store.dispatch(OnPushNotificationReceivedAction(payload));

      verifyNever(
        captor.call(
          any,
          TypeMatcher<ShowPushNotificationAction>(),
          any,
        ) as dynamic,
      );
    });

    test("should ignore non message notifications", () {
      final Map<String, dynamic> payload = {
        "notification": {},
        "data": {
          "groupId": "groupId",
          "channelId": "CHANNELID",
          "type": "reaction",
        }
      };
      store.dispatch(OnPushNotificationReceivedAction(payload));

      verifyNever(
        captor.call(
          any,
          TypeMatcher<ShowPushNotificationAction>(),
          any,
        ) as dynamic,
      );
    });

    test("should ignore notification when user is in same channel", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init().rebuild((a) {
          return a
            ..selectedGroupId = "groupId"
            ..channelState = ChannelState.init()
                .rebuild((cs) => cs..selectedChannel = channel.id)
                .toBuilder();
        }),
        middleware: createPushMiddleware(
          userRepo,
          firebaseMessaging,
          groupRepo,
          channelRepo,
        )..add(captor),
      );

      final Map<String, dynamic> payload = {
        "notification": {
          "body": "Hello",
        },
        "data": {
          "groupId": "groupId",
          "channelId": "CHANNELID",
          "type": "message",
          "username": "USER",
        }
      };
      store.dispatch(OnPushNotificationReceivedAction(payload));

      verifyNever(
        captor.call(
          any,
          TypeMatcher<ShowPushNotificationAction>(),
          any,
        ) as dynamic,
      );
    });

    test("should process message notification", () {
      when(channelRepo.getChannel("groupId", "CHANNELID", "USERID"))
          .thenAnswer((_) => SynchronousFuture(channel));
      when(groupRepo.getGroup("groupId"))
          .thenAnswer((_) => SynchronousFuture(group));

      final Map<String, dynamic> payload = {
        "notification": {
          "body": "Hello",
        },
        "data": {
          "groupId": "groupId",
          "channelId": "CHANNELID",
          "type": "message",
          "username": "USER",
        }
      };
      store.dispatch(OnPushNotificationReceivedAction(payload));

      final notification = InAppNotification((i) => i
        ..groupId = "groupId"
        ..channel = channel.toBuilder()
        ..groupName = "CIRCLE"
        ..userName = "USER"
        ..message = "Hello");

      verify(
        captor.call(
          any,
          ShowPushNotificationAction(notification),
          any,
        ) as dynamic,
      );
    });

    test("should select circle on open notification", () {
      when(channelRepo.getChannel("CIRCLE-2-ID", "CHANNELID", "USERID"))
          .thenAnswer((_) => SynchronousFuture(channel));

      final Map<String, dynamic> payload = {
        "notification": {
          "body": "Hello",
        },
        "data": {
          "groupId": "CIRCLE-2-ID",
          "channelId": "CHANNELID",
          "type": "message",
          "username": "USER",
        }
      };

      store.dispatch(OnPushNotificationOpenAction(payload));
      verify(
        captor.call(
          any,
          TypeMatcher<SelectGroup>(),
          any,
        ) as dynamic,
      );
      verify(
        captor.call(
          any,
          TypeMatcher<SelectChannel>(),
          any,
        ) as dynamic,
      );
    });
  });
}
