import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/ui/ui_state.dart";
import "package:flutter/foundation.dart";


/// Returns the stored channel input given the current AppState
///
/// Returns null if:
/// * there is no selected group (unlikely)
/// * there is no selected channel (unlikely)
/// * there's no previous group UI state (likely)
/// * there's no previous channel UI state (likely)
String getInputDraftSelectedChannel(AppState appState) {
  if (appState.selectedGroupId == null) return null;
  if (appState.channelState.selectedChannel == null) return null;
  final groupUiState = appState.uiState.groupUiState[appState.selectedGroupId];
  if (groupUiState == null) return null;
  final channelUiState =
      groupUiState.channelUiState[appState.channelState.selectedChannel];
  if (channelUiState == null) return null;
  return channelUiState.inputDraft;
}

/// Rebuilds the [UiState] for a [Group] in the [UiState]
///
/// Applies the given [update] to the existing [GroupUiState]
/// Otherwise creates a new [GroupUiState]
UiStateBuilder updateGroupUiState({
  @required UiStateBuilder state,
  @required String groupId,
  @required GroupUiStateBuilder Function(GroupUiStateBuilder) update,
}) {
  state.groupUiState.updateValue(
    groupId,
    (g) => g.rebuild(update),
    ifAbsent: () => GroupUiState(update),
  );
  return state;
}

/// Rebuilds the [ChannelUiState] for a [Channel] in a [GroupUiState]
///
/// Applies the given [update] to the existing [ChannelUiState]
/// Otherwise creates a new [ChannelUiState]
GroupUiStateBuilder updateChannelUiState({
  @required GroupUiStateBuilder state,
  @required String channelId,
  @required ChannelUiStateBuilder Function(ChannelUiStateBuilder) update,
}) {
  state.channelUiState.updateValue(
    channelId,
    (g) => g.rebuild(update),
    ifAbsent: () => ChannelUiState(update),
  );
  return state;
}

/// Updates the text input for a [ChannelUiState]
///
/// Applies the given text input value to the existing [ChannelUiState]
/// Otherwise creates a new [ChannelUiState]
UiStateBuilder updateInputDraft({
  @required UiStateBuilder state,
  @required String groupId,
  @required String channelId,
  @required String value,
}) {
  final GroupUiStateBuilder Function(GroupUiStateBuilder value) updateGroup =
      (g) => updateChannelUiState(
            state: g,
            channelId: channelId,
            update: (c) => c..inputDraft = value,
          );

  return updateGroupUiState(
    state: state,
    groupId: groupId,
    update: updateGroup,
  );
}
