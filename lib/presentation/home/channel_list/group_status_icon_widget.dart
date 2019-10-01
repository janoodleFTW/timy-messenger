import "package:circles_app/theme.dart";
import "package:flutter/widgets.dart";

class GroupStatusIconWidget extends StatelessWidget {
  final bool _joined;
  final bool _isPrivateChannel;

  const GroupStatusIconWidget({joined, isPrivateChannel, Key key})
      : _joined = joined,
        _isPrivateChannel = isPrivateChannel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            width: _Style.width,
            height: _Style.width,
            child: Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      _joined
                          ? "assets/graphics/channel/topic_joined.png"
                          : "assets/graphics/channel/topic_open.png",
                      width: _Style.imageSize.width,
                      color: AppTheme.colorDarkBlue,
                    ),
                    Visibility(
                      visible: _isPrivateChannel,
                      child: Image.asset(
                        "assets/graphics/channel/padlock.png",
                        width: _Style.imageSize.width,
                        height: _Style.imageSize.height,
                      ),
                    ),
                  ],
                ))));
  }
}

class _Style {
  static const imageSize = Size(25, 26);
  static const width = 32.0;
}
