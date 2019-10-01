import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/util/date_formatting.dart";
import "package:flutter/cupertino.dart" as prefix0;
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'event_details_viewmodel.g.dart';

abstract class EventDetailsViewModel
    implements Built<EventDetailsViewModel, EventDetailsViewModelBuilder> {
  String get name;

  String get description;

  ChannelVisibility get visibility;

  BuiltList<User> get members;

  BuiltMap<String, RSVP> get rsvpStatus;

  int get guestCount;

  String get groupId;

  Channel get channel;

  String get eventDate;

  String get eventTime;

  String get venue;

  User get user;

  RSVP get userRsvp;

  bool get editable;

  bool get canChangeRsvp;

  EventDetailsViewModel._();

  factory EventDetailsViewModel(
          [void Function(EventDetailsViewModelBuilder) updates]) =
      _$EventDetailsViewModel;

  static EventDetailsViewModel fromStore(context, Store<AppState> store) {
    final channel = getSelectedChannel(store.state);
    final members = store.state.groupUsers
        .where((user) => channel.users.any((u) => u.id == user.uid))
        .toList();

    final String dateString = _parseDate(context, channel);
    final String timeString = _parseTime(context, channel);
    final rsvpStatus =
        channel.users.asMap().map((k, v) => MapEntry(v.id, v.rsvp));

    members.sort((u1, u2) => _sortRsvpAndHost(rsvpStatus, u1, u2, channel.authorId));

    return EventDetailsViewModel((t) => t
      ..name = channel.name
      ..visibility = channel.visibility
      ..description = channel.description
      ..members.addAll(members)
      ..guestCount = rsvpStatus.values
          .where((v) => v == RSVP.YES || v == RSVP.MAYBE)
          .length
      ..rsvpStatus.addAll(rsvpStatus)
      ..groupId = store.state.selectedGroupId
      ..channel = channel.toBuilder()
      ..user = store.state.user.toBuilder()
      ..userRsvp = rsvpStatus[store.state.user.uid] ?? RSVP.UNSET
      ..editable = _isEditable(channel, store)
      ..eventDate = dateString
      ..eventTime = timeString
      ..canChangeRsvp = channel.startDate.isAfter(DateTime.now())
      ..venue = channel.venue ?? "");
  }

  // Allow to edit if:
  // 1. the current user is the author of the event
  // 2. the start date is after now (so, it did not pass)
  static bool _isEditable(Channel channel, Store<AppState> store) {
    return channel.authorId == store.state.user.uid && channel.startDate.isAfter(DateTime.now());
  }

  static int _sortRsvpAndHost(Map<String, RSVP> rsvpStatus, User u1, User u2, String authorId) {
    
    // Helper to calculate a sorting score, smaller goes first
    int _rsvpVal(RSVP rsvp) {
      switch (rsvp) {
        case RSVP.YES:
          return 0;
        case RSVP.MAYBE:
          return 1;
        case RSVP.NO:
        case RSVP.UNSET:
        default:
          return 2;
      }
    }

    final rsvp1 = rsvpStatus[u1.uid];
    final rsvp2 = rsvpStatus[u2.uid];
    final u1Host = u1.uid == authorId;
    final u2Host = u2.uid == authorId;
    final val1 = u1Host ? -1 : _rsvpVal(rsvp1);
    final val2 = u2Host ? -1 : _rsvpVal(rsvp2);
    final diff = val1 - val2;
    if (diff == 0) {
      // Order by name if RSVP is same
      return u1.name.compareTo(u2.name);
    } else {
      return diff;
    }
  }

  static String _parseDate(context, Channel channel) {
    if (channel.startDate == null) {
      return "";
    }
    return formatDate(context, channel.startDate);
  }

  static String _parseTime(prefix0.BuildContext context, Channel channel) {
    if (channel.hasStartTime != null && !channel.hasStartTime) {
      return "";
    }
    return formatTime(context, channel.startDate);
  }
}
