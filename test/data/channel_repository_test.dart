import "package:built_collection/built_collection.dart";
import "package:circles_app/data/channel_repository.dart";
import "package:circles_app/model/channel.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "FirestoreMocks.dart";

main() {
  group("Channels Repository", () {
    final channel = Channel((c) => c
      ..type = ChannelType.TOPIC
      ..id = "ID"
      ..name = "CHANNEL"
      ..description = "DESC"
      ..visibility = ChannelVisibility.OPEN
      ..users = ListBuilder<ChannelUser>()
      ..hasUpdates = false);

    test("shoul map invite", () async {
      final channelUser = ChannelUser((cu) => cu
        ..id = "CUID"
        ..rsvp = RSVP.UNSET);
      final inviteMap = ChannelRepository.toChannelUserInviteMap(
          user: channelUser,
          channel: channel,
          invitingUsername: "ANDY PIPKIN",
          groupName: "TEST GROUP");

      expect(inviteMap, {
        "uid": "CUID",
        "invitation": true,
        "rsvp": "UNSET",
        "metadata": {
          "channel_name": "CHANNEL",
          "visibility": "OPEN",
          "type": "TOPIC",
          "group_name": "TEST GROUP",
          "inviting_user": "ANDY PIPKIN",
        }
      });
    });

    test("should map Channel to Map<String, String>", () async {
      final map = ChannelRepository.toMap(channel, ["MEMBERID1", "MEMBERID2"]);
      expect(map["name"], "CHANNEL");
      expect(map["start_date"], null);
      expect(map["has_start_time"], null);
      expect(map["venue"], null);
      expect(map["visibility"], "OPEN");
      expect(map["description"], "DESC");
      expect(map["authorId"], "");
      expect(map["type"], "TOPIC");
      expect(map["invited_members"], ["MEMBERID1", "MEMBERID2"]);
    });

    test(
        "should map Channel with startDate and startTime to Map<String, String>",
        () async {
      final map = ChannelRepository.toMap(
          channel.rebuild((c) => c
            ..startDate = DateTime(2019, 07, 01, 20, 30)
            ..hasStartTime = true),
          []);

      expect(map["name"], "CHANNEL");
      expect(map["start_date"],
          Timestamp.fromDate(DateTime.parse("2019-07-01T20:30:00.000")));
      expect(map["has_start_time"], true);
      expect(map["venue"], null);
      expect(map["visibility"], "OPEN");
      expect(map["description"], "DESC");
      expect(map["authorId"], "");
      expect(map["invited_members"], []);
    });

    test("should map DocumentSnapshot to Channel", () {
      final document = MockDocumentSnapshot();
      when(document["name"]).thenReturn("CHANNEL");
      when(document["visibility"]).thenReturn("OPEN");
      when(document["description"]).thenReturn("DESC");
      when(document.documentID).thenReturn("ID");
      final outChannel = ChannelRepository.fromDocWithUsers(
        doc: document,
        users: BuiltList<ChannelUser>(),
      );
      expect(outChannel, channel);
    });
  });
}
