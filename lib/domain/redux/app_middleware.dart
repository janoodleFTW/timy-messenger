import "package:circles_app/data/group_repository.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/domain/redux/stream_subscriptions.dart";
import "package:circles_app/util/logger.dart";
import "package:redux/redux.dart";

/// Middleware is used for a variety of things.
/// Including:
/// - Logging
/// - Async calls (database, network)
/// - Calling to system frameworks
///
/// These are performed when actions are dispatched to the Store
///
/// The output of an action can perform another action using the [NextDispatcher]
///
List<Middleware<AppState>> createStoreMiddleware(
  GroupRepository groupRepository,
) {
  return [
    LoggerMiddleware(),
    TypedMiddleware<AppState, SelectGroup>(_selectGroup()),
    TypedMiddleware<AppState, ConnectToDataSource>(_loadData(groupRepository)),
  ];
}

void Function(Store<AppState> store, SelectGroup action, NextDispatcher next)
    _selectGroup() {
  return (store, action, next) {
    next(action);

    // We're no longer loading all channels of all groups initially
    // (but just for the group selected).
    //
    // This saves us data on one hand and reduces side effects.
    //
    // Bringing it back will require more attention in terms of subscribing
    // to the proper channel updates.
    //
    // Currently a LoadChannel also causes a necessary subscription to channel
    // updates in the channel middleware.
    store.dispatch(LoadChannels(
      action.groupId,
    ));
  };
}

void Function(
  Store<AppState> store,
  ConnectToDataSource action,
  NextDispatcher next,
) _loadData(
  GroupRepository groupRepository,
) {
  return (store, action, next) {
    next(action);

    try {
      groupsSubscription?.cancel();
      groupsSubscription =
          groupRepository.getGroupStream(store.state.user.uid).listen((group) {
        store.dispatch(OnGroupsLoaded(group));

        if (store.state.selectedGroupId == null && group.isNotEmpty) {
          store.dispatch(SelectGroup(group.first.id));
        }
      });
    } catch (e) {
      Logger.e("Failed to subscribe to groups", e: e, s: StackTrace.current);
    }
  };
}
