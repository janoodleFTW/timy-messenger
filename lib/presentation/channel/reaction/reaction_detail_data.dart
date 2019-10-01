import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'reaction_detail_data.g.dart';

abstract class ReactionDetailData
    implements Built<ReactionDetailData, ReactionDetailDataBuilder> {
  String get emoji;

  String get names;

  ReactionDetailData._();

  factory ReactionDetailData(
          [void Function(ReactionDetailDataBuilder) updates]) =
      _$ReactionDetailData;
}
