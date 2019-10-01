import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/presentation/login/auth_button.dart";
import "package:flutter/cupertino.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";

class AuthButtonContainer extends StatelessWidget {
  const AuthButtonContainer();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (BuildContext context, _ViewModel viewModel) {
        return AuthButton(
          buttonText: viewModel.isLoggedIn ? CirclesLocalizations.of(context).logOut : CirclesLocalizations.of(context).logIn,
          onPressedCallback: viewModel.onPressedCallback
        );
      }
    );
  }
}

class _ViewModel {
  final bool isLoggedIn;
  final Function onPressedCallback;

  _ViewModel(this.isLoggedIn, this.onPressedCallback);

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      store.state.user != null, 
      () {
        if (store.state.user != null) {
          store.dispatch(LogOutAction());
        } else {
          store.dispatch(LogIn());
        }
      }
    );
  }
}
