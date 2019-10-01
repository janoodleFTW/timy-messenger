import "dart:async";
import "package:circles_app/data/user_repository.dart";
import "package:circles_app/domain/redux/app_actions.dart";
import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/domain/redux/authentication/auth_middleware.dart";
import "package:circles_app/model/user.dart";
import "package:flutter/foundation.dart";
import "package:redux/redux.dart";
import "package:mockito/mockito.dart";
import "package:test/test.dart";
import "package:flutter/widgets.dart" as w;

class MockUserRepository extends Mock implements UserRepository {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

// ignore: must_be_immutable
class MockGlobalKey extends Mock implements w.GlobalKey<w.NavigatorState> {}

class MockNavigatorState extends Mock implements w.NavigatorState {
  @override
  // ignore: invalid_override_different_default_values_named
  String toString({DiagnosticLevel minLevel}) => "";
}

main() {
  group("Authentication Middleware", () {
    MockMiddleware _captor;
    MockUserRepository _userRepository;
    Store<AppState> _store;
    MockGlobalKey _globalKey;
    MockNavigatorState _navigatorState;
    final _user = User((u) => u
      ..uid = "UID"
      ..email = "EMAIL"
      ..name = "NAME");

    setUp(() {
      _captor = MockMiddleware();
      _userRepository = MockUserRepository();
      _globalKey = MockGlobalKey();
      _navigatorState = MockNavigatorState();
      _store = Store<AppState>(appReducer,
          initialState: AppState.init(),
          middleware:
              createAuthenticationMiddleware(_userRepository, _globalKey)
                ..add(_captor));
    });

    test("should perform logOut", () {
      _store.dispatch(LogOutAction());
      verify(_userRepository.logOut());

      verify(_captor.call(
        any,
        TypeMatcher<LogOutAction>(),
        any,
      ) as dynamic);
    });

    test("should fail logOut", () {
      when(_userRepository.logOut()).thenThrow(Exception());
      _store.dispatch(LogOutAction());
      verify(_userRepository.logOut());

      verify(_captor.call(
        any,
        TypeMatcher<OnLogoutFail>(),
        any,
      ) as dynamic);
    });

    test("should conntect to datasource when authenticated", () {
      // ignore: close_sinks
      final controller = StreamController<User>(sync: true);

      when(_userRepository.getAuthenticationStateChange())
          .thenAnswer((_) => controller.stream);
      _store.dispatch(VerifyAuthenticationState());
      controller.add(_user);

      verify(_userRepository.getAuthenticationStateChange());

      verify(_captor.call(
        any,
        TypeMatcher<ConnectToDataSource>(),
        any,
      ) as dynamic);
    });

    test("should sign user in on LogIn", () {
      when(_userRepository.signIn("secret@circles.xyz", "soverysecret"))
          .thenAnswer((_) => SynchronousFuture(_user));
      when(_globalKey.currentState).thenReturn(_navigatorState);

      _store.dispatch(
          LogIn(email: "secret@circles.xyz", password: "soverysecret"));
      verify(_userRepository.signIn("secret@circles.xyz", "soverysecret"));

      verify(_captor.call(
        any,
        TypeMatcher<OnAuthenticated>(),
        any,
      ) as dynamic);
    });
  });
}
