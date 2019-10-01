import "dart:async";
import "package:circles_app/model/user.dart";
import "package:meta/meta.dart";

// Authentication
class VerifyAuthenticationState {}

class LogIn {
  final String email;
  final String password;
  final Completer completer;

  LogIn({this.email, this.password, Completer completer})
      : completer = completer ?? Completer();
}

@immutable
class OnAuthenticated {
  final User user;

  const OnAuthenticated({@required this.user});

  @override
  String toString() {
    return "OnAuthenticated{user: $user}";
  }
}

class LogOutAction {}

class OnLogoutSuccess {
  OnLogoutSuccess();

  @override
  String toString() {
    return "LogOut{user: null}";
  }
}

class OnLogoutFail {
  final dynamic error;

  OnLogoutFail(this.error);

  @override
  String toString() {
    return "OnLogoutFail{There was an error logging in: $error}";
  }
}
