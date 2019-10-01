import "dart:async";

import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class RsvpHeader extends StatelessWidget {
  const RsvpHeader({
    @required this.completer,
  });

  final Completer completer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.colorMintGreen,
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              Color.fromRGBO(255, 255, 255, 0.1), BlendMode.modulate),
          image: AssetImage("assets/graphics/visual_twist_white_petrol.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButton(
            context,
            text: CirclesLocalizations.of(context).eventRsvpYes,
            textColor: Colors.white,
            solid: AppTheme.colorDarkBlue,
            rsvp: RSVP.YES,
          ),
          _buildButton(
            context,
            text: CirclesLocalizations.of(context).eventRsvpMaybe,
            rsvp: RSVP.MAYBE,
          ),
          _buildButton(
            context,
            text: CirclesLocalizations.of(context).eventRsvpNo,
            rsvp: RSVP.NO,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    context, {
    @required String text,
    @required RSVP rsvp,
    Color textColor = AppTheme.colorDarkBlue,
    Color solid = Colors.transparent,
  }) {
    final buttonWidth =
        (MediaQuery.of(context).size.width - AppTheme.appMargin * 4) / 3;
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          onTap: () {
            _submitRsvpStatus(context, rsvp);
          },
          child: Center(
            child: Text(
              text,
              style: AppTheme.buttonMediumTextStyle.apply(color: textColor),
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.colorDarkBlue,
          ),
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          color: solid),
      width: buttonWidth,
      height: 33,
    );
  }

  void _submitRsvpStatus(context, RSVP rsvp) {
    StoreProvider.of<AppState>(context).dispatch(RsvpAction(rsvp, completer));
  }
}
