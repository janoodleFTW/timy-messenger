import "package:built_collection/built_collection.dart";
import "package:circles_app/model/reaction.dart";
import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'message.g.dart';

abstract class Message implements Built<Message, MessageBuilder> {
  @nullable
  String get id;

  @nullable
  String get authorId;

  String get body;

  BuiltMap<String, Reaction> get reactions;

  MessageType get messageType;

  bool get pending;

  DateTime get timestamp;

  BuiltList<String> get media;

  @nullable
  MediaStatus get mediaStatus;

  @nullable
  double get mediaAspectRatio;

  Message._();

  factory Message([void Function(MessageBuilder) updates]) = _$Message;

  Map<String, int> reactionsCount() {
    if (reactions == null) {
      return {};
    }
    final map = Map<String, int>();
    for (final reaction in reactions.values) {
      map[reaction.emoji] = (map[reaction.emoji] ?? 0) + 1;
    }
    return map;
  }
}

/// Custom Builder to allow defaults
abstract class MessageBuilder implements Builder<Message, MessageBuilder> {

  @nullable
  String id;

  @nullable
  String authorId;

  String body;

  MapBuilder<String, Reaction> reactions;

  MessageType messageType = MessageType.USER;

  bool pending = false;

  ListBuilder<String> media;

  MediaStatus mediaStatus = MediaStatus.ERROR;

  double mediaAspectRatio = 1.0;

  DateTime timestamp = DateTime.now();

  factory MessageBuilder() = _$MessageBuilder;
  MessageBuilder._();
}

enum MessageType { SYSTEM, RSVP, USER, MEDIA }

class MessageTypeHelper {
  static String stringOf(MessageType messageType) {
    switch (messageType) {
      case MessageType.SYSTEM:
        return "SYSTEM";
      case MessageType.RSVP:
        return "RSVP";
      case MessageType.MEDIA:
        return "MEDIA";
      default:
        return "USER";
    }
  }

  static MessageType valueOf(String string) {
    switch (string) {
      case "SYSTEM":
        return MessageType.SYSTEM;
      case "RSVP":
        return MessageType.RSVP;
      case "MEDIA":
        return MessageType.MEDIA;
      default:
        return MessageType.USER;
    }
  }
}

enum MediaStatus { UPLOADING, DONE, ERROR }

class MediaStatusHelper {
  static String stringOf(MediaStatus mediaStatus) {
    switch (mediaStatus) {
      case MediaStatus.UPLOADING:
        return "UPLOADING";
        break;
      case MediaStatus.DONE:
        return "DONE";
        break;
      case MediaStatus.ERROR:
      default:
        return "ERROR";
        break;
    }
  }

  static MediaStatus valueOf(String string) {
    switch (string) {
      case "UPLOADING":
        return MediaStatus.UPLOADING;
      case "DONE":
        return MediaStatus.DONE;
      case "ERROR":
      default:
        return MediaStatus.ERROR;
    }
  }
}
