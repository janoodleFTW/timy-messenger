import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class SlideOutScreen extends StatefulWidget {
  const SlideOutScreen({
    this.main,
    this.side,
    this.sideOpenController,
  });

  final Widget main;
  final Widget side;
  final ValueNotifier<bool> sideOpenController;

  @override
  _SlideOutScreenState createState() => _SlideOutScreenState();
}

class _SlideOutScreenState extends State<SlideOutScreen>
    with SingleTickerProviderStateMixin {
  static const _clip = 60.0;

  double _screenWidth;
  AnimationController _controller;
  Animation<RelativeRect> _position;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    widget.sideOpenController.addListener(() {
      if (widget.sideOpenController.value) {
        _hideHomeScreen();
      } else {
        _showHomeScreen();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    final offset = _clip - _screenWidth;

    final Animatable<RelativeRect> fabTween = RelativeRectTween(
      // Position in which the HomeScreen is fully visible
      begin: RelativeRect.fromLTRB(0.0, 0.0, offset, 0.0),
      // Position in which the side details are fully visible
      end: RelativeRect.fromLTRB(offset, 0.0, 0.0, 0.0),
    ).chain(CurveTween(
      curve: Curves.fastOutSlowIn,
    ));

    _position = _controller.drive(fabTween);
  }

  void _move(DragUpdateDetails details) {
    // delta based on the total screen width, kind of works
    final double delta = details.primaryDelta / _screenWidth;
    // only allow dragging from left to right
    if (delta > 0) {
      _controller.value -= delta;
    }
  }

  void _settle(DragEndDetails details) {
    // Only allow swiping left to right
    if (details.primaryVelocity > 0) {
      _showHomeScreen();
    } else {
      // If the animation is closer to start
      // i.e. the home screen is mostly visible
      if (_controller.value < 0.5) {
        // animate back to start (home screen open)
        _showHomeScreen();
      } else {
        // if not, animate to show the side details section
        _hideHomeScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Stack + PositionedTransition allow for transitioning the child screen
    return Stack(
      children: <Widget>[
        PositionedTransition(
          rect: _position,
          // Takes care of the dragging to close
          child: GestureDetector(
            onHorizontalDragUpdate: _move,
            onHorizontalDragEnd: _settle,
            child: Row(
              children: <Widget>[
                _expandOnTap(child: _mainScreen()),
                _sideContainer(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sideContainer(BuildContext context) {
    return SizedBox(
      width: _screenWidth - _clip,
      child: Scaffold(
        body: widget.side,
      ),
    );
  }

  Widget _expandOnTap({Widget child}) {
    // Rebuilds the GestureDetector on animation changes
    // required to reconfigure the GestureDetector behavior and the IgnorePointer
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, widget) {
        return GestureDetector(
          behavior:
              // set as opaque so we can absorb the taps
              _isExpanded()
                  ? HitTestBehavior.deferToChild
                  : HitTestBehavior.opaque,
          onTap: () {
            _showHomeScreen();
          },
          // Ignore taps on the HomeScreen when the Side is displayed
          child: IgnorePointer(
            ignoring: !_isExpanded(),
            child: child,
          ),
        );
      },
    );
  }

  SizedBox _mainScreen() {
    // Required since we have a relative size Widget inside (ListView)
    return SizedBox(
      width: _screenWidth,
      child: widget.main,
    );
  }

  void _showHomeScreen() {
    widget.sideOpenController.value = false;
    _controller.animateBack(0.0);
  }

  void _hideHomeScreen() {
    widget.sideOpenController.value = true;
    _controller.forward();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // True when the HomeScreen is fully visible
  bool _isExpanded() => _controller.value == 0.0;
}
