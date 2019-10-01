import "dart:async";

import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/user.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'invite_to_channel_viewmodel.g.dart';

abstract class InviteToChannelViewModel
    implements
        Built<InviteToChannelViewModel, InviteToChannelViewModelBuilder> {
  InviteToChannelViewModel._();

  BuiltList<User> get newUsers;

  @BuiltValueField(compare: false)
  void Function(Iterable<String>, Completer) get inviteToChannel;

  factory InviteToChannelViewModel(
          [void Function(InviteToChannelViewModelBuilder) updates]) =
      _$InviteToChannelViewModel;

  static InviteToChannelViewModel Function(Store<AppState> store) fromStore(
      String channelId) {
    return (Store<AppState> store) {
      final selectedGroup = store.state.selectedGroupId;
      final channel = store.state.groups[selectedGroup].channels[channelId];

      // Filter out any user that is already part of the channel
      final newUsers = store.state.groupUsers
          .where((user) => !channel.users.any((u) => u.id == user.uid));

      return InviteToChannelViewModel((vm) => vm
        ..newUsers.replace(newUsers)
        ..inviteToChannel = (users, completer) =>
            store.dispatch(InviteToChannelAction(users, channel, completer)));
    };
  }
}
