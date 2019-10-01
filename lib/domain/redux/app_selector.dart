import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";

Channel getSelectedChannel(AppState state) {
  if (state.selectedGroupId == null) return null;
  if (state.channelState.selectedChannel == null) return null;
  return state.groups[state.selectedGroupId]
      .channels[state.channelState.selectedChannel];
}
