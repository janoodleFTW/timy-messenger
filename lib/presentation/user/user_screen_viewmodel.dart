import "dart:async";

import "package:built_value/built_value.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/user/user_actions.dart";
import "package:circles_app/model/user.dart";
import "package:redux/redux.dart";

// ignore: prefer_double_quotes
part 'user_screen_viewmodel.g.dart';

abstract class UserScreenViewModel
    implements Built<UserScreenViewModel, UserScreenViewModelBuilder> {
  User get user;

  bool get isYou;

  @BuiltValueField(compare: false)
  void Function(User user, Completer completer) get submit;

  UserScreenViewModel._();

  factory UserScreenViewModel(
          [void Function(UserScreenViewModelBuilder) updates]) =
      _$UserScreenViewModel;

  static fromStore(String userId) {
    return (Store<AppState> store) {
      return UserScreenViewModel((u) => u
        ..user = _getUser(store, userId)
        ..isYou = userId == store.state.user.uid
        ..submit = (user, completer) =>
            store.dispatch(UpdateUserAction(user, completer)));
    };
  }

  static UserBuilder _getUser(Store<AppState> store, String userId) {
    return store.state.groupUsers
        .firstWhere((user) => user.uid == userId)
        .toBuilder();
  }
}
