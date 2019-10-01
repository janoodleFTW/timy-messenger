import "package:built_value/built_value.dart";

// ignore: prefer_double_quotes
part 'channel_state.g.dart';

abstract class ChannelState
    implements Built<ChannelState, ChannelStateBuilder> {
  @nullable
  String get selectedChannel;

  bool get joinChannelFailed;

  ChannelState._();

  factory ChannelState([void Function(ChannelStateBuilder) updates]) =
      _$ChannelState;

  factory ChannelState.init() => ChannelState((c) => c
    ..selectedChannel = null
    ..joinChannelFailed = false);
}
