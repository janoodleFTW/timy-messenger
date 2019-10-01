import "package:circles_app/circles_localization.dart";
import "package:flutter/widgets.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";

enum AccessResourceType { CAMERA, STORAGE }

showNoAccessAlert({
  AccessResourceType type,
  BuildContext context,
}) {
  final dialog = PlatformAlertDialog(
    title: Text(CirclesLocalizations.of(context).platformAlertAccessTitle),
    content:
        Text(CirclesLocalizations.of(context).platformAlertAccessBody(type)),
    actions: <Widget>[
      PlatformDialogAction(
          child: PlatformText(CirclesLocalizations.of(context).ok),
          onPressed: () {
            Navigator.pop(context);
          }),
    ],
  );

  return showPlatformDialog(
    context: context,
    builder: (_) => dialog,
  );
}

/// Present PlatformDialog for fetures yet to implement.
showSoonAlert({BuildContext context}) {
  final actions = [
    PlatformDialogAction(
      child: PlatformText(CirclesLocalizations.of(context).cancel),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  ];

  return showPlatformDialog(
    context: context,
    builder: (_) => PlatformAlertDialog(
      title: Text(CirclesLocalizations.of(context).genericSoonAlertTitle),
      content: Text(CirclesLocalizations.of(context).genericSoonAlertMessage),
      actions: actions,
    ),
  );
}
