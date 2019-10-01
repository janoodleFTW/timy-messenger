import "dart:io";

import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/message/message_actions.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class Reaction extends StatelessWidget {
  final String _emoji;
  final int _count;
  final bool _isUserEmoji;
  final String _messageId;

  const Reaction({
    @required emoji,
    @required count,
    @required isUserEmoji,
    @required messageId,
    Key key,
  })  : _emoji = emoji,
        _count = count,
        _isUserEmoji = isUserEmoji,
        _messageId = messageId,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final emojiBottomPadding = Platform.isIOS ? 8.0 : 0.0;
    final emojiWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: emojiBottomPadding),
          child: Text(
            _emoji,
            style: TextStyle(fontSize: 16 * AppTheme.pixelMultiplier),
            textScaleFactor: 1,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          _count.toString(),
          style: AppTheme.emojiReactionTextStyle,
          textScaleFactor: 1,
        ),
      ],
    );

    if (_isUserEmoji) {
      return _removeTapAction(
          context,
          emojiBorder(
            emojiWidget,
            borderColor: AppTheme.colorDarkBlueFont,
            bodyColor: AppTheme.colorLightGreen,
          ));
    } else {
      return _addTapAction(context, emojiBorder(emojiWidget));
    }
  }

  Widget _removeTapAction(
    context,
    Widget child,
  ) {
    return Material(
      child: InkWell(
        child: child,
        onTap: () {
          StoreProvider.of<AppState>(context)
              .dispatch(RemoveEmojiReaction(_messageId));
        },
      ),
      color: Colors.transparent,
    );
  }

  Widget _addTapAction(
    context,
    Widget child,
  ) {
    return Material(
      child: InkWell(
        child: child,
        onTap: () {
          // Tapping on any other emoji replaces the original
          StoreProvider.of<AppState>(context)
              .dispatch(EmojiReaction(_messageId, _emoji));
        },
      ),
      color: Colors.transparent,
    );
  }
}

Widget emojiBorder(
  Widget emojiWidget, {
  Color borderColor = AppTheme.colorGrey225,
  Color bodyColor = Colors.white,
}) {
  return Container(
    width: 44,
    height: 32,
    decoration: BoxDecoration(
      border: Border.all(
        color: borderColor,
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(16.0),
      color: bodyColor,
    ),
    child: Center(child: emojiWidget),
  );
}
