import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/user/user_avatar.dart";
import "package:flutter/material.dart";

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    Key key,
    this.pictureIconButton,
    @required this.user,
  }) : super(key: key);

  final Widget pictureIconButton;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          width: _Style.avatarSize,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              UserAvatar(
                user: user,
                size: _Style.avatarSize,
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: AnimatedSwitcher(
                  child: pictureIconButton ?? SizedBox.shrink(),
                  duration: Duration(milliseconds: 200),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _Style {
  static const double avatarSize = 200.0;
}
