import "package:built_collection/built_collection.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/calendar/calendar_actions.dart";
import "package:redux/redux.dart";

final calendarReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, CalendarUpdatedAction>(_onCalendarUpdate),
];

AppState _onCalendarUpdate(AppState state, CalendarUpdatedAction action) {
  return state.rebuild((appState) =>
      appState..userCalendar = ListBuilder(action.calendarEntries));
}
