import "package:built_collection/built_collection.dart";
import "package:circles_app/model/reaction.dart";
import "package:circles_app/presentation/channel/reaction/emoji_picker.dart";
import "package:circles_app/presentation/channel/reaction/reaction_detail_data.dart";
import "package:circles_app/presentation/channel/reaction/reaction_details.dart";
import "package:flutter_test/flutter_test.dart";

main() {
  group("Reaction details tests", () {
    test("should sort reaction details as expected", () {
      final map = BuiltMap<String, Reaction>({
        "USER2": Reaction((r) => r
          ..userId = "USERID"
          ..userName = "Miguel"
          ..timestamp = DateTime.now()
          ..emoji = emojiPickerOptions[2]),
        "USER4": Reaction((r) => r
          ..userId = "USERID"
          ..userName = "Lara"
          ..timestamp = DateTime(2019)
          ..emoji = emojiPickerOptions[2]),
        "USER1": Reaction((r) => r
          ..userId = "USERID"
          ..userName = "Lily"
          ..timestamp = DateTime.now()
          ..emoji = emojiPickerOptions[1]),
        "USER5": Reaction((r) => r
          ..userId = "USERID"
          ..userName = "Droid"
          ..timestamp = DateTime.now()
          ..emoji = emojiPickerOptions[0]),
      });

      final details = toListOfReactionDetailData(map);

      expect(details, [
        ReactionDetailData((r) => r
          ..emoji = emojiPickerOptions[2]
          ..names = "Miguel, Lara"),
        ReactionDetailData((r) => r
          ..emoji = emojiPickerOptions[0]
          ..names = "Droid"),
        ReactionDetailData((r) => r
          ..emoji = emojiPickerOptions[1]
          ..names = "Lily"),
      ]);
    });
  });
}
