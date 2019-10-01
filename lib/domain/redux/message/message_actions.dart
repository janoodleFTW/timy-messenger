import "package:circles_app/model/message.dart";
import "package:meta/meta.dart";

@immutable
class SendMessage {
  final String message;

  const SendMessage(
    this.message,
  );

  @override
  String toString() {
    return "SendMessage{message: $message}";
  }
}

@immutable
class UpdateAllMessages {
  final List<Message> data;

  const UpdateAllMessages(this.data);
}

@immutable
class DeleteMessage {
  final String messageId;

  const DeleteMessage(this.messageId);
}

@immutable
class EmojiReaction {
  final String emoji;
  final String messageId;

  const EmojiReaction(this.messageId, this.emoji);
}

@immutable
class RemoveEmojiReaction {
  final String messageId;

  const RemoveEmojiReaction(this.messageId);
}
