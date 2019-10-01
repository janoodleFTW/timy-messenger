import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/model/channel.dart";

// ignore: prefer_double_quotes
part 'group.g.dart';

abstract class Group implements Built<Group, GroupBuilder> {
  String get id;

  String get name;

  String get hexColor;

  @nullable
  String get image;

  String get abbreviation;

  BuiltMap<String, Channel> get channels;

  Group._();

  factory Group([void Function(GroupBuilder) updates]) = _$Group;
}
