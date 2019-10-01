import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/ui/ui_actions.dart";
import "package:circles_app/presentation/channel/input/attach_button.dart";
import "package:circles_app/presentation/channel/input/chat_input_viewmodel.dart";
import "package:circles_app/presentation/channel/input/send_button.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class ChatInput extends StatefulWidget {
  const ChatInput({Key key}) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController _controller;
  bool _textInserted = false;
  String _channelId;
  String _groupId;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateInputTextChange);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -1.0),
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            StoreConnector<AppState, ChatInputViewModel>(
              distinct: true,
              onInit: (store) {
                // Keep channel and group id for later
                // so we can store the chat input draft
                _channelId = store.state.channelState.selectedChannel;
                _groupId = store.state.selectedGroupId;
              },
              onInitialBuild: (vm) {
                // Load previous draft
                _controller.text = vm.inputDraft;
              },
              onDispose: (store) {
                // Store the chat input draft just before disposing the chat
                // (so before changing channels)
                store.dispatch(UpdatedChatDraftAction(
                  groupId: _groupId,
                  channelId: _channelId,
                  text: _controller.text,
                ));
              },
              builder: (BuildContext context, ChatInputViewModel vm) {
                return ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 44.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      AttachButton(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                          child: TextField(
                            maxLines: 6,
                            minLines: 1,
                            controller: _controller,
                            style: AppTheme.inputTextStyle,
                            cursorColor: AppTheme.colorTextEnabled,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: CirclesLocalizations.of(context)
                                  .channelInputHint,
                              hintStyle: AppTheme.inputHintTextStyle,
                            ),
                          ),
                        ),
                      ),
                      SendButton(
                        controller: _controller,
                        enabled: _textInserted,
                      ),
                    ],
                  ),
                );
              },
              converter: ChatInputViewModel.fromStore,
            ),
          ],
        ),
      ),
    );
  }

  _updateInputTextChange() {
    final bool inputState = _controller.text.length > 0;
    if (inputState == _textInserted) return;
    setState(() {
      _textInserted = inputState;
    });
  }

  @override
  void dispose() {
    // Also removes the _updateInputTextChange listener.
    super.dispose();
    _controller.dispose();
  }
}
