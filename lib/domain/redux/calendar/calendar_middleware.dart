import "package:circles_app/data/calendar_repository.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/calendar/calendar_actions.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:redux/redux.dart";

List<Middleware<AppState>> createCalendarMiddleware(
  CalendarRepository calendarRepository,
) {
  return [
    TypedMiddleware<AppState, OnChannelsLoaded>(_loadCalendar(
      calendarRepository,
    )),
  ];
}

/// Load calendarEntries when channel list updates
void Function(
  Store<AppState> store,
  OnChannelsLoaded action,
  NextDispatcher next,
) _loadCalendar(
  CalendarRepository calendarRepository,
) {
  return (store, action, next) async {
    next(action);
    
    final calendarEntries =
        await calendarRepository.getCalendarEntries(store.state.user.uid);
    
    store.dispatch(
      CalendarUpdatedAction(calendarEntries: calendarEntries),
    );
  };
}
