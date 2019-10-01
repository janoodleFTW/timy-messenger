import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'calendar_entry.g.dart';

abstract class CalendarEntry implements Built<CalendarEntry, CalendarEntryBuilder> {
  String get channelId;
  
  String get channelName;

  String get groupId;

  String get groupName;

  DateTime get eventDate;

  bool get hasStartTime;

  CalendarEntry._();

  factory CalendarEntry([void Function(CalendarEntryBuilder) updates]) = _$CalendarEntry;
}
