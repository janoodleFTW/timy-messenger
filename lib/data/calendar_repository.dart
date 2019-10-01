import "package:circles_app/data/firestore_paths.dart";
import "package:circles_app/model/calendar_entry.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class CalendarRepository {
  final Firestore _firestore;
  const CalendarRepository(this._firestore);

  Future<List<CalendarEntry>> getCalendarEntries(String userId) async {
    final snapshot = await _firestore
        .collection(FirestorePaths.PATH_CALENDAR)
        .where(_Constants.USERS, arrayContains: userId)
        .orderBy(_Constants.EVENTDATE, descending: false)
        .limit(100)
        .getDocuments();

    return snapshot.documents.map((d) => _fromDoc(d)).toList();
  }

  static CalendarEntry _fromDoc(DocumentSnapshot doc) {
    return CalendarEntry((calendarEntry) => calendarEntry
      ..channelId = doc[_Constants.CHANNELID]
      ..groupId = doc[_Constants.GROUPID]
      ..groupName = doc[_Constants.GROUPNAME]
      ..channelName = doc[_Constants.CHANNELNAME]
      ..eventDate = doc[_Constants.EVENTDATE].toDate()
      ..hasStartTime = doc[_Constants.HASSTARTTIME] != null
          ? doc[_Constants.HASSTARTTIME]
          : false);
  }
}

class _Constants {
  static const String CHANNELID = "channel_id";
  static const String GROUPID = "group_id";
  static const String GROUPNAME = "group_name";
  static const String CHANNELNAME = "channel_name";
  static const String EVENTDATE = "event_date";
  static const String HASSTARTTIME = "has_start_time";
  static const String USERS = "users";
}
