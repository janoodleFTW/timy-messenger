import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/message/message_actions.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/user.dart";
import "package:flutter_test/flutter_test.dart";
import "package:redux/redux.dart";

main() {
  group("Message Reducer", () {
    final user = User((u) => u
      ..uid = "ID"
      ..name = "NAME"
      ..email = "EMAIL");
    final message = Message((m) => m
      ..id = "ID"
      ..body = "BODY"
      ..authorId = "authorId");

    test("should update messages", () {
      final store = Store<AppState>(
        appReducer,
        initialState:
            AppState.init().rebuild((a) => a..user = user.toBuilder()),
      );
      expect(store.state.messagesOnScreen.isEmpty, true);
      store.dispatch(UpdateAllMessages([message]));
      expect(store.state.messagesOnScreen, [message]);
    });
  });
}
