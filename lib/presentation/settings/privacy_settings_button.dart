import "package:circles_app/circles_localization.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class PrivacySettingsButton extends StatelessWidget {
  const PrivacySettingsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(CirclesLocalizations.of(context).privacyButton),
      onPressed: () {
        launch(CirclesLocalizations.of(context).privacyLink);
      },
    );
  }
}
