import "package:circles_app/data/message_repository.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/domain/redux/message/message_actions.dart";
import "package:circles_app/domain/redux/stream_subscriptions.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/reaction.dart";
import "package:circles_app/util/logger.dart";
import "package:redux/redux.dart";

List<Middleware<AppState>> createMessagesMiddleware(
  MessageRepository messagesRepository,
) {
  return [
    TypedMiddleware<AppState, SendMessage>(_sendMessage(messagesRepository)),
    TypedMiddleware<AppState, DeleteMessage>(
        _deleteMessage(messagesRepository)),
    TypedMiddleware<AppState, SelectChannel>(
        _listenMessages(messagesRepository)),
    TypedMiddleware<AppState, EmojiReaction>(
        _reactWithEmoji(messagesRepository)),
    TypedMiddleware<AppState, RemoveEmojiReaction>(
        _removeReaction(messagesRepository)),
  ];
}

void Function(
  Store<AppState> store,
  SendMessage action,
  NextDispatcher next,
) _sendMessage(
  MessageRepository messageRepository,
) {
  return (store, action, next) async {
    next(action);
    final groupId = store.state.selectedGroupId;
    final channelId = store.state.channelState.selectedChannel;
    final message = Message((m) => m
      ..body = action.message
      ..authorId = store.state.user.uid);
    try {
      await messageRepository.sendMessage(groupId, channelId, message);
    } catch (e) {
      Logger.e("Failed to send message", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  DeleteMessage action,
  NextDispatcher next,
) _deleteMessage(
  MessageRepository messageRepository,
) {
  return (store, action, next) async {
    next(action);
    final groupId = store.state.selectedGroupId;
    final channelId = store.state.channelState.selectedChannel;
    try {
      await messageRepository.deleteMessage(groupId, channelId, action.messageId);
    } catch (e) {
      Logger.e("Failed to delete message", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  SelectChannel action,
  NextDispatcher next,
) _listenMessages(
  MessageRepository messageRepository,
) {
  return (store, action, next) {
    next(action);
    try {
      // Do not update subscription if there's already a valid subscription to it.
      // This is necessary since we'll update the channel as well (e.g. when users join/leave etc).
      if (action.channel.id == action.previousChannelId) {
        return;
      }

      // cancel previous message subscription
      messagesSubscription?.cancel();

      final groupId = store.state.selectedGroupId;
      final channelId = store.state.channelState.selectedChannel;
      final userId = store.state.user.uid;

      // ignore: cancel_subscriptions
      messagesSubscription = messageRepository
          .getMessagesStream(
        groupId,
        channelId,
        userId,
      )
          .listen((data) {
        store.dispatch(UpdateAllMessages(data));
      });
    } catch (e) {
      Logger.e("Failed to listen to messages", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  EmojiReaction action,
  NextDispatcher next,
) _reactWithEmoji(
  MessageRepository messageRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      final groupId = store.state.selectedGroupId;
      final channelId = store.state.channelState.selectedChannel;
      final messageId = action.messageId;
      final userId = store.state.user.uid;
      final userName = store.state.user.name;
      final emoji = action.emoji;
      final reaction = Reaction((r) => r
        ..userId = userId
        ..userName = userName
        ..emoji = emoji
        ..timestamp = DateTime.now());
      await messageRepository.addReaction(
        groupId: groupId,
        channelId: channelId,
        messageId: messageId,
        reaction: reaction,
      );
    } catch (e) {
      Logger.e("Failed to add emoji reaction", e: e, s: StackTrace.current);
    }
  };
}

void Function(
  Store<AppState> store,
  RemoveEmojiReaction action,
  NextDispatcher next,
) _removeReaction(
  MessageRepository messageRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      final groupId = store.state.selectedGroupId;
      final channelId = store.state.channelState.selectedChannel;
      final messageId = action.messageId;
      final userId = store.state.user.uid;
      await messageRepository.removeReaction(
        groupId: groupId,
        channelId: channelId,
        messageId: messageId,
        userId: userId,
      );
    } catch (e) {
      Logger.e("Failed to remove emoji reaction", e: e, s: StackTrace.current);
    }
  };
}
