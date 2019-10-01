import "dart:async";

import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/channel/invite/invite_to_channel_viewmodel.dart";
import "package:circles_app/presentation/common/common_app_bar.dart";
import "package:circles_app/presentation/user/user_item.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class InviteToChannelScreen extends StatefulWidget {
  @override
  _InviteToChannelScreenState createState() => _InviteToChannelScreenState();
}

class _InviteToChannelScreenState extends State<InviteToChannelScreen> {
  final _selectedUsers = <String>[];

  @override
  Widget build(BuildContext context) {
    final String channelId = ModalRoute.of(context).settings.arguments;

    return StoreConnector<AppState, InviteToChannelViewModel>(
      distinct: true,
      converter: InviteToChannelViewModel.fromStore(channelId),
      builder: (context, vm) {
        return Scaffold(
          appBar: _buildAppBar(context, vm),
          body: _buildUsersList(context, vm),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, InviteToChannelViewModel vm) {
    return CommonAppBar(
      title: CirclesLocalizations.of(context).channelInviteTitle,
      action: Visibility(
        visible: _selectedUsers.isNotEmpty,
        child: FlatButton(
          child: Text(
            CirclesLocalizations.of(context).invite,
            style: AppTheme.buttonTextStyle,
          ),
          onPressed: () {
            _validateAndSubmit(vm);
          },
        ),
      ),
    );
  }

  void _validateAndSubmit(InviteToChannelViewModel vm) {
    final completer = Completer();
    completer.future.whenComplete(() {
      Navigator.of(context).pop();
    });
    vm.inviteToChannel(_selectedUsers, completer);
  }

  Widget _buildUsersList(BuildContext context, InviteToChannelViewModel vm) {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: vm.newUsers.length,
      itemBuilder: (BuildContext context, int index) {
        final member = vm.newUsers[index];
        return UserItem(
          user: member,
          selected: _selectedUsers.contains(member.uid),
          selectionHandler: (User user) {
            setState(() {
              if (_selectedUsers.contains(user.uid)) {
                _selectedUsers.remove(user.uid);
              } else {
                _selectedUsers.add(user.uid);
              }
            });
          },
        );
      },
    );
  }
}
