import "dart:io";

import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/presentation/channel/message/message_item.dart";
import "package:circles_app/presentation/channel/message/system_message_item.dart";
import "package:circles_app/presentation/channel/messages_list/messages_list_viewmodel.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class MessagesList extends StatelessWidget {
  const MessagesList({
    Key key,
    @required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        // On iOS, taping on the chat section dismisses keyboard
        if (Platform.isIOS) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: StoreConnector<AppState, MessagesListViewModel>(
        builder: (context, vm) {
          return ListView.builder(
              controller: scrollController,
              reverse: true,
              itemCount: vm.messages.length,
              itemBuilder: (context, index) {
                final message = vm.messages[index];
                return _selectMessageBuilder(message, vm);
              });
        },
        converter: MessagesListViewModel.fromStore,
        distinct: true,
      ),
    );
  }

  Widget _selectMessageBuilder(
    Message message,
    MessagesListViewModel vm,
  ) {
    switch (message.messageType) {
      case MessageType.SYSTEM:
      case MessageType.RSVP:
        return SystemMessageItem(message);
        break;
      case MessageType.USER:
      case MessageType.MEDIA:
        return MessageItem(
          message: message,
          currentUser: vm.currentUser,
          userIsMember: vm.userIsMember,
          author: vm.authors[message.authorId],
        );
        break;
      default:
        return SizedBox.shrink();
    }
  }
}
