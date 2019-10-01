import "dart:io";

import "package:circles_app/circles_localization.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/channel/message/media/MediaMessage.dart";
import "package:circles_app/presentation/channel/message/message_body.dart";
import "package:circles_app/presentation/channel/message/message_timestamp.dart";
import "package:circles_app/presentation/channel/reaction/emoji_picker.dart";
import "package:circles_app/presentation/channel/reaction/reaction_section.dart";
import "package:circles_app/presentation/user/user_avatar.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:transparent_image/transparent_image.dart";

class MessageItem extends StatelessWidget {
  const MessageItem({
    @required Message message,
    @required bool userIsMember,
    @required User currentUser,
    @required User author,
    Key key,
  })  : _message = message,
        _currentUser = currentUser,
        _userIsMember = userIsMember,
        _author = author,
        assert(message != null),
        assert(currentUser != null),
        super(key: key);

  final Message _message;
  final User _currentUser;
  final bool _userIsMember;

  // _author can be null if the author was deleted
  // see: https://github.com/janoodleFTW/flutter-app/issues/222
  final User _author;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Column(
          children: <Widget>[
            SizedBox(height: AppTheme.appMargin),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildAvatar(context),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _authorName(context),
                          MessageTimestamp(
                            message: _message,
                            currentUser: _currentUser,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      _buildBody(),
                      ReactionSection(
                        message: _message,
                        currentUser: _currentUser,
                        userIsMember: _userIsMember,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppTheme.appMargin)
              ],
            ),
            SizedBox(height: AppTheme.appMargin),
          ],
        ),
        onTap: () {
          // On iOS, taping on the chat section dismisses keyboard
          if (Platform.isIOS) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        onLongPress: () {
          if (_currentUser.uid != _author?.uid &&
              !_message.reactions.containsKey(_currentUser.uid) &&
              _userIsMember) {
            showEmojiPicker(context, _message);
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_message.messageType) {
      case MessageType.MEDIA:
        return MessageMedia(_message);
        break;
      case MessageType.SYSTEM:
      case MessageType.USER:
      case MessageType.RSVP:
      default:
        return MessageBody(
          message: _message,
        );
        break;
    }
  }

  Widget _buildAvatar(context) {
    return InkWell(
      onTap: () {
        if (_author != null) {
          Navigator.of(context).pushNamed(Routes.user, arguments: _author.uid);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppTheme.appMargin,
          right: AppTheme.appMargin,
        ),
        child: UserAvatar(
          user: _author,
        ),
      ),
    );
  }

  Widget _authorName(context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          if (_author != null) {
            Navigator.of(context)
                .pushNamed(Routes.user, arguments: _author.uid);
          }
        },
        child: Text(
          _author?.name ?? CirclesLocalizations.of(context).deletedUser,
          overflow: TextOverflow.ellipsis,
          style: AppTheme.messageAuthorNameTextStyle,
        ),
      ),
    );
  }
}

class PictureInMessage extends StatelessWidget {
  final String url;

  const PictureInMessage(this.url);

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.image,
                arguments: url,
              );
            },
            child: Stack(
              children: <Widget>[
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )),
                Center(
                  child: Hero(
                    tag: url,
                    child: FadeInImage.memoryNetwork(
                      image: url,
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
