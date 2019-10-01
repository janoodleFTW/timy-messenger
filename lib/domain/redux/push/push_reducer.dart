import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/push/push_actions.dart";
import "package:redux/redux.dart";

final pushReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, UpdateUserTokenAction>(_updateUserAction),
  TypedReducer<AppState, ShowPushNotificationAction>(
      _showPushNotificationAction),
  TypedReducer<AppState, OnPushNotificationDismissedAction>(
      _onPushNotificationDismissed),
];

AppState _updateUserAction(AppState state, UpdateUserTokenAction action) {
  return state.rebuild((s) => s..fcmToken = action.token);
}

AppState _showPushNotificationAction(
    AppState state, ShowPushNotificationAction action) {
  return state.rebuild(
      (s) => s..inAppNotification = action.inAppNotification.toBuilder());
}

AppState _onPushNotificationDismissed(
  AppState state,
  OnPushNotificationDismissedAction action,
) {
  return state.rebuild((s) => s..inAppNotification = null);
}
