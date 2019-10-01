import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class JoinChannel extends StatelessWidget {
  final String _groupId;
  final Channel _channel;
  final User _user;

  const JoinChannel(this._groupId, this._channel, this._user);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Column(
                children: <Widget>[
                  Container(
                    child: Text(
                        CirclesLocalizations.of(context).channelJoinMessage),
                  ),
                  Container(
                      child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Text(CirclesLocalizations.of(context).channelJoin),
                    onPressed: () {
                      StoreProvider.of<AppState>(context)
                          .dispatch(JoinChannelAction(groupId: _groupId, channel: _channel, user: _user));
                    },
                  ))
                ],
              )),
            ],
          ),
        ));
  }
}
