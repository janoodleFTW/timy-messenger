import "dart:async";

import "package:built_collection/built_collection.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:flutter/widgets.dart";
import "package:meta/meta.dart";

@immutable
class LoadChannels {
  final String groupId;

  const LoadChannels(this.groupId);

  @override
  String toString() {
    return "LoadChannels{groupId: $groupId}";
  }
}

@immutable
class OnChannelsLoaded {
  final String groupId;
  final List<Channel> channels;

  const OnChannelsLoaded(this.groupId, this.channels);

  @override
  String toString() {
    return "OnChannelsLoaded{groupId: $groupId, channels: $channels}";
  }
}

@immutable
class CreateChannel {
  final Channel channel;
  final BuiltList<String> invitedIds;
  final Completer completer;

  const CreateChannel(
    this.channel,
    this.invitedIds,
    this.completer,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CreateChannel &&
              runtimeType == other.runtimeType &&
              channel == other.channel &&
              invitedIds == other.invitedIds;

  @override
  int get hashCode =>
      channel.hashCode ^
      invitedIds.hashCode;

  @override
  String toString() {
    return "CreateChannel{channel: $channel, invitedIds: $invitedIds}";
  }
}

@immutable
class OnChannelCreated {
  final Channel channel;

  const OnChannelCreated(
    this.channel,
  );
}

@immutable
class EditChannelAction {
  final Channel channel;
  final Completer completer;

  const EditChannelAction(
    this.channel,
    this.completer,
  );
}

@immutable
class OnUpdatedChannelAction {
  final String groupId;
  final Channel selectedChannel;

  const OnUpdatedChannelAction(this.groupId, this.selectedChannel);
}

@immutable
class SelectChannelIdAction {
  final String previousChannelId;
  final String channelId;
  final String userId;
  final String groupId;

  const SelectChannelIdAction({
    this.previousChannelId,
    this.channelId,
    this.groupId,
    this.userId,
  });
}

@immutable
class SelectChannel {
  final String previousChannelId;
  final Channel channel;
  final String userId;
  final String groupId;

  const SelectChannel({
    this.previousChannelId,
    this.channel,
    this.groupId,
    this.userId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SelectChannel &&
              runtimeType == other.runtimeType &&
              previousChannelId == other.previousChannelId &&
              channel == other.channel &&
              userId == other.userId &&
              groupId == other.groupId;

  @override
  int get hashCode =>
      previousChannelId.hashCode ^
      channel.hashCode ^
      userId.hashCode ^
      groupId.hashCode;

  @override
  String toString() {
    return "SelectChannel{previousChannelId: $previousChannelId, channel: $channel, userId: $userId, groupId: $groupId}";
  }
}

@immutable
class JoinChannelAction {
  final String groupId;
  final Channel channel;
  final User user;

  const JoinChannelAction({
    @required this.groupId,
    @required this.channel,
    @required this.user,
  });
}

@immutable
class JoinedChannelAction {
  final String groupId;
  final Channel channel;

  const JoinedChannelAction(
    this.groupId,
    this.channel,
  );
}

@immutable
class JoinChannelFailedAction {}

@immutable
class ClearFailedJoinAction {}

@immutable
class LeaveChannelAction {
  final String groupId;
  final Channel channel;
  final String userId;

  const LeaveChannelAction(this.groupId, this.channel, this.userId);
}

@immutable
class LeftChannelAction {
  final String groupId;
  final String channelId;
  final String userId;

  const LeftChannelAction(this.groupId, this.channelId, this.userId);
}

@immutable
class RsvpAction {
  final RSVP rsvp;
  final Completer completer;

  const RsvpAction(this.rsvp, this.completer);
}

@immutable
class InviteToChannelAction {
  final Iterable<String> users;
  final Channel channel;
  final Completer completer;

  const InviteToChannelAction(this.users, this.channel, this.completer);
}
