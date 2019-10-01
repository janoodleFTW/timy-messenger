import "dart:async";

import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/attachment/attachment_actions.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/domain/redux/user/user_actions.dart";
import "package:circles_app/presentation/common/common_app_bar.dart";
import "package:circles_app/presentation/common/error_label_text_form_field.dart";
import "package:circles_app/presentation/common/modal_item.dart";
import "package:circles_app/presentation/common/round_button.dart";
import "package:circles_app/presentation/user/profile_avatar.dart";
import "package:circles_app/presentation/user/user_screen_viewmodel.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:image_picker/image_picker.dart";

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _editMode = false;
  final _controllerName = TextEditingController();
  final _controllerStatus = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _controllerName.dispose();
    _controllerStatus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userId = ModalRoute.of(context).settings.arguments;

    return StoreConnector<AppState, UserScreenViewModel>(
      builder: (context, vm) => _buildScaffold(context, vm),
      converter: UserScreenViewModel.fromStore(userId),
      distinct: true,
      onInitialBuild: _setInitialEditState,
    );
  }

  void _setInitialEditState(UserScreenViewModel vm) {
    _controllerName.text = vm.user.name;
    _controllerStatus.text = vm.user.status ?? "";
  }

  Scaffold _buildScaffold(context, UserScreenViewModel vm) {
    return Scaffold(
      appBar: CommonAppBar(
        title: vm.user.name,
        leftAction: _buildLeftAction(vm),
        action: _buildRightAction(vm),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            _buildUserAvatar(vm),
            ..._buildUserSection(vm),
            ..._buildEditSection(vm),
            _buildDirectMessageButton(vm, context),
            _buildLogoutButton(vm, context),
          ],
        ),
      ),
    );
  }

  _buildLeftAction(UserScreenViewModel vm) =>
      _editMode ? _buildCancelButton(vm) : null;

  Widget _buildCancelButton(UserScreenViewModel vm) {
    return FlatButton(
        child: Text(
          "Cancel",
          style: AppTheme.buttonTextStyle,
        ),
        onPressed: () {
          _setInitialEditState(vm);
          setState(() {
            _editMode = false;
          });
        });
  }

  Widget _buildRightAction(UserScreenViewModel vm) {
    return Visibility(
      visible: vm.isYou,
      child: AnimatedSwitcher(
        child: _editMode ? _buildSaveButton(vm) : _buildEditButton(),
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  FlatButton _buildSaveButton(UserScreenViewModel vm) {
    return FlatButton(
        child: Text(
          CirclesLocalizations.of(context).save,
          style: AppTheme.buttonTextStyle,
        ),
        onPressed: () {
          _validateAndSubmit(vm);
        });
  }

  FlatButton _buildEditButton() {
    return FlatButton(
        child: Text(
          CirclesLocalizations.of(context).edit,
          style: AppTheme.buttonTextStyle,
        ),
        onPressed: () {
          setState(() {
            _editMode = true;
          });
        });
  }

  Widget _buildUserAvatar(UserScreenViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ProfileAvatar(
        pictureIconButton: _buildPictureIconButton(vm),
        user: vm.user,
      ),
    );
  }

  Widget _buildPictureIconButton(UserScreenViewModel vm) {
    return Visibility(
      visible: vm.isYou && !_editMode,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: InkWell(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: ModalItem(
                      iconAsset: "assets/graphics/input/icon_pictures.png",
                      label: CirclesLocalizations.of(context).attachModalGallery,
                    ),
                    onPressed: () {
                      _changeUserAvatar(ImageSource.gallery, context, vm);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: ModalItem(
                      iconAsset: "assets/graphics/input/icon_camera.png",
                      label: CirclesLocalizations.of(context).attachModalCamera,
                    ),
                    onPressed: () {
                      _changeUserAvatar(ImageSource.camera, context, vm);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: ModalItem(
                      iconData: Icons.delete_outline,
                      label: CirclesLocalizations.of(context).delete,
                    ),
                    onPressed: () {
                      _removeUserAvatar(context, vm);
                    },
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Container(
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/graphics/input/icon_camera.png"),
            ),
          ),
        ),
      ),
    );
  }

  Future _changeUserAvatar(
    ImageSource source,
    BuildContext context,
    UserScreenViewModel vm,
  ) async {
    // NOTE: The whole avatar upload will be redone once we have the proper UI
    final imageFile = await ImagePicker.pickImage(source: source);
    StoreProvider.of<AppState>(context).dispatch(ChangeAvatarAction(
      file: imageFile,
      user: vm.user,
    ));
    await Navigator.of(context).maybePop();
  }

  Future _removeUserAvatar(
    BuildContext context,
    UserScreenViewModel vm,
  ) async {
    StoreProvider.of<AppState>(context).dispatch(
        UpdateUserAction(vm.user.rebuild((u) => u..image = null), Completer()));
    await Navigator.of(context).maybePop();
  }

  List<Widget> _buildUserSection(UserScreenViewModel vm) {
    if (_editMode) return [];
    return [
      Text(
        vm.user.name,
        style: AppTheme.messageAuthorNameTextStyle,
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: const EdgeInsets.only(top: AppTheme.appMargin),
        child: Text(
          vm.user.status ?? "",
          style: AppTheme.messageTextStyle,
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  List<Widget> _buildEditSection(UserScreenViewModel vm) {
    if (!_editMode) return [];
    return [
      Padding(
        padding: const EdgeInsets.all(AppTheme.appMargin),
        child: ErrorLabelTextFormField(
          labelText: CirclesLocalizations.of(context).userEditNameLabel,
          helperText: CirclesLocalizations.of(context).userEditNameHelper,
          maxCharacters: 30,
          controller: _controllerName,
          validator: (value) {
            if (value.isEmpty) {
              return CirclesLocalizations.of(context).userEditNameError;
            }
            return null;
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(AppTheme.appMargin),
        child: ErrorLabelTextFormField(
          labelText: CirclesLocalizations.of(context).userEditStatusLabel,
          helperText: CirclesLocalizations.of(context).userEditStatusHelper,
          controller: _controllerStatus,
          maxCharacters: 200,
          validator: (value) {
            return null;
          },
        ),
      )
    ];
  }

  Visibility _buildDirectMessageButton(UserScreenViewModel vm, context) {
    return Visibility(
      visible: !vm.isYou,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.appMargin),
        child: Center(
          child: RoundButton(
            text: CirclesLocalizations.of(context).sendDirectMessage,
            onTap: () {
              showPlatformDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                  title: Text(
                      CirclesLocalizations.of(context).genericSoonAlertTitle),
                  content: Text(
                      CirclesLocalizations.of(context).genericSoonAlertMessage),
                  actions: <Widget>[
                    PlatformDialogAction(
                        child: PlatformText(
                            CirclesLocalizations.of(context).cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(UserScreenViewModel vm, context) {
    return Visibility(
      visible: vm.isYou && !_editMode,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.appMargin),
        child: Center(
          child: RoundButton(
            text: "Logout",
            onTap: () {
              showPlatformDialog(
                context: context,
                builder: (context) => PlatformAlertDialog(
                  content: Text(CirclesLocalizations.of(context).logOut),
                  actions: <Widget>[
                    PlatformDialogAction(
                      child:
                          PlatformText(CirclesLocalizations.of(context).cancel),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    PlatformDialogAction(
                      child:
                          PlatformText(CirclesLocalizations.of(context).logOut),
                      onPressed: () {
                        StoreProvider.of<AppState>(context)
                            .dispatch(LogOutAction());
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit(UserScreenViewModel vm) {
    if (_formKey.currentState.validate()) {
      final completer = Completer();
      completer.future.whenComplete(() {
        setState(() {
          _editMode = false;
        });
      });
      vm.submit(
          vm.user.rebuild((u) => u
            ..name = _controllerName.text
            ..status = _controllerStatus.text),
          completer);
    }
  }
}
