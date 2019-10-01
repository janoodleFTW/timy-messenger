import "dart:io";

import "package:circles_app/data/channel_repository.dart";
import "package:circles_app/data/group_repository.dart";
import "package:circles_app/data/user_repository.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/domain/redux/push/push_actions.dart";
import "package:circles_app/model/in_app_notification.dart";
import "package:circles_app/util/logger.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:redux/redux.dart";

List<Middleware<AppState>> createPushMiddleware(
  UserRepository userRespository,
  FirebaseMessaging firebaseMessaging,
  GroupRepository groupRepository,
  ChannelRepository channelRepository,
) {
  return [
    TypedMiddleware<AppState, UpdateUserTokenAction>(
        _updateUserAction(userRespository)),
    TypedMiddleware<AppState, OnAuthenticated>(
        _setTokenAfterLogin(userRespository)),
    TypedMiddleware<AppState, OnPushNotificationOpenAction>(
        _onPushNotificationOpen(groupRepository, channelRepository)),
    TypedMiddleware<AppState, OnPushNotificationReceivedAction>(
        _onPushNotificationReceived(
      groupRepository,
      channelRepository,
    )),
  ];
}

void Function(
  Store<AppState> store,
  UpdateUserTokenAction action,
  NextDispatcher next,
) _updateUserAction(UserRepository userRepository) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.updateUserToken(action.token);
    } catch (e) {
      Logger.e("Failed to update token", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  OnAuthenticated action,
  NextDispatcher next,
) _setTokenAfterLogin(UserRepository userRepository) {
  return (store, action, next) async {
    next(action);
    try {
      /// Set the token after the user is authenticated if the token exists
      if (store.state.fcmToken != null) {
        await userRepository.updateUserToken(store.state.fcmToken);
      }
    } catch (e) {
      Logger.e("Failed to update token", e: e, s: StackTrace.current);
    }
  };
}

void Function(Store<AppState> store, OnPushNotificationOpenAction action,
        NextDispatcher next)
    _onPushNotificationOpen(
        GroupRepository groupRepository, ChannelRepository channelRepository) {
  return (store, action, next) async {
    next(action);
    try {
      final message = _verifyedMessage(action.message, store);
      if (message == null) {
        return;
      }
      final data = message["data"];
      final groupId = data["groupId"];
      final channelId = data["channelId"];
      final previousChannelId = store.state.channelState.selectedChannel;
      final channel = await channelRepository.getChannel(
        groupId,
        channelId,
        store.state.user.uid,
      );

      store.dispatch(SelectGroup(groupId));
      store.dispatch(SelectChannel(
        previousChannelId: previousChannelId,
        channel: channel,
        groupId: data["groupId"],
        userId: store.state.user.uid,
      ));
    } catch (e) {
      Logger.e("Failed to open push notification", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  OnPushNotificationReceivedAction action,
  NextDispatcher next,
) _onPushNotificationReceived(
  GroupRepository groupRepository,
  ChannelRepository channelRepository,
) {
  return (store, action, next) async {
    next(action);

    try {
      final message = _verifyedMessage(action.message, store);
      if (message == null) {
        return;
      }

      final notification = message["notification"];
      final data = message["data"];
      final groupId = data["groupId"];
      final channelId = data["channelId"];
      final group = await groupRepository.getGroup(groupId);
      final channel = await channelRepository.getChannel(
        groupId,
        channelId,
        store.state.user.uid,
      );
      final userName = data["username"];

      final inAppNotification = InAppNotification((n) =>
      n
        ..groupId = groupId
        ..channel = channel.toBuilder()
        ..groupName = group.name
        ..message = notification["body"]
        ..userName = userName);

      store.dispatch(ShowPushNotificationAction(inAppNotification));
    } catch (e) {
      Logger.e("Failed to display push notification", e: e, s: StackTrace.current);
    }
  };
}

Map<String, dynamic> _verifyedMessage(
    Map<String, dynamic> message, Store<AppState> store) {
  var notification = message["notification"];
  var data = message["data"];

  // Necessary because the payload format is different per platform
  // See: https://github.com/flutter/flutter/issues/29027
  if (Platform.isIOS) {
    data = message;
    final aps = (data != null) ? data["aps"] : null;
    notification = (aps != null) ? aps["alert"] : null;
  }

  final results = {"data": data, "notification": notification};

  if (notification == null || data == null) {
    Logger.d("Empty message payload");
    return null;
  }

  final groupId = data["groupId"];
  final channelId = data["channelId"];

  if (groupId == null || channelId == null) {
    Logger.d("Missing properties channelId and groupId");
    return null;
  }

  final messageType = data["type"];

  if (messageType != "message") {
    Logger.d("No action required for type: $messageType");
    return null;
  }

  if (store.state.selectedGroupId == groupId &&
      store.state.channelState.selectedChannel == channelId) {
    Logger.d("User is already in the channel: $channelId");
    return null;
  }

  return results;
}
