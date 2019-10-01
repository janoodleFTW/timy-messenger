import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/ui/ui_state_selector.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'chat_input_viewmodel.g.dart';

abstract class ChatInputViewModel
    implements Built<ChatInputViewModel, ChatInputViewModelBuilder> {

  @nullable
  String get inputDraft;

  ChatInputViewModel._();

  factory ChatInputViewModel(
          [void Function(ChatInputViewModelBuilder) updates]) =
      _$ChatInputViewModel;

  static ChatInputViewModel fromStore(Store<AppState> store) {
    return ChatInputViewModel((v) => v
      ..inputDraft = getInputDraftSelectedChannel(store.state));
  }
}
