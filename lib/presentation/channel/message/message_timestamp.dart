import "package:circles_app/model/message.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MessageTimestamp extends StatelessWidget {
  const MessageTimestamp({
    Key key,
    @required Message message,
    @required User currentUser,
  })  : _message = message,
        _currentUser = currentUser,
        super(key: key);

  final Message _message;
  final User _currentUser;

  @override
  Widget build(BuildContext context) {
    final timestamp = Text(
      DateFormat.Hm().format(_message.timestamp),
      style: AppTheme.messageTimestampTextStyle,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: AnimatedSwitcher(
          child: _message.authorId == _currentUser.uid && _message.pending
              ? _buildLoading()
              : timestamp,
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Icon(
      Icons.cached,
      size: 16.0,
      color: Colors.grey,
    );
  }
}
