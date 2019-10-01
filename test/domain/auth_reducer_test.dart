import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/model/user.dart";
import "package:redux/redux.dart";
import "package:test/test.dart";

main() {
  group("State Reducer", () {
    Store<AppState> _testStore;
    final _testUser = User((u) => u
      ..uid = "UID"
      ..name = "NAME"
      ..email = "EMAIL");

    setUp(() {
      _testStore = Store<AppState>(appReducer, initialState: AppState.init());
    });

    test("should load user OnAuthenticated into store", () {
      expect(_testStore.state.user, null);
      _testStore.dispatch(OnAuthenticated(user: _testUser));
      expect(_testStore.state.user, _testUser);
    });

    test("should remove user OnLogoutSuccess from store", () {
      _testStore.dispatch(OnAuthenticated(user: _testUser));
      _testStore.dispatch(OnLogoutSuccess());
      expect(_testStore.state.user, null);
    });
  });
}
