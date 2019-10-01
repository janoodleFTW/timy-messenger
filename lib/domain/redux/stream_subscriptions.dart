import "dart:async";

import "package:circles_app/model/channel.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/user.dart";

// App user
StreamSubscription<User> userUpdateSubscription;
// List of user's groups
StreamSubscription<List<Group>> groupsSubscription;
// List of users of the current selected group
StreamSubscription<List<User>> groupUsersSubscription;
// List of channels of the current selected group
StreamSubscription<List<Channel>> listOfChannelsSubscription;
// Selected channel
StreamSubscription<Channel> selectedChannelSubscription;
// Messages from selected channel
StreamSubscription<List<Message>> messagesSubscription;

/// Cancels all active subscriptions
///
/// Called on successful logout.
cancelAllSubscriptions() {
  userUpdateSubscription?.cancel();
  groupsSubscription?.cancel();
  groupUsersSubscription?.cancel();
  listOfChannelsSubscription?.cancel();
  selectedChannelSubscription?.cancel();
  messagesSubscription?.cancel();
}