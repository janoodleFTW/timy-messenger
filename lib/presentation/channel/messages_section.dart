import "package:circles_app/presentation/channel/messages_list/messages_list.dart";
import "package:circles_app/presentation/channel/messages_scroll_controller.dart";
import "package:flutter/material.dart";

class MessagesSection extends StatefulWidget {
  const MessagesSection({Key key}): super(key: key);

  @override
  _MessagesSectionState createState() => _MessagesSectionState();
}

class _MessagesSectionState extends State<MessagesSection>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController;

  static final Animatable<Offset> _fabTween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  AnimationController _controller;
  Animation<Offset> _fabPosition;

  @override
  void initState() {
    super.initState();
    _initTransitionController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollController = MessagesScrollController.of(context).scrollController;
    scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRect(
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: MessagesList(scrollController: scrollController),
            ),
            SlideTransition(
              position: _fabPosition,
              child: _createFloatingActionButton(),
            )
          ],
        ),
      ),
    );
  }

  void _initTransitionController() {
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 500),
    );
    _fabPosition = _controller.drive(_fabTween);
  }

  void _onScroll() {
    if (scrollController.offset > 100) {
      _controller.value = 1;
    } else {
      _controller.value = scrollController.offset / 100;
    }
  }

  Padding _createFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          child: Icon(Icons.arrow_downward),
          onPressed: () {
            _scrollToBottom();
          },
        ),
      ),
    );
  }

  void _scrollToBottom() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 100),
      curve: Curves.bounceOut,
    );
  }
}

