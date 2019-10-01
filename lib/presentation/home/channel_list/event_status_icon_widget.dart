import "package:circles_app/theme.dart";
import "package:flutter/widgets.dart";
import "package:intl/intl.dart";

class EventStatusIconWidget extends StatelessWidget {
  final bool _joined;
  final bool _isPublic; // Padlock used?
  final DateTime _eventDate;

  const EventStatusIconWidget(
      {joined, isPublic, eventDate, Key key})
      : _joined = joined,
        _eventDate = eventDate,
        _isPublic = isPublic,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            width: _Style.width,
            height: _Style.width,
            child: Padding(
                padding: EdgeInsets.only(top: 2),
                child: Stack(
                  children: <Widget>[
                    _imageWidget(_joined),
                    _buildIcon(_eventDate, _joined, _isPublic),
                  ],
                ))));
  }

  _buildIcon(eventDate, isMember, isPublic) {
    if (isPublic) {
      return Positioned(
          left: 0, top: 7, child: _eventIconTime(eventDate, isMember));
    } else {
      return Positioned(
          top: 4,
          child: Visibility(
            visible: !_isPublic,
            child: Image.asset(
              "assets/graphics/channel/padlock.png",
              width: _Style.imageSize.width,
              height: _Style.imageSize.height,
            ),
          ));
    }
  }

  _eventIconTime(eventDate, isMember) => Container(
      width: _Style.imageSize.width,
      child: Column(
        children: <Widget>[
          Text(
            eventDate.day.toString(),
            textAlign: TextAlign.center,
            style: isMember
                ? AppTheme.eventIconMemberTitle
                : AppTheme.eventIconTitle,
            textScaleFactor: 1,
          ),
          Text(
            DateFormat("MMM").format(eventDate).toUpperCase(),
            textAlign: TextAlign.center,
            style: isMember
                ? AppTheme.eventIconMemberSubTitle
                : AppTheme.eventIconSubTitle,
            textScaleFactor: 1,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 2),
          )
        ],
      ));

  _imageWidget(joined) => Image.asset(
        joined
            ? "assets/graphics/channel/event_joined.png"
            : "assets/graphics/channel/event_open.png",
        width: _Style.imageSize.width,
        height: _Style.imageSize.height,
        color: AppTheme.colorDarkBlue,
      );
}

class _Style {
  static const imageSize = Size(25, 26);
  static const width = 32.0;
}
