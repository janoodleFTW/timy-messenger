// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_input_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChatInputViewModel extends ChatInputViewModel {
  @override
  final String inputDraft;

  factory _$ChatInputViewModel(
          [void Function(ChatInputViewModelBuilder) updates]) =>
      (new ChatInputViewModelBuilder()..update(updates)).build();

  _$ChatInputViewModel._({this.inputDraft}) : super._();

  @override
  ChatInputViewModel rebuild(
          void Function(ChatInputViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatInputViewModelBuilder toBuilder() =>
      new ChatInputViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatInputViewModel && inputDraft == other.inputDraft;
  }

  @override
  int get hashCode {
    return $jf($jc(0, inputDraft.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ChatInputViewModel')
          ..add('inputDraft', inputDraft))
        .toString();
  }
}

class ChatInputViewModelBuilder
    implements Builder<ChatInputViewModel, ChatInputViewModelBuilder> {
  _$ChatInputViewModel _$v;

  String _inputDraft;
  String get inputDraft => _$this._inputDraft;
  set inputDraft(String inputDraft) => _$this._inputDraft = inputDraft;

  ChatInputViewModelBuilder();

  ChatInputViewModelBuilder get _$this {
    if (_$v != null) {
      _inputDraft = _$v.inputDraft;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatInputViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ChatInputViewModel;
  }

  @override
  void update(void Function(ChatInputViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ChatInputViewModel build() {
    final _$result = _$v ?? new _$ChatInputViewModel._(inputDraft: inputDraft);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
