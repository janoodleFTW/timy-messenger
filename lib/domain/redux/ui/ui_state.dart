import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'ui_state.g.dart';

///
/// Store different UI related data (last selected channel, channel input text, etc.)
///
///
abstract class UiState implements Built<UiState, UiStateBuilder> {


  // Group UI state per group id
  BuiltMap<String, GroupUiState> get groupUiState;

  UiState._();
  factory UiState([void Function(UiStateBuilder) updates]) = _$UiState;
}

///
/// Store UI related data per group
///
abstract class GroupUiState implements Built<GroupUiState, GroupUiStateBuilder> {
  // When a user changes groups, pick the last selected channel if present
  @nullable
  String get lastSelectedChannel;

  // Channel UI state per channel id
  BuiltMap<String, ChannelUiState> get channelUiState;

  GroupUiState._();
  factory GroupUiState([void Function(GroupUiStateBuilder) updates]) = _$GroupUiState;
}

///
/// Store UI related data per channel
///
abstract class ChannelUiState implements Built<ChannelUiState, ChannelUiStateBuilder> {

  @nullable
  String get inputDraft;

  ChannelUiState._();
  factory ChannelUiState([void Function(ChannelUiStateBuilder) updates]) = _$ChannelUiState;
}
