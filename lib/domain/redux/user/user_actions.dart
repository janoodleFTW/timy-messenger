import "dart:async";

import "package:circles_app/model/user.dart";
import "package:meta/meta.dart";

@immutable
class UsersUpdateAction {
  final List<User> users;

  const UsersUpdateAction(this.users);
}

@immutable
class OnUserUpdateAction {
  final User user;

  const OnUserUpdateAction(this.user);
}

@immutable
class UpdateUserLocaleAction {
  final String locale;

  const UpdateUserLocaleAction(this.locale);
}

@immutable
class UpdateUserAction {
  final User user;
  final Completer completer;

  const UpdateUserAction(this.user, this.completer);
}
