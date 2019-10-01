import "dart:async";

import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/domain/redux/user/user_actions.dart";
import "package:circles_app/domain/redux/user/user_middleware.dart";
import "package:circles_app/model/user.dart";
import "package:flutter_test/flutter_test.dart";
import "package:matcher/matcher.dart";
import "package:mockito/mockito.dart";
import "package:redux/redux.dart";

import "../redux_mocks.dart";

main() {
  group("User Middleware", () {
    final userRepo = MockUserRepository();
    final captor = MockMiddleware();
    final user = User((u) => u
      ..uid = "ID"
      ..name = "NAME"
      ..email = "EMAIL");
    final store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: createUserMiddleware(userRepo)..add(captor),
    );

    test("Should update user", () {
      final controller = StreamController<User>(sync: true);
      when(userRepo.getUserStream("ID")).thenAnswer((_) => controller.stream);

      store.dispatch(OnAuthenticated(user: user));
      controller.add(user);

      verify(
        captor.call(
          any,
          TypeMatcher<OnUserUpdateAction>(),
          any,
        ) as dynamic,
      );

      controller.close();
    });
  });
}
