import "package:built_collection/built_collection.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/message/message_actions.dart";
import "package:redux/redux.dart";

final messageReducers = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, UpdateAllMessages>(_onMessageUpdated),
];

AppState _onMessageUpdated(AppState state, UpdateAllMessages action) {
  return state.rebuild((a) => a..messagesOnScreen = ListBuilder(action.data));
}
