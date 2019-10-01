import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'channel_screen_viewmodel.g.dart';

abstract class ChannelScreenViewModel
    implements Built<ChannelScreenViewModel, ChannelScreenViewModelBuilder> {
  bool get isAuthor;

  bool get userIsMember;

  String get groupId;

  Channel get channel;

  User get user;

  bool get failedToJoin;

  RSVP get rsvpStatus;

  ChannelScreenViewModel._();

  factory ChannelScreenViewModel(
          [void Function(ChannelScreenViewModelBuilder) updates]) =
      _$ChannelScreenViewModel;

  static ChannelScreenViewModel fromStore(Store<AppState> store) {
    final selectedChannel = getSelectedChannel(store.state);
    final hasSelectedChannel = selectedChannel != null;
    final channelUser = selectedChannel
        ?.users
        ?.firstWhere((u) => u.id == store.state.user.uid, orElse: () => null);

    return ChannelScreenViewModel((v) => v
      ..isAuthor =
          selectedChannel.authorId == store.state.user.uid
      ..userIsMember = hasSelectedChannel && channelUser != null
      ..groupId = hasSelectedChannel ? store.state.selectedGroupId : ""
      ..channel = selectedChannel.toBuilder()
      ..user = store.state.user.toBuilder()
      ..failedToJoin = store.state.channelState.joinChannelFailed
      ..rsvpStatus = channelUser?.rsvp ?? RSVP.UNSET);
  }
}
