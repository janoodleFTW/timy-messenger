import "package:circles_app/model/user.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:transparent_image/transparent_image.dart";

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    @required this.user,
    this.size = AppTheme.avatarSize,
  });

  // user can be null
  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (user?.image == null) {
      return Image.asset(
        "assets/graphics/avatar_no_picture.png",
        height: size,
        width: size,
        fit: BoxFit.contain,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: FadeInImage.memoryNetwork(
        image: user.image,
        height: size,
        width: size,
        fit: BoxFit.fitHeight,
        placeholder: kTransparentImage,
      ),
    );
  }
}
