import "package:built_collection/built_collection.dart";
import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_selector.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/user.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'messages_list_viewmodel.g.dart';

abstract class MessagesListViewModel
    implements Built<MessagesListViewModel, MessagesListViewModelBuilder> {
  @nullable
  User get currentUser;

  BuiltList<Message> get messages;

  bool get userIsMember;

  BuiltMap<String, User> get authors;

  MessagesListViewModel._();

  factory MessagesListViewModel(
          [void Function(MessagesListViewModelBuilder) updates]) =
      _$MessagesListViewModel;

  static MessagesListViewModel fromStore(Store<AppState> store) {
    return MessagesListViewModel((m) => m
      ..messages = store.state.messagesOnScreen.toBuilder()
      ..currentUser = store.state.user?.toBuilder()
      ..authors = MapBuilder(
          store.state.groupUsers.asMap().map((k, v) => MapEntry(v.uid, v)))
      ..userIsMember = getSelectedChannel(store.state)?.users
              ?.any((u) => u.id == store.state.user.uid));
  }
}
