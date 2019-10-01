import "package:built_collection/built_collection.dart";
import "package:circles_app/data/message_repository.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/reaction.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "FirestoreMocks.dart";

main() {
  group("Message Repository", () {
    final message = Message((m) => m
      ..id = "ID"
      ..body = "BODY"
      ..authorId = "authorId"
      ..messageType = MessageType.USER
      ..mediaStatus = MediaStatus.ERROR
      ..timestamp = DateTime(2019)
      ..reactions = BuiltMap.of({
        "USERID": Reaction((r) => r
          ..userId = "USERID"
          ..userName = "USERNAME"
          ..emoji = "EMOJI"
          ..timestamp = DateTime(2019)),
      }).toBuilder());
    final timestamp = DateTime(2019).millisecondsSinceEpoch.toString();

    test("should map Mesage to Map<String, String>", () async {
      final map = MessageRepository.toMap(message);
      expect(map, {
        "body": "BODY",
        "author": "authorId",
        "reaction": {
          "USERID": {
            "emoji": "EMOJI",
            "user_id": "USERID",
            "user_name": "USERNAME",
            "timestamp": timestamp,
          },
        },
        "type": "USER",
        "timestamp": timestamp,
      });
    });

    test("should map DocumentSnapshot to Message", () {
      final document = MockDocumentSnapshot();
      when(document.documentID).thenReturn("ID");
      when(document["body"]).thenReturn("BODY");
      when(document["author"]).thenReturn("authorId");
      when(document["reaction"]).thenReturn({
        "USERID": {
          "emoji": "EMOJI",
          "user_id": "USERID",
          "user_name": "USERNAME",
          "timestamp": timestamp,
        },
      });
      when(document["timestamp"]).thenReturn(timestamp);
      final metadata = MockSnapshotMetadata();
      when(document.metadata).thenReturn(metadata);
      when(metadata.hasPendingWrites).thenReturn(false);
      final outChannel = MessageRepository.fromDoc(document);
      expect(outChannel, message);
    });

    test("should check if invalid message", () {
      final document = MockDocumentSnapshot();
      // null author
      when(document["body"]).thenReturn("BODY");
      when(document["type"]).thenReturn("USER");
      final isValid = MessageRepository.isValidDocument(document);
      expect(false, isValid);
    });

    test("should check if valid Message", () {
      final document = MockDocumentSnapshot();
      when(document["body"]).thenReturn("BODY");
      when(document["author"]).thenReturn("authorId");
      when(document["type"]).thenReturn("USER");
      final isValid = MessageRepository.isValidDocument(document);
      expect(true, isValid);
    });

    test("should check if valid System Message", () {
      final document = MockDocumentSnapshot();
      when(document["body"]).thenReturn("BODY");
      when(document["type"]).thenReturn("SYSTEM");
      final isValid = MessageRepository.isValidDocument(document);
      expect(true, isValid);
    });
  });
}
