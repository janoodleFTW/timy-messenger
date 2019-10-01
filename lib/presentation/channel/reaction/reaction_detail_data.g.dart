// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_detail_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ReactionDetailData extends ReactionDetailData {
  @override
  final String emoji;
  @override
  final String names;

  factory _$ReactionDetailData(
          [void Function(ReactionDetailDataBuilder) updates]) =>
      (new ReactionDetailDataBuilder()..update(updates)).build();

  _$ReactionDetailData._({this.emoji, this.names}) : super._() {
    if (emoji == null) {
      throw new BuiltValueNullFieldError('ReactionDetailData', 'emoji');
    }
    if (names == null) {
      throw new BuiltValueNullFieldError('ReactionDetailData', 'names');
    }
  }

  @override
  ReactionDetailData rebuild(
          void Function(ReactionDetailDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReactionDetailDataBuilder toBuilder() =>
      new ReactionDetailDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReactionDetailData &&
        emoji == other.emoji &&
        names == other.names;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, emoji.hashCode), names.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ReactionDetailData')
          ..add('emoji', emoji)
          ..add('names', names))
        .toString();
  }
}

class ReactionDetailDataBuilder
    implements Builder<ReactionDetailData, ReactionDetailDataBuilder> {
  _$ReactionDetailData _$v;

  String _emoji;
  String get emoji => _$this._emoji;
  set emoji(String emoji) => _$this._emoji = emoji;

  String _names;
  String get names => _$this._names;
  set names(String names) => _$this._names = names;

  ReactionDetailDataBuilder();

  ReactionDetailDataBuilder get _$this {
    if (_$v != null) {
      _emoji = _$v.emoji;
      _names = _$v.names;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReactionDetailData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ReactionDetailData;
  }

  @override
  void update(void Function(ReactionDetailDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ReactionDetailData build() {
    final _$result =
        _$v ?? new _$ReactionDetailData._(emoji: emoji, names: names);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
