import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  String get uid;

  String get email;

  String get name;

  @nullable
  String get status;

  // Keeps groupId : [channelId], marking the unread channels.
  @nullable
  BuiltMap<String, BuiltList> get unreadUpdates;

  @nullable
  String get image;

  User._();

  factory User([void Function(UserBuilder) updates]) = _$User;
}

class UserHelper {
  static List<String> userIds(List<dynamic> userIds) {
    if (userIds == null) return [];
    return userIds.whereType<String>().toList();
  }
}
