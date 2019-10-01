import "package:built_value/built_value.dart";
import "package:circles_app/model/channel.dart";

// ignore: prefer_double_quotes
part 'in_app_notification.g.dart';

abstract class InAppNotification implements Built<InAppNotification, InAppNotificationBuilder> {

  String get groupId;

  String get groupName;

  String get userName;

  String get message;

  Channel get channel;

  InAppNotification._();
  factory InAppNotification([void Function(InAppNotificationBuilder) updates]) = _$InAppNotification;
}