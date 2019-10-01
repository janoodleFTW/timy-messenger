import "package:circles_app/model/message.dart";
import "package:circles_app/presentation/channel/reaction/emoji_picker.dart";
import "package:circles_app/presentation/channel/reaction/reaction.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class ReactionButton extends StatelessWidget {
  const ReactionButton(
    this._message,
  );

  final Message _message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: emojiBorder(
        Image.asset(
          "assets/graphics/icon_smile.png",
          height: 16 * AppTheme.pixelMultiplier,
          width: 16 * AppTheme.pixelMultiplier,
        ),
      ),
      onTap: () {
        showEmojiPicker(context, _message);
      },
    );
  }
}
