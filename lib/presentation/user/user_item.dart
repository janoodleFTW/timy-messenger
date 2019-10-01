import "package:circles_app/circles_localization.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/user/rsvp_icon.dart";
import "package:circles_app/presentation/user/selected_item.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:transparent_image/transparent_image.dart";

class UserItem extends StatelessWidget {
  const UserItem({
    Key key,
    @required User user,
    bool selected = false,
    Function selectionHandler,
    RSVP rsvp,
    bool isYou = false,
    bool isHost = false,
  })  : _user = user,
        _selected = selected,
        _selectionHandler = selectionHandler,
        _rsvp = rsvp,
        _isYou = isYou,
        _isHost = isHost,
        super(key: key);

  final User _user;
  final bool _selected;
  final Function _selectionHandler;
  final RSVP _rsvp;
  final bool _isYou;
  final bool _isHost;

  @override
  Widget build(BuildContext context) {
    final placeholderImage = Image.asset(
      "assets/graphics/avatar_no_picture.png",
      height: AppTheme.avatarSize,
      width: AppTheme.avatarSize,
    );

    final userName = _isYou ? CirclesLocalizations.of(context).you : _user.name;
    final userText = _isHost
        ? "$userName · ${CirclesLocalizations.of(context).eventHost}"
        : userName;

    Widget _buildImage() {
      if (_user.image == null) {
        return placeholderImage;
      }

      return Container(
          child: FadeInImage.memoryNetwork(
        image: _user.image,
        height: AppTheme.avatarSize,
        width: AppTheme.avatarSize,
        fit: BoxFit.contain,
        placeholder: kTransparentImage,
      ));
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
          key: Key("${_user.uid}.InkWell"),
          onTap: () {
            if (_selectionHandler != null) {
              _selectionHandler(_user);
            } else {
              _openDetails(context, _user);
            }
          },
          child: Column(
            children: <Widget>[
              Container(
                height: 63,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppTheme.appMargin,
                        right: AppTheme.appMargin,
                      ),
                      child: _buildImage(),
                    ),
                    Expanded(
                      child: Text(
                        userText,
                        style: AppTheme.messageAuthorNameTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Visibility(
                      visible: _selectionHandler != null,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: AppTheme.appMargin),
                        child: SelectedItem(
                          selected: _selected,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _rsvp != null,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: AppTheme.appMargin),
                        child: RsvpIcon(
                          rsvp: _rsvp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppTheme.appMargin,
                  right: AppTheme.appMargin,
                ),
                child: Container(
                  height: 1,
                  color: AppTheme.colorShadow,
                ),
              ),
            ],
          )),
    );
  }

  void _openDetails(context, User user) {
    Navigator.of(context).pushNamed(Routes.user, arguments: user.uid);
  }
}
