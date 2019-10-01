import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/user/user_actions.dart";
import "package:circles_app/model/user.dart";
import "package:flutter_test/flutter_test.dart";
import "package:redux/redux.dart";

main() {
  group("User Reducer", () {
    // Ids of user and userOld are the same
    final user = User((u) => u
      ..uid = "userId"
      ..name = "name"
      ..image = "imageUrl"
      ..status = "myStatus"
      ..email = "my@example.com");

    final userOld = User((u) => u
      ..uid = "userId"
      ..name = "nameOld"
      ..image = "imageUrlOld"
      ..status = "myStatusOld"
      ..email = "my@example.com");

    test("should update user when state empty", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      expect(store.state.user, null);
      expect(store.state.groupUsers.contains(user), false);
      store.dispatch(OnUserUpdateAction(user));
      expect(store.state.user, user);
      expect(store.state.groupUsers.contains(user), true);
    });

    test("should update user when state has data", () {
      final store = Store<AppState>(
        appReducer,
        initialState: AppState.init(),
      );

      // Load old user first
      store.dispatch(OnUserUpdateAction(userOld));
      expect(store.state.user, userOld);
      expect(store.state.groupUsers.contains(userOld), true);
      expect(store.state.groupUsers.contains(user), false);

      // Update user (e.g. changes status or name)
      store.dispatch(OnUserUpdateAction(user));
      expect(store.state.user, user);
      expect(store.state.groupUsers.contains(userOld), false);
      expect(store.state.groupUsers.contains(user), true);
    });
  });
}
