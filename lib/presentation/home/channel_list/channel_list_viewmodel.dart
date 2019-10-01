import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/home/channel_list/channel_list_item.dart";
import "package:circles_app/routes.dart";
import "package:flutter/widgets.dart" as W;
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'channel_list_viewmodel.g.dart';

abstract class ChannelListViewModel
    implements Built<ChannelListViewModel, ChannelListViewModelBuilder> {
  User get user;

  BuiltList<ChannelListItem> get items;

  ChannelListViewModel._();

  factory ChannelListViewModel(
          [void Function(ChannelListViewModelBuilder) updates]) =
      _$ChannelListViewModel;

  static ChannelListViewModel fromStore(Store<AppState> store) {
    final groupId = store.state.selectedGroupId;
    final user = store.state.user;
    final circle = store.state.groups[groupId];
    final channels = circle.channels.values.toList();
    final selectedChannelId = store.state.channelState.selectedChannel;

    _filterIrrelevantChannel(channels, user);

    final updatedChannels = channels
        .where((c) => c.users.any((u) => u.id == user.uid) && c.hasUpdates)
        .toList();

    final list = [
      ChannelListHeadingItem(
          text: circle.name, type: ChannelListHeadingItemType.H1),
      ..._buildUnreadSection(
          _toChannelItem(updatedChannels, selectedChannelId, user.uid)),
      ..._buildEventSection(
          channels: channels,
          selectedChannelId: selectedChannelId,
          userId: user.uid),
      ..._buildGroupSection(
          channels: channels,
          selectedChannelId: selectedChannelId,
          userId: user.uid)
    ];

    return ChannelListViewModel((c) => c
      ..user = user.toBuilder()
      ..items = ListBuilder(list));
  }

  // Filter unjoined private channels. This should eventually be moved to the backend.
  static _filterIrrelevantChannel(List<Channel> channels, user) {
    channels.removeWhere((c) =>
        c.visibility == ChannelVisibility.CLOSED &&
        !c.users.any((u) => u.id == user.uid));
  }

  // Building list group for regular channels.
  static _buildGroupSection({channels, selectedChannelId, userId}) {
    final List<Channel> unjoinedChannels = channels
        .where((Channel c) =>
            !c.users.any((u) => u.id == userId) && c.type == ChannelType.TOPIC)
        .toList();

    final List<Channel> readChannels = channels
        .where((c) =>
            c.type == ChannelType.TOPIC &&
            c.users.any((u) => u.id == userId) &&
            (!c.hasUpdates || c.hasUpdates == null))
        .toList();

    _sortChannelsByName(readChannels);
    _sortChannelsByName(unjoinedChannels);

    // Only show joined and unjoined section when there is content:
    var unjoinedSection = [];
    var joinedAndReadSection = [];

    if (readChannels.length > 0) {
      joinedAndReadSection = [
        ChannelListHeadingItem(key: ChannelLocalizedKey.JOINED),
        ..._toChannelItem(readChannels, selectedChannelId, userId)
      ];
    }

    if (unjoinedChannels.length > 0) {
      unjoinedSection = [
        ChannelListHeadingItem(key: ChannelLocalizedKey.PENDING),
        ..._toChannelItem(unjoinedChannels, selectedChannelId, userId)
      ];
    }

    return [
      ChannelListActionItem(
        ChannelLocalizedKey.TOPICS,
        (context) {
          W.Navigator.pushNamed(context, Routes.channelNew);
        },
      ),
      ...joinedAndReadSection,
      ...unjoinedSection
    ];
  }

  static _sortChannelsByName(List<Channel> channels) {
    channels
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  // Building list group for event channels.
  static _buildEventSection({channels, selectedChannelId, userId}) {
    final List<Channel> events =
        channels.where((c) => c.type == ChannelType.EVENT).toList();

    // Sort events by date.
    events.sort((Channel a, Channel b) {
      return a.startDate.compareTo(b.startDate);
    });

    final now = DateTime.now();
    final today = now.add(Duration(
        hours: -now.hour, minutes: -now.minute, seconds: -(now.second + 1)));

    final upcomingIndex = events.indexWhere((c) => today.isBefore(c.startDate));
    var upcomingEvents = [];
    var previousEvents = [];

    if (events.length > 0) {
      final eventItems = _toChannelItem(events, selectedChannelId, userId);

      // If upcomingIndex is == -1 there's no upcoming events
      if (upcomingIndex >= 0) {
        final upcomingChannelListItems =
            eventItems.getRange(upcomingIndex, eventItems.length);
        if (upcomingChannelListItems.length > 0) {
          upcomingEvents = [
            ChannelListHeadingItem(key: ChannelLocalizedKey.UPCOMING),
            ...upcomingChannelListItems.toList()
          ];
        }
      }

      var previousChannelListItems;
      if (upcomingIndex >= 0) {
        previousChannelListItems = eventItems.getRange(0, upcomingIndex);
      } else {
        // if upcomingIndex == -1 then ALL events have passed
        previousChannelListItems = eventItems;
      }
      if (previousChannelListItems.length > 0) {
        previousEvents = [
          ChannelListHeadingItem(key: ChannelLocalizedKey.PREVIOUS),
          ...previousChannelListItems.toList()
        ];
      }
    }

    return [
      ChannelListActionItem(
        ChannelLocalizedKey.EVENTS,
        (context) {
          W.Navigator.pushNamed(context, Routes.eventNew);
        },
      ),
      ...upcomingEvents,
      ...previousEvents
    ];
  }

  // Building list group for all unread channels (including events).
  // This is sorted by most recent activity.

  static _buildUnreadSection(List<ChannelListItem> unreadChannelItems) {
    return unreadChannelItems.length > 0
        ? [
            ChannelListHeadingItem(
                key: ChannelLocalizedKey.UNREAD,
                type: ChannelListHeadingItemType.H2),
            ...unreadChannelItems
          ]
        : [];
  }

  static List<ChannelListChannelItem> _toChannelItem(
      List<Channel> channels, String selectedChannelId, String userId) {
    return channels
        .map((item) => ChannelListChannelItem(
              item,
              item.name,
              item.users.any((u) => u.id == userId),
              item.visibility == ChannelVisibility.OPEN,
              selectedChannelId == item.id,
            ))
        .toList();
  }
}
