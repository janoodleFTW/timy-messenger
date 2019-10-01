import "package:circles_app/circles_localization.dart";
import "package:circles_app/model/channel.dart";
import "package:flutter/widgets.dart";

abstract class ChannelListItem {}

// ChannelListHeadingItem

class ChannelListHeadingItem implements ChannelListItem {
  final String text;
  final ChannelLocalizedKey key;
  final ChannelListHeadingItemType type;

  ChannelListHeadingItem(
      {this.text,
      this.key = ChannelLocalizedKey.NONE,
      this.type = ChannelListHeadingItemType.SECTION});
}

enum ChannelListHeadingItemType { SECTION, H1, H2 }

// ChannelListActionItem

class ChannelListActionItem implements ChannelListItem {
  final ChannelLocalizedKey title;
  final Function buttonAction;

  ChannelListActionItem(this.title, this.buttonAction);
}

// ChannelListChannelItem

class ChannelListChannelItem implements ChannelListItem {
  final Channel channel;
  final String title;
  final bool userIsMember;
  final bool isPublic;
  final bool isSelected;

  ChannelListChannelItem(this.channel, this.title, this.userIsMember,
      this.isPublic, this.isSelected);
}

// This is needed since we currently need a BuildContext to localize.
enum ChannelLocalizedKey {
  TOPICS,
  JOINED,
  PENDING,
  EVENTS,
  UPCOMING,
  PREVIOUS,
  UNREAD,
  NONE,
}

class ChannelItemTitleKeyHelper {
  static String stringOf(ChannelLocalizedKey key, BuildContext context) {
    switch (key) {
      case ChannelLocalizedKey.TOPICS:
        return CirclesLocalizations.of(context).channelTitle;
      case ChannelLocalizedKey.PENDING:
        return CirclesLocalizations.of(context).channelListPending;
      case ChannelLocalizedKey.JOINED:
        return CirclesLocalizations.of(context).channelListJoined;
      case ChannelLocalizedKey.EVENTS:
        return CirclesLocalizations.of(context).channelListEvents;
      case ChannelLocalizedKey.UPCOMING:
        return CirclesLocalizations.of(context).channelListUpcoming;
      case ChannelLocalizedKey.PREVIOUS:
        return CirclesLocalizations.of(context).channelListPrevious;
      case ChannelLocalizedKey.UNREAD:
        return CirclesLocalizations.of(context).channelListUnread;
      case ChannelLocalizedKey.NONE:
        return "";
    }
    return "";
  }
}
