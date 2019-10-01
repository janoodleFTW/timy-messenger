import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/message/message_actions.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

final emojiPickerOptions = const [
  "❤️",
  "😂",
  "🔥",
  "😍",
  "👍",
  "🤔",
  "👽",
  "😊",
  "🥰",
];

void showEmojiPicker(BuildContext context, Message message) {
  showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return EmojiPicker(message);
      });
}

class EmojiPicker extends StatelessWidget {
  final Message _message;

  const EmojiPicker(this._message);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: emojiPickerOptions.map((emoji) =>
                  Material(
                    color: Colors.white,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 20 * AppTheme.pixelMultiplier),
                        ),
                      ),
                      onTap: () {
                        StoreProvider.of<AppState>(context).dispatch(EmojiReaction(
                          _message.id,
                          emoji,
                        ));
                        Navigator.of(context).pop();
                      },
                    ),
                  )
              ).toList()
            ),
          ),
        ),
      ),
    );
  }
}
