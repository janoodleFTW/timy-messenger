import "package:circles_app/model/message.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/channel/reaction/reaction.dart";
import "package:circles_app/presentation/channel/reaction/reaction_button.dart";
import "package:circles_app/routes.dart";
import "package:flutter/material.dart";

class ReactionSection extends StatelessWidget {
  const ReactionSection({
    Key key,
    @required Message message,
    @required User currentUser,
    @required bool userIsMember,
  })  : _message = message,
        _currentUser = currentUser,
        _userIsMember = userIsMember,
        super(key: key);

  final Message _message;
  final User _currentUser;
  final bool _userIsMember;

  @override
  Widget build(BuildContext context) {
    final userEmoji = _message.reactions[_currentUser.uid];

    final list = <Widget>[];

    _message.reactionsCount().forEach((emoji, count) {
      final isUserEmoji = userEmoji?.emoji == emoji;
      list.add(Reaction(
        emoji: emoji,
        count: count,
        isUserEmoji: isUserEmoji,
        messageId: _message.id,
      ));
    });

    if (list.isNotEmpty &&
        _currentUser.uid != _message.authorId &&
        !_message.reactions.containsKey(_currentUser.uid) &&
        _userIsMember) {
      list.add(ReactionButton(_message));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onLongPress: () {
          Navigator.of(context).pushNamed(
            Routes.reaction,
            arguments: _message.reactions,
          );
        },
        // Wrap takes care of showing the each reaction one after the other
        // and when it runs out of space, will go to the next line.
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          direction: Axis.horizontal,
          children: list,
        ),
      ),
    );
  }
}
