import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/push/push_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/in_app_notification.dart";
import "package:flutter_test/flutter_test.dart";
import "package:redux/redux.dart";

main() {
  group("Push Reducer", () {
    final notification = InAppNotification((i) => i
      ..message = "HELLO"
      ..userName = "USERNAME"
      ..groupName = "CIRCLENAME"
      ..groupId = "GROUPID"
      ..channel.update((c) => c
        ..type = ChannelType.TOPIC
        ..name = "CHANNEL NAME"
        ..visibility = ChannelVisibility.OPEN));

    test("should update AppState with push notification", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );
      expect(store.state.inAppNotification, null);
      store.dispatch(ShowPushNotificationAction(notification));
      expect(store.state.inAppNotification, notification);
    });

    test("should update AppState when push notification dismissed", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init()
            .rebuild((a) => a..inAppNotification = notification.toBuilder()),
      );
      expect(store.state.inAppNotification, notification);
      store.dispatch(OnPushNotificationDismissedAction());
      expect(store.state.inAppNotification, null);
    });
  });
}
