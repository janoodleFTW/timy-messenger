import "package:built_collection/built_collection.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/reaction.dart";
import "package:flutter_test/flutter_test.dart";

main() {
  group("Message Model", () {
    final message = Message((m) => m
      ..body = ""
      ..authorId = "USERID"
      ..reactions = BuiltMap.of({
        "USER1": Reaction((r) => r
          ..emoji = "❤️"
          ..userId = "USERID"
          ..timestamp = DateTime.now()
          ..userName = "USERNAME"),
        "USER2": Reaction((r) => r
          ..emoji = "❤️"
          ..userId = "USERID"
          ..timestamp = DateTime.now()
          ..userName = "USERNAME"),
        "USER3": Reaction((r) => r
          ..emoji = "😂"
          ..userId = "USERID"
          ..timestamp = DateTime.now()
          ..userName = "USERNAME"),
      }).toBuilder());

    test("should count emoji in reactions", () {
      final reactions = message.reactionsCount();
      expect(reactions, {
        "😂": 1,
        "❤️": 2,
      });
    });
  });
}
