import "package:circles_app/data/user_repository.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/domain/redux/stream_subscriptions.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:redux/redux.dart";
import "package:flutter/services.dart";

/// Authentication Middleware
/// LogIn: Logging user in
/// LogOut: Logging user out
/// VerifyAuthenticationState: Verify if user is logged in

List<Middleware<AppState>> createAuthenticationMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    TypedMiddleware<AppState, VerifyAuthenticationState>(
        _verifyAuthState(userRepository, navigatorKey)),
    TypedMiddleware<AppState, LogIn>(_authLogin(userRepository, navigatorKey)),
    TypedMiddleware<AppState, LogOutAction>(
        _authLogout(userRepository, navigatorKey)),
  ];
}

void Function(
  Store<AppState> store,
  VerifyAuthenticationState action,
  NextDispatcher next,
) _verifyAuthState(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) {
    next(action);

    userRepository.getAuthenticationStateChange().listen((user) {
      if (user == null) {
        navigatorKey.currentState.pushReplacementNamed(Routes.login);
      } else {
        store.dispatch(OnAuthenticated(user: user));
        store.dispatch(ConnectToDataSource());
      }
    });
  };
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) _authLogout(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.logOut();
      cancelAllSubscriptions();
      store.dispatch(OnLogoutSuccess());
    } catch (e) {
      Logger.w("Failed logout", e: e);
      store.dispatch(OnLogoutFail(e));
    }
  };
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) _authLogin(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) async {
    next(action);
    try {
      final user = await userRepository.signIn(action.email, action.password);
      store.dispatch(OnAuthenticated(user: user));

      await navigatorKey.currentState.pushReplacementNamed(Routes.home);
      action.completer.complete();
    } on PlatformException catch (e) {
      Logger.w("Failed login", e: e);
      action.completer.completeError(e);
    }
  };
}
