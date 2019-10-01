import "package:circles_app/data/channel_repository.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/domain/redux/stream_subscriptions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/material.dart";
import "package:redux/redux.dart";

List<Middleware<AppState>> createChannelsMiddleware(
  ChannelRepository channelsRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    TypedMiddleware<AppState, SelectChannelIdAction>(
      _selectChannelId(channelsRepository),
    ),
    TypedMiddleware<AppState, SelectChannel>(
      _markChannelReadAndListenToChannelUpdates(channelsRepository),
    ),
    TypedMiddleware<AppState, JoinChannelAction>(
      _joinChannel(channelsRepository),
    ),
    TypedMiddleware<AppState, LeaveChannelAction>(
      _leaveChannel(channelsRepository),
    ),
    TypedMiddleware<AppState, LoadChannels>(
      _listenToChannels(channelsRepository),
    ),
    TypedMiddleware<AppState, CreateChannel>(
      _createChannel(
        channelsRepository,
        navigatorKey,
      ),
    ),
    TypedMiddleware<AppState, EditChannelAction>(
      _editChannel(
        channelsRepository,
        navigatorKey,
      ),
    ),
    TypedMiddleware<AppState, RsvpAction>(
      _rsvp(channelsRepository),
    ),
    TypedMiddleware<AppState, InviteToChannelAction>(
      _inviteToChannel(channelsRepository),
    ),
  ];
}

/// Fetches and selects channel based on its id
void Function(
  Store<AppState> store,
  SelectChannelIdAction action,
  NextDispatcher next,
) _selectChannelId(ChannelRepository channelRepository) {
  return (store, action, next) {
    channelRepository
        .getChannel(action.groupId, action.channelId, action.userId)
        .then((channel) {
      store.dispatch(SelectChannel(
          channel: channel, groupId: action.groupId, userId: action.userId));
    }).catchError((error) {
      Logger.e(
        "Failed to fetch and select channel",
        e: error,
        s: StackTrace.current,
      );
    });
  };
}

void Function(
  Store<AppState> store,
  LeaveChannelAction action,
  NextDispatcher next,
) _leaveChannel(
  ChannelRepository channelsRepository,
) {
  return (store, action, next) async {
    next(action);
    await _leaveChannelInternal(
      channelsRepository: channelsRepository,
      groupId: action.groupId,
      channelId: action.channel.id,
      userId: action.userId,
      store: store,
    );
  };
}

Future<void> _leaveChannelInternal({
  @required ChannelRepository channelsRepository,
  @required String groupId,
  @required String channelId,
  @required String userId,
  @required Store<AppState> store,
}) async {
  try {
    await channelsRepository.leaveChannel(groupId, channelId, userId);
    store.dispatch(LeftChannelAction(groupId, channelId, userId));
  } catch (e) {
    Logger.e("Failed to leave channel", e: e, s: StackTrace.current);
  }
}

_listenToChannelUpdates(
    {Store<AppState> store,
    SelectChannel action,
    ChannelRepository channelRepository}) {
  selectedChannelSubscription?.cancel();
  // ignore: cancel_subscriptions
  selectedChannelSubscription = channelRepository
      .getStreamForChannel(action.groupId, action.channel.id, action.userId)
      .listen((updatedChannel) {
    store.dispatch(OnUpdatedChannelAction(action.groupId, updatedChannel));
  });
}

