import "package:circles_app/model/message.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_linkify/flutter_linkify.dart";
import "package:linkify/linkify.dart";
import "package:url_launcher/url_launcher.dart";

class MessageBody extends StatelessWidget {
  const MessageBody({
    Key key,
    @required Message message,
  })  : _message = message,
        super(key: key);

  final Message _message;

  @override
  Widget build(BuildContext context) {
    if (_message.body.isEmpty) {
      return SizedBox.shrink();
    }
    final elements = linkify(
      _message.body,
      humanize: true,
      linkTypes: null,
    );
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      text: buildTextSpan(
        elements,
        style: AppTheme.messageTextStyle,
        onOpen: (link) async {
          if (await canLaunch(link.url)) {
            await launch(link.url);
          } else {
            throw "Could not launch $link";
          }
        },
        linkStyle: AppTheme.linkTextStyle,
      ),
    );
  }
}
