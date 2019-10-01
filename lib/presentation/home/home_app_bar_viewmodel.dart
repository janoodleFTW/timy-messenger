import "package:built_value/built_value.dart";
import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/util/date_formatting.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'home_app_bar_viewmodel.g.dart';

abstract class HomeAppBarViewModel
    implements Built<HomeAppBarViewModel, HomeAppBarViewModelBuilder> {
  HomeAppBarViewModel._();

  factory HomeAppBarViewModel(
          [void Function(HomeAppBarViewModelBuilder) updates]) =
      _$HomeAppBarViewModel;

  bool get hasUpdatedChannelsInGroup;

  String get title;

  bool get memberOfChannel;

  bool get isEvent;

  String get eventDate;

  static Function(Store<AppState>) fromStore(context) {
    return (Store<AppState> store) {
      final channel = getSelectedChannel(store.state);
      final groupId = store.state.selectedGroupId;
      final channels = store.state.groups[groupId].channels.values.toList();
      final hasGroupUpdates =
          channels.any((c) => (c != channel) && c.hasUpdates);

      final isMemberOfChannel =
          channel.users.any((u) => u.id == store.state.user.uid);

      return HomeAppBarViewModel((vm) {
        return vm
          ..title = channel.name
          ..memberOfChannel = isMemberOfChannel
          ..hasUpdatedChannelsInGroup = hasGroupUpdates
          ..isEvent = channel.type == ChannelType.EVENT
          ..eventDate = _formatDate(context, channel);
      });
    };
  }

  static String _formatDate(context, Channel channel) {
    if (channel.startDate == null) {
      return "";
    }
    try {
      if (channel.hasStartTime) {
        return "${formatDate(context, channel.startDate)} "
            "${CirclesLocalizations.of(context).at} "
            "${formatTime(context, channel.startDate)}";
      } else {
        return formatDate(context, channel.startDate);
      }
    } catch (error) {
      return "";
    }
  }
}
