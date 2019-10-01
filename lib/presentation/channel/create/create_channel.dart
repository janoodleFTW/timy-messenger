import "dart:async";

import "package:built_collection/built_collection.dart";
import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/common/color_label_text_form_field.dart";
import "package:circles_app/presentation/common/common_app_bar.dart";
import "package:circles_app/presentation/common/error_label_text_form_field.dart";
import "package:circles_app/presentation/user/user_item.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/painting.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";

class CreateChannelScreen extends StatefulWidget {
  @override
  _CreateChannelScreenState createState() => _CreateChannelScreenState();
}

class _CreateChannelScreenState extends State<CreateChannelScreen> {
  final _nameController = TextEditingController();
  final _purposeController = TextEditingController();
  final Set<String> _selectedUsers = Set();
  ChannelVisibility _visibility = ChannelVisibility.OPEN;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _purposeController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _createChannelForm(context),
    );
  }

  Widget _buildAppBar(context) {
    return CommonAppBar(
      title: CirclesLocalizations.of(context).channelFormCreateTopic,
      action: FlatButton(
          key: Key("Create"),
          child: Text(
            CirclesLocalizations.of(context).channelCreateButton,
            style: AppTheme.buttonTextStyle,
          ),
          onPressed: () {
            _validateAndSubmit();
          }),
    );
  }

  Widget _createChannelForm(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      builder: (context, _vm) => listForm(_vm),
      converter: _ViewModel.fromStore,
    );
  }

  Widget listForm(_ViewModel vm) {
    final nameInput = Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin,
      ),
      child: ErrorLabelTextFormField(
          key: Key("TopicName"),
          maxCharacters: 30,
          labelText: CirclesLocalizations.of(context).channelFormTopicName,
          helperText:
              CirclesLocalizations.of(context).channelFormCreateTopicEmptyError,
          controller: _nameController,
          validator: (value) {
            if (value.isEmpty) {
              return CirclesLocalizations.of(context)
                  .channelFormCreateTopicEmptyError;
            }
            return null;
          }),
    );

    final purposeInput = Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin,
      ),
      child: ColorLabelTextFormField(
        key: Key("Purpose"),
        labelText: CirclesLocalizations.of(context).channelFormTopicDescription,
        helperText:
            CirclesLocalizations.of(context).channelFormTopicDescriptionHelper,
        controller: _purposeController,
      ),
    );

    final users = _visibility == ChannelVisibility.CLOSED ? vm.groupUsers : [];

    return Form(
      key: _key,
      child: Container(
        child: ListView.custom(
          childrenDelegate: SliverChildListDelegate(
            <Widget>[
              nameInput,
              purposeInput,
              _buildSwitch(),
              _buildInviteUsersHeader(),
              ...users.map((user) => UserItem(
                    user: user,
                    selected: _selectedUsers.contains(user.uid),
                    selectionHandler: _selectUser,
                  )),
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  Padding _buildSwitch() {
    final _switchWidth = 60.0;
    final visibilitySwitch = Padding(
      padding: EdgeInsets.only(
        top: 24.0,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin,
        bottom: 24.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  CirclesLocalizations.of(context).channelFormCreateTopicPublic,
                  style: AppTheme.switchTitleTextStyle,
                ),
                SizedBox(height: 4),
                Text(
                  CirclesLocalizations.of(context)
                      .channelFormCreateTopicPublicHelper,
                  style: AppTheme.switchSubtitleTextStyle,
                ),
              ],
            ),
          ),
          Container(
              width: _switchWidth,
              child: PlatformSwitch(
                key: Key("Visibility"),
                value: _visibility == ChannelVisibility.OPEN,
                onChanged: (bool value) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _visibility = value
                        ? ChannelVisibility.OPEN
                        : ChannelVisibility.CLOSED;
                  });
                },
              )),
        ],
      ),
    );
    return visibilitySwitch;
  }

  Widget _buildInviteUsersHeader() {
    return Visibility(
      visible: _visibility == ChannelVisibility.CLOSED,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppTheme.appMargin),
            child: Image.asset(
              "assets/graphics/channel/details_padlock.png",
              height: 36,
            ),
          ),
          Expanded(
            child: Text(
              CirclesLocalizations.of(context)
                  .channelFormCreateTopicPrivateHelper,
              style: AppTheme.topicDetailsItemTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  void _selectUser(User user) {
    setState(() {
      if (_selectedUsers.contains(user.uid)) {
        _selectedUsers.remove(user.uid);
      } else {
        _selectedUsers.add(user.uid);
      }
    });
  }

  void _validateAndSubmit() {
    if (_key.currentState.validate()) {
      List<String> invitedIds = [];
      if (_visibility == ChannelVisibility.CLOSED) {
        invitedIds = _selectedUsers.toList();
        if (invitedIds.length == 0) {
          _showAlert(
            context,
            CirclesLocalizations.of(context).channelCreateTitle,
            CirclesLocalizations.of(context).channelFormSelectMembersError,
          );
          return;
        }
      }

      final completer = Completer();
      completer.future.then((val) {
        Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
      }).catchError((error) {
        Logger.w("Could not create channel, $error");
        _showAlert(
          context,
          CirclesLocalizations.of(context).channelCreateTitle,
          CirclesLocalizations.of(context).channelFormTopicExists,
        );
      });

      final provider = StoreProvider.of<AppState>(context);
      provider.dispatch(
        CreateChannel(
          Channel((c) => c
            ..type = ChannelType.TOPIC
            ..name = _nameController.text
            ..description = _purposeController.text ?? ""
            ..visibility = _visibility
            ..authorId = provider.state.user.uid),
          BuiltList<String>(invitedIds),
          completer,
        ),
      );
    }
  }

  void _showAlert(
    BuildContext context,
    String title,
    String content,
  ) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          PlatformDialogAction(
              child: PlatformText(CirclesLocalizations.of(context).ok),
              onPressed: () {
                // UI clean up
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}

class _ViewModel {
  final List<String> channels;
  final List<User> groupUsers;

  const _ViewModel({
    this.channels,
    this.groupUsers,
  });

  bool hasChannelNamed(String name) {
    return channels.contains(name.toLowerCase());
  }

  static _ViewModel fromStore(Store<AppState> store) {
    final state = store.state;
    var channels;
    if (state.selectedGroupId != null &&
        state.groups[state.selectedGroupId] != null) {
      final channelNames = state.groups[state.selectedGroupId].channels.values
          .map((c) => c.name.toLowerCase())
          .toList();
      channels = channelNames ?? [];
    }

    final users = state.groupUsers.toList();
    users.remove(state.user);

    return _ViewModel(
      channels: channels,
      groupUsers: users,
    );
  }
}
