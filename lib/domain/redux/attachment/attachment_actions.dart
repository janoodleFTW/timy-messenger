import "dart:io";

import "package:circles_app/model/user.dart";
import "package:flutter/cupertino.dart";
import "package:meta/meta.dart";

@immutable
class NewMessageWithMultipleFilesAction {
  final List<String> fileIdentifiers; // File paths in case of Android, localIdentifier in case of iOS multiselect & path in case of camera image
  final bool isPath;
  const NewMessageWithMultipleFilesAction(this.fileIdentifiers, this.isPath);
}

@immutable
class ChangeAvatarAction {
  final File file;
  final User user;

  const ChangeAvatarAction({
    @required this.file,
    @required this.user,
  });
}
