import "package:circles_app/model/calendar_entry.dart";
import "package:flutter/foundation.dart";

@immutable
class CalendarUpdatedAction {
  final List<CalendarEntry> calendarEntries;

  const CalendarUpdatedAction({this.calendarEntries});

  @override
  String toString() {
    return "CalendarUpdatedAction{calendarEntries: $calendarEntries}";
  }
}