/// Does two things:
/// 1. Marks a channel read (in case there are updates)
/// 2. Subscribes to channel updates
///
/// We're handling both cases here is necessary since the subscription
/// to the channel was overriding our local state change for a channel (e.g. hasUpdates = false).
void Function(
  Store<AppState> store,
  SelectChannel action,
  NextDispatcher next,
) _markChannelReadAndListenToChannelUpdates(
    ChannelRepository channelRepository) {
  return (store, action, next) {
    next(action);

    try {
      if (action.channel.users.any((u) => u.id == action.userId)) {
        channelRepository
            .markChannelRead(action.groupId, action.channel.id, action.userId)
            .then((_) {
          _listenToChannelUpdates(
              action: action,
              store: store,
              channelRepository: channelRepository);
        });
      } else {
        _listenToChannelUpdates(
            action: action, store: store, channelRepository: channelRepository);
      }
    } catch (e) {
      Logger.e("Failed to mark as read", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  JoinChannelAction action,
  NextDispatcher next,
) _joinChannel(
  ChannelRepository channelsRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      final channel = await channelsRepository.joinChannel(
        action.groupId,
        action.channel,
        action.user.uid,
      );
      store.dispatch(JoinedChannelAction(
        action.groupId,
        channel,
      ));
    } catch (error) {
      Logger.e("Failed join channel", e: error, s: StackTrace.current);
      store.dispatch(JoinChannelFailedAction());
    }
  };
}

void Function(
  Store<AppState> store,
  LoadChannels action,
  NextDispatcher next,
) _listenToChannels(
  ChannelRepository channelsRepository,
) {
  return (store, action, next) {
    next(action);
    listOfChannelsSubscription?.cancel();
    // ignore: cancel_subscriptions
    listOfChannelsSubscription = channelsRepository
        .getChannelsStream(action.groupId, store.state.user.uid)
        .listen((channels) {
      if (channels.isNotEmpty) {
        store.dispatch(OnChannelsLoaded(action.groupId, channels));

        final selectedChannel = getSelectedChannel(store.state);

        // If the selected channel is null
        // Or the selected channel does NOT belong to this group
        //  (e.g. user selected a different group)
        if (selectedChannel == null ||
            !_isChannelInList(channels, selectedChannel)) {
          // Select a channel based on this logic
          final channel = _pickChannelToSelect(store, action, channels);
          if (channel != null) {
            store.dispatch(SelectChannel(
                previousChannelId: null,
                channel: channel,
                groupId: action.groupId,
                userId: store.state.user.uid));
          }
        }
      }
    });
  };
}

Channel _pickChannelToSelect(
    Store<AppState> store, LoadChannels action, List<Channel> channels) {
  // Channel to select automatically
  Channel channel;

  // Select the previously selected channel (if still exists)
  final channelId =
      store.state.uiState.groupUiState[action.groupId]?.lastSelectedChannel;
  if (channelId != null) {
    channel = channels.firstWhere((c) => c.id == channelId, orElse: null);
  }

  // If no previously selected channel for a group
  if (channel == null) {
    // Select a default OPEN channel if there are channels available
    channel = _defaultChannel(channels);
  }
  return channel;
}

Channel _defaultChannel(List<Channel> channels) =>
    channels.firstWhere((c) => c.visibility == ChannelVisibility.OPEN);

bool _isChannelInList(List<Channel> channels, Channel channel) {
  if (channel == null) {
    return false;
  }
  return channels.any((c) => c.id == channel?.id);
}

void Function(
  Store<AppState> store,
  CreateChannel action,
  NextDispatcher next,
) _createChannel(
  ChannelRepository channelsRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) async {
    next(action);

    try {
      // Create Channel
      final createdChannel = await channelsRepository.createChannel(
        store.state.selectedGroupId,
        action.channel,
        [store.state.user.uid, ...action.invitedIds.toList()],
        store.state.user.uid,
      );

      store.dispatch(OnChannelCreated(createdChannel));

      // Select the newly created channel.
      // Adding delay to allow backend to add invited members
      Future.delayed(const Duration(milliseconds: 1000), () {
        store.dispatch(SelectChannel(
          previousChannelId: store.state.channelState.selectedChannel,
          channel: createdChannel,
          groupId: store.state.selectedGroupId,
          userId: store.state.user.uid,
        ));
      });

      action.completer.complete();
    } catch (error) {
      Logger.e("Failed create channel", e: error, s: StackTrace.current);
      action.completer.completeError(error);
    }
  };
}

void Function(
  Store<AppState> store,
  EditChannelAction action,
  NextDispatcher next,
) _editChannel(
  ChannelRepository channelsRepository,
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) async {
    next(action);

    try {
      await channelsRepository.updateChannel(
        store.state.selectedGroupId,
        action.channel,
      );
      store.dispatch(
          OnUpdatedChannelAction(store.state.selectedGroupId, action.channel));
      action.completer.complete();
    } catch (error) {
      action.completer.completeError(error);
    }
  };
}

void Function(
  Store<AppState> store,
  RsvpAction action,
  NextDispatcher next,
) _rsvp(
  ChannelRepository channelsRepository,
) {
  return (store, action, next) async {
    try {
      // Event has passed
      if (getSelectedChannel(store.state).startDate.isBefore(DateTime.now())) {
        throw Exception(
            "RSVP after event passed ${getSelectedChannel(store.state).startDate} vs. now: ${DateTime.now()}");
      }

      // Allow users to RSVP even when they are not members
      if (_userIsNotChannelMember(store) && _rsvpYesOrMaybe(action.rsvp)) {
        // That causes them to join the channel
        final channel = await channelsRepository.joinChannel(
          store.state.selectedGroupId,
          getSelectedChannel(store.state),
          store.state.user.uid,
        );
        store.dispatch(JoinedChannelAction(
          store.state.selectedGroupId,
          channel,
        ));
      }

      // Ignore when a user that is not member clicks on NO
      if (_userIsNotChannelMember(store) && _rsvpNo(action.rsvp)) {
        return;
      }

      await channelsRepository.rsvp(
        store.state.selectedGroupId,
        store.state.channelState.selectedChannel,
        store.state.user.uid,
        action.rsvp,
      );

      if (_rsvpNo(action.rsvp)) {
        await _leaveChannelInternal(
          channelsRepository: channelsRepository,
          groupId: store.state.selectedGroupId,
          channelId: store.state.channelState.selectedChannel,
          userId: store.state.user.uid,
          store: store,
        );
      }

      action.completer.complete(action.rsvp);
    } catch (e) {
      Logger.e("Failed RSVP", e: e, s: StackTrace.current);
    }
    next(action);
  };
}

bool _rsvpYesOrMaybe(RSVP rsvp) => [RSVP.YES, RSVP.MAYBE].contains(rsvp);

bool _rsvpNo(RSVP rsvp) => rsvp == RSVP.NO;

bool _userIsNotChannelMember(Store<AppState> store) {
  return !getSelectedChannel(store.state)
      .users
      .any((cu) => cu.id == store.state.user.uid);
}

void Function(
  Store<AppState> store,
  InviteToChannelAction action,
  NextDispatcher next,
) _inviteToChannel(
  ChannelRepository channelsRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      await channelsRepository.inviteToChannel(
          groupId: store.state.selectedGroupId,
          channel: action.channel,
          members: action.users,
          invitingUsername: store.state.user.name,
          groupName: store.state.groups[store.state.selectedGroupId].name);
      action.completer.complete();
    } catch (error) {
      Logger.e("Failed invite to channel", e: error, s: StackTrace.current);
      action.completer.completeError(error);
    }
  };
}
