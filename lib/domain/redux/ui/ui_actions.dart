import "package:meta/meta.dart";

class UpdatedChatDraftAction {
  final String text;
  final String groupId;
  final String channelId;

  const UpdatedChatDraftAction({
    @required this.text,
    @required this.groupId,
    @required this.channelId,
  });

  @override
  String toString() {
    return "UpdatedChatDraftAction{text: $text, groupId: $groupId, channelId: $channelId}";
  }
}
