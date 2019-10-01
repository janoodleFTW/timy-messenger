import "package:built_collection/built_collection.dart";
import "package:circles_app/model/reaction.dart";
import "package:circles_app/presentation/channel/reaction/emoji_picker.dart";
import "package:circles_app/presentation/channel/reaction/reaction_detail_data.dart";
import "package:flutter/material.dart";

class ReactionDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BuiltMap<String, Reaction> map =
        ModalRoute.of(context).settings.arguments;

    final details = toListOfReactionDetailData(map);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reactions",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, position) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: _ReactionDetail(details[position]));
        },
      ),
    );
  }
}

// Function is public so it can be tested
List<ReactionDetailData> toListOfReactionDetailData(
    BuiltMap<String, Reaction> map) {
  final details = <ReactionDetailData>[];
  final reactions = map.values;
  final List<String> emojiToDisplay = _sortEmoji(map);
  for (final emoji in emojiToDisplay) {
    // Pick all the reactions for a given emoji
    final reactionsWithEmoji =
        reactions.where((it) => it.emoji == emoji).toList();
    // Sort by timestamp (newest to oldest)
    reactionsWithEmoji.sort((a, b) =>
        b.timestamp.millisecondsSinceEpoch -
        a.timestamp.millisecondsSinceEpoch);
    // Concat all the names together
    final names = reactionsWithEmoji.fold(
        "", (p, e) => p + (p.isNotEmpty ? ", " : "") + e.userName) as String;
    // Display the reaction
    details.add(ReactionDetailData((r) => r
      ..emoji = emoji
      ..names = names));
  }
  return details;
}

/// Sort as required:
///   "most applied emoji to that message first,
///    if equal then use order of emojis in emoji picker"
///
/// See: https://github.com/janoodleFTW/flutter-app/issues/46
List<String> _sortEmoji(BuiltMap<String, Reaction> map) {
  // Count the uses per emoji
  final emojiCount = Map<String, int>();
  for (final reaction in map.values) {
    emojiCount[reaction.emoji] = (emojiCount[reaction.emoji] ?? 0) + 1;
  }

  final emojiToDisplay = emojiCount.keys.toList();
  emojiToDisplay.sort((a, b) {
    // Sort list by count (more counts first)
    final count = emojiCount[b] - emojiCount[a];
    if (count != 0) {
      return count;
    }
    // Or by position in emoji picker if not
    final pA = emojiPickerOptions.indexOf(a);
    final pB = emojiPickerOptions.indexOf(b);
    return pA - pB;
  });
  return emojiToDisplay;
}

class _ReactionDetail extends StatelessWidget {
  final ReactionDetailData _data;

  const _ReactionDetail(this._data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Text(
            _data.emoji,
            style: TextStyle(fontSize: 30),
          ),
          // Allow text to wrap
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _data.names,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
