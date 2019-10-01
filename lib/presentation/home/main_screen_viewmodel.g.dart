// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_screen_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MainScreenViewModel extends MainScreenViewModel {
  @override
  final bool hasData;
  @override
  final ChannelType channelType;

  factory _$MainScreenViewModel(
          [void Function(MainScreenViewModelBuilder) updates]) =>
      (new MainScreenViewModelBuilder()..update(updates)).build();

  _$MainScreenViewModel._({this.hasData, this.channelType}) : super._() {
    if (hasData == null) {
      throw new BuiltValueNullFieldError('MainScreenViewModel', 'hasData');
    }
  }

  @override
  MainScreenViewModel rebuild(
          void Function(MainScreenViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MainScreenViewModelBuilder toBuilder() =>
      new MainScreenViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MainScreenViewModel &&
        hasData == other.hasData &&
        channelType == other.channelType;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, hasData.hashCode), channelType.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MainScreenViewModel')
          ..add('hasData', hasData)
          ..add('channelType', channelType))
        .toString();
  }
}

class MainScreenViewModelBuilder
    implements Builder<MainScreenViewModel, MainScreenViewModelBuilder> {
  _$MainScreenViewModel _$v;

  bool _hasData;
  bool get hasData => _$this._hasData;
  set hasData(bool hasData) => _$this._hasData = hasData;

  ChannelType _channelType;
  ChannelType get channelType => _$this._channelType;
  set channelType(ChannelType channelType) => _$this._channelType = channelType;

  MainScreenViewModelBuilder();

  MainScreenViewModelBuilder get _$this {
    if (_$v != null) {
      _hasData = _$v.hasData;
      _channelType = _$v.channelType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MainScreenViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MainScreenViewModel;
  }

  @override
  void update(void Function(MainScreenViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MainScreenViewModel build() {
    final _$result = _$v ??
        new _$MainScreenViewModel._(hasData: hasData, channelType: channelType);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
