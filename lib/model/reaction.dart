
import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'reaction.g.dart';

abstract class Reaction implements Built<Reaction, ReactionBuilder> {

  String get emoji;

  String get userId;

  String get userName;

  DateTime get timestamp;

  Reaction._();
  factory Reaction([void Function(ReactionBuilder) updates]) = _$Reaction;
}