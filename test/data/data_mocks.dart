import "package:built_collection/built_collection.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/model/user.dart";

final mockUser = User((u) => u
  ..uid = "userId"
  ..name = "name"
  ..email = "email");

final mockChannelUser = ChannelUser((u) => u
  ..id = "userId"
  ..rsvp = RSVP.UNSET);

final mockChannel = Channel((c) => c
  ..id = "channelId"
  ..name = "name"
  ..visibility = ChannelVisibility.OPEN
  ..type = ChannelType.EVENT
  ..startDate = DateTime(3000, 1, 1)
  ..hasUpdates = false
  ..users = ListBuilder([mockChannelUser]));

final mockGroup = Group((g) => g
  ..id = "groupdId"
  ..name = "group"
  ..channels.replace({"channelId": mockChannel})
  ..abbreviation = "g"
  ..hexColor = ""
  ..image = "");
