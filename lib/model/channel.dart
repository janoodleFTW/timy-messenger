import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'channel.g.dart';

abstract class Channel implements Built<Channel, ChannelBuilder> {
  @nullable
  String get id;

  String get name;

  @nullable
  String get description;

  ChannelVisibility get visibility;

  BuiltList<ChannelUser> get users;

  @nullable
  String get authorId;

  @nullable
  bool get hasUpdates;

  ChannelType get type;

  @nullable
  String get venue;

  @nullable
  DateTime get startDate;

  @nullable
  bool get hasStartTime;

  Channel._();

  factory Channel([void Function(ChannelBuilder) updates]) = _$Channel;
}

abstract class ChannelUser implements Built<ChannelUser, ChannelUserBuilder> {
  String get id;

  RSVP get rsvp;

  ChannelUser._();

  factory ChannelUser([void Function(ChannelUserBuilder) updates]) =
      _$ChannelUser;
}

enum RSVP { YES, MAYBE, NO, UNSET }

class RSVPHelper {
  static String stringOf(RSVP rsvp) {
    switch (rsvp) {
      case RSVP.YES:
        return "YES";
      case RSVP.MAYBE:
        return "MAYBE";
      case RSVP.NO:
        return "NO";
      case RSVP.UNSET:
      default:
        return "UNSET";
    }
  }

  static RSVP valueOf(String string) {
    switch (string) {
      case "YES":
        return RSVP.YES;
      case "MAYBE":
        return RSVP.MAYBE;
      case "NO":
        return RSVP.NO;
      case "UNSET":
      default:
        return RSVP.UNSET;
    }
  }
}

enum ChannelVisibility { OPEN, CLOSED }

class ChannelVisibilityHelper {
  static String stringOf(ChannelVisibility visibility) {
    switch (visibility) {
      case ChannelVisibility.OPEN:
        return "OPEN";
      case ChannelVisibility.CLOSED:
        return "CLOSED";
    }
    return null;
  }

  static ChannelVisibility valueOf(String string) {
    switch (string) {
      case "OPEN":
        return ChannelVisibility.OPEN;
      case "CLOSED":
        return ChannelVisibility.CLOSED;
    }
    return null;
  }
}

enum ChannelType { TOPIC, EVENT }

class ChannelTypeHelper {
  static String stringOf(ChannelType type) {
    switch (type) {
      case ChannelType.EVENT:
        return "EVENT";
      case ChannelType.TOPIC:
        return "TOPIC";
    }
    return null;
  }

  static ChannelType valueOf(String string) {
    switch (string) {
      case "EVENT":
        return ChannelType.EVENT;
      case "TOPIC":
        return ChannelType.TOPIC;
    }
    return null;
  }
}
