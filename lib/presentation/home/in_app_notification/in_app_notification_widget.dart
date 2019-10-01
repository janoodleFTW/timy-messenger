import "dart:async";

import "package:circles_app/presentation/home/in_app_notification/in_app_notification_viewmodel.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";

class InAppNotificationWidget extends StatefulWidget {
  final InAppNotificationViewModel _vm;

  const InAppNotificationWidget(
    this._vm, {
    Key key,
  }) : super(key: key);

  @override
  _InAppNotificationWidgetState createState() =>
      _InAppNotificationWidgetState();
}

class _InAppNotificationWidgetState extends State<InAppNotificationWidget>
    with SingleTickerProviderStateMixin {
  Animation<Offset> _position;
  AnimationController _controller;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _initTransitionController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer.cancel();
  }

  void _initTransitionController() {
    final Animatable<Offset> _tween = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _position = _controller.drive(_tween);
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget._vm.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.reset();
    _controller.forward();
    _timer = Timer(Duration(seconds: 3), _dismiss);

    return SlideTransition(
      position: _position,
      child: Dismissible(
        key: Key(widget._vm.hashCode.toString()),
        onDismissed: (direction) => widget._vm.onDismissed(),
        child: GestureDetector(
          onTap: widget._vm.onTap,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 32.0,
              left: 12,
              right: 12,
            ),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: AssetImage("assets/graphics/visual_twist.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/graphics/icon_notification.png",
                          height: 16,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "${widget._vm.inAppNotification.groupName}: ${widget._vm.inAppNotification.channel.name}",
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.notificationTitle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${widget._vm.inAppNotification.userName}: ${widget._vm.inAppNotification.message}",
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.notificationBody,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
