import "package:flutter/material.dart";

class MessagesScrollController extends InheritedWidget {
  final ScrollController scrollController;

  const MessagesScrollController({
    Key key,
    @required Widget child,
    @required this.scrollController,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static MessagesScrollController of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MessagesScrollController);
}
