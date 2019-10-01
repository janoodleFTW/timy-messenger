import "package:circles_app/data/user_repository.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/domain/redux/stream_subscriptions.dart";
import "package:circles_app/domain/redux/user/user_actions.dart";
import "package:circles_app/util/logger.dart";
import "package:redux/redux.dart";


List<Middleware<AppState>> createUserMiddleware(
  UserRepository userRepository,
) {
  return [
    TypedMiddleware<AppState, OnAuthenticated>(_listenToUser(userRepository)),
    TypedMiddleware<AppState, SelectGroup>(_listenToUsers(userRepository)),
    TypedMiddleware<AppState, UpdateUserLocaleAction>(
        _updateUserLocale(userRepository)),
    TypedMiddleware<AppState, UpdateUserAction>(_updateUser(userRepository)),
  ];
}

// Updates locale for logged in user.
void Function(
  Store<AppState> store,
  UpdateUserLocaleAction action,
  NextDispatcher next,
) _updateUserLocale(
  UserRepository userRepository,
) {
  return (store, action, next) async {
    next(action);

    try {
      // Updates user locale after login.
      await userRepository.updateUserLocale(action.locale);
    } catch (e) {
      Logger.e("Failed to update locale", e: e, s: StackTrace.current);
    }
  };
}

// Receives updates for the logged in user.
void Function(
  Store<AppState> store,
  OnAuthenticated action,
  NextDispatcher next,
) _listenToUser(
  UserRepository userRepository,
) {
  return (store, action, next) {
    next(action);
    try {
      userUpdateSubscription?.cancel();
      userUpdateSubscription =
          userRepository.getUserStream(action.user.uid).listen((user) {
        store.dispatch(OnUserUpdateAction(user));
      });
    } catch (e) {
      Logger.e("Failed to listen user", e: e, s: StackTrace.current);
    }
  };
}

// This listener will only fire when relevant (= matching groupId) updates are performed
// on the `joinedGroups` for a user. Note
// - we store members for a group
// - we also store joinedGroup membership for a user
void Function(
  Store<AppState> store,
  SelectGroup action,
  NextDispatcher next,
) _listenToUsers(
  UserRepository userRepository,
) {
  return (store, action, next) {
    next(action);
    try {
      groupUsersSubscription?.cancel();
      groupUsersSubscription =
          userRepository.getUsersStream(action.groupId).listen((users) {
        store.dispatch(UsersUpdateAction(users));
      });
    } catch (e) {
      Logger.e("Failed to listen to users", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  UpdateUserAction action,
  NextDispatcher next,
) _updateUser(
  UserRepository userRepository,
) {
  return (store, action, next) async {
    next(action);
    if (store.state.user.uid != action.user.uid) {
      action.completer
          .completeError(Exception("You can't update other users!"));
      return;
    }
    try {
      await userRepository.updateUser(action.user);
      store.dispatch(OnUserUpdateAction(action.user));
      action.completer.complete(action.user);
    } catch (error) {
      Logger.e("Failed to update user", e: error, s: StackTrace.current);
      action.completer.completeError(error);
    }
  };
}
