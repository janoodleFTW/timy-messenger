import "package:circles_app/circles_localization.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";

class SystemMessageItem extends StatelessWidget {
  final Message _message;

  const SystemMessageItem(
    this._message, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48 * AppTheme.pixelMultiplier,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppTheme.appMargin,
            right: AppTheme.appMargin,
          ),
          // Currently only dealing with SYSTEM or RSVP messages
          child: Text(_message.messageType == MessageType.SYSTEM ? 
            CirclesLocalizations.of(context).channelSystemMessage(_message.body).toUpperCase() :
            CirclesLocalizations.of(context).rsvpSystemMessage(_message.body).toUpperCase(),
            style: AppTheme.systemMessageTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
