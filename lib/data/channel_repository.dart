import "dart:async";

import "package:built_collection/built_collection.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/util/logger.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/widgets.dart";

import "firestore_paths.dart";

class ChannelExistsError extends Error {}

class ChannelRepository {
  static const String NAME = "name";
  static const String VISIBILITY = "visibility";
  static const String DESCRIPTION = "description";
  static const String USERS = "users";
  static const String USERID = "uid";
  static const String HASUPDATES = "hasUpdates";
  static const String AUTHORID = "authorId";
  static const String TYPE = "type";
  static const String VENUE = "venue";
  static const String START_DATE = "start_date";
  static const String HAS_START_TIME = "has_start_time";
  static const String RSVP_FIELD = "rsvp";
  // The offset is used on backend side to send out notifications
  // with the correct time since it's stored in utc and we need
  // the offset of the event creator.
  static const String TIMEZONE_SECONDS_OFFSET = "timezone_seconds_offset";
  static const String INVITATION = "invitation";
  static const String CHANNELNAME = "channel_name";
  static const String INVITINGUSER = "inviting_user";
  static const String GROUPNAME = "group_name";
  static const String INVITEDMEMBERS = "invited_members";
  static const String METADATA = "metadata";

  final Firestore _firestore;

  const ChannelRepository(this._firestore);

  Stream<List<Channel>> getChannelsStream(String groupId, String userId) {
    return _firestore
        .collection(FirestorePaths.channelsPath(groupId))
        .snapshots()
        .asyncMap((channelDocuments) {
      return Future.wait(channelDocuments.documents.map((document) async {
        return await documentToChannel(groupId, userId, document);
      }));
    });
  }

  Stream<Channel> getStreamForChannel(
      String groupId, String channelId, String userId) {
    return _firestore
        .document(FirestorePaths.channelPath(groupId, channelId))
        .snapshots()
        .asyncMap((document) async {
      return await documentToChannel(groupId, userId, document);
    });
  }

  Future<void> markChannelRead(
      String groupId, String channelId, String userId) async {
    final channelUsersPath =
        FirestorePaths.channelUsersPath(groupId, channelId);

    // We're removing the indicator for the group then the channel.
    try {
      await _firestore
          .collection(FirestorePaths.PATH_USERS)
          .document(userId)
          .updateData({
        groupId: FieldValue.arrayRemove([channelId])
      });

      return await _firestore
          .collection(channelUsersPath)
          .document(userId)
          .updateData({HASUPDATES: false});
    } catch (e) {
      Logger.e(
        "Couldn't mark read status for user: $userId ",
        e: e,
        s: StackTrace.current,
      );

      return Future.error("Error marking channel as read");
    }
  }

  Future<void> leaveChannel(
    String groupId,
    String channelId,
    String userId,
  ) async {
    final channelUsersPath =
        FirestorePaths.channelUsersPath(groupId, channelId);
    await _firestore.collection(channelUsersPath).document(userId).delete();
  }

  Future<Channel> joinChannel(
    String groupId,
    Channel channel,
    String userId,
  ) async {
    final channelUser = ChannelUser((c) => c
      ..id = userId
      ..rsvp = RSVP.UNSET);
    final channelUsersPath =
        FirestorePaths.channelUsersPath(groupId, channel.id);
    final data = toChannelUserMap(channelUser);

    await _firestore
        .collection(channelUsersPath)
        .document(userId)
        .setData(data);

    return channel.rebuild((c) => c..users.add(channelUser));
  }

  Future<Channel> inviteToChannel({
    String groupId,
    String groupName,
    Channel channel,
    List<String> members,
    String invitingUsername,
  }) async {
    final channelUsersPath =
        FirestorePaths.channelUsersPath(groupId, channel.id);

    final users = members.map((userId) {
      return ChannelUser((c) => c
        ..id = userId
        ..rsvp = RSVP.UNSET);
    });

    for (final user in users) {
      final data = toChannelUserInviteMap(
          user: user,
          channel: channel,
          invitingUsername: invitingUsername,
          groupName: groupName);
      await _firestore
          .collection(channelUsersPath)
          .document(user.id)
          .setData(data);
    }

    return channel.rebuild((c) => c..users.addAll(users));
  }

  Future<Channel> createChannel(
      String groupId, Channel channel, List<String> members, String authorUid) async {
    final data = toMap(channel, members);
    final snapshot = await _firestore
        .collection(FirestorePaths.channelsPath(groupId))
        .getDocuments();

    final channelExists = snapshot.documents
        .any((doc) => doc[NAME].toLowerCase() == channel.name.toLowerCase());
    if (channelExists) {
      return Future.error(ChannelExistsError());
    }

    final reference = await _firestore
        .collection(FirestorePaths.channelsPath(groupId))
        .add(data);
    final doc = await reference.get();

    final users = members.map((userId) {
      return ChannelUser((c) => c
        ..id = userId
        ..rsvp = userId == authorUid ? RSVP.YES : RSVP.UNSET);
    }).toList();

    return fromDocWithUsers(doc: doc, users: BuiltList<ChannelUser>(users));
  }

  Future<Channel> documentToChannel(
    String groupId,
    String userId,
    DocumentSnapshot document,
  ) async {
    final snapshot = await document.reference.collection(USERS).getDocuments();
    final usersDocuments = snapshot.documents;

    final users = usersDocuments.map((data) => channelUserFromDoc(data));

    final userDocument = usersDocuments
        .firstWhere((doc) => doc.documentID == userId, orElse: () => null);

    final hasUpdates =
        (userDocument == null || userDocument.data[HASUPDATES] == null)
            ? false
            : userDocument.data[HASUPDATES];

    return fromDocWithUsers(
        doc: document,
        users: BuiltList<ChannelUser>.of(users),
        hasUpdates: hasUpdates);
  }

  ChannelUser channelUserFromDoc(DocumentSnapshot data) {
    return ChannelUser((c) => c
      ..id = data[USERID]
      ..rsvp = RSVPHelper.valueOf(data[RSVP_FIELD]));
  }

  Future<void> updateChannel(String groupId, Channel channel) async {
    await _firestore
        .document(FirestorePaths.channelPath(groupId, channel.id))
        .updateData({
      DESCRIPTION: channel.description,
      VENUE: channel.venue,
      START_DATE: _formatToTimestamp(channel),
      HAS_START_TIME: channel.hasStartTime,
    });
  }

  Future<Channel> getChannel(
    String groupId,
    String channelId,
    String userId,
  ) async {
    final document = await _firestore
        .document(FirestorePaths.channelPath(groupId, channelId))
        .get();
    return await documentToChannel(groupId, userId, document);
  }

  Future<void> rsvp(
    String groupId,
    String channelId,
    String userId,
    RSVP rsvp,
  ) async {
    final channelUsersPath =
        FirestorePaths.channelUsersPath(groupId, channelId);

    await _firestore
        .collection(channelUsersPath)
        .document(userId)
        .updateData({RSVP_FIELD: RSVPHelper.stringOf(rsvp)});
  }

  static toChannelUserMap(ChannelUser user, {bool isInvite = false}) {
    return {
      USERID: user.id,
      RSVP_FIELD: RSVPHelper.stringOf(user.rsvp),
      INVITATION: isInvite,
    };
  }

  static toChannelUserInviteMap({
    ChannelUser user,
    Channel channel,
    String invitingUsername,
    String groupName,
  }) {
    final Map<String, Object> channelUserInviteMap =
        toChannelUserMap(user, isInvite: true);
    channelUserInviteMap.addAll({
      METADATA: {
        CHANNELNAME: channel.name,
        TYPE: ChannelTypeHelper.stringOf(channel.type),
        VISIBILITY: ChannelVisibilityHelper.stringOf(channel.visibility),
        INVITINGUSER: invitingUsername,
        GROUPNAME: groupName,
      }
    });

    return channelUserInviteMap;
  }

  static Map<String, dynamic> toMap(Channel channel, List<String> members) {
    return {
      NAME: channel.name,
      DESCRIPTION: channel.description,
      VISIBILITY: ChannelVisibilityHelper.stringOf(channel.visibility),
      AUTHORID: channel.authorId ?? "",
      VENUE: channel.venue,
      START_DATE: _formatToTimestamp(channel),
      TIMEZONE_SECONDS_OFFSET: channel.startDate != null
          ? channel.startDate.timeZoneOffset.inSeconds
          : null,
      HAS_START_TIME: channel.hasStartTime,
      TYPE: ChannelTypeHelper.stringOf(channel.type),
      INVITEDMEMBERS: members,
    };
  }

  static Timestamp _formatToTimestamp(Channel channel) {
    if (channel.startDate == null) {
      return null;
    }

    return Timestamp.fromDate(channel.startDate);
  }

  static Channel fromDocWithUsers({
    @required DocumentSnapshot doc,
    @required BuiltList<ChannelUser> users,
    bool hasUpdates = false,
  }) {
    final docType = ChannelTypeHelper.valueOf(doc[TYPE]) ?? ChannelType.TOPIC;

    DateTime date;
    if (docType == ChannelType.EVENT) {
      try {
        date = doc[START_DATE].toDate();
      } catch (e) {
        date = null;
      }

      // Fallback parsing old dates which have previously been stored as strings.
      if (date == null) {
        date = _parseStringDate(doc);
      }
    }

    return Channel((c) => c
      ..id = doc.documentID
      ..name = doc[NAME]
      ..description = doc[DESCRIPTION]
      ..visibility = ChannelVisibilityHelper.valueOf(doc[VISIBILITY]) ??
          ChannelVisibility.OPEN
      ..hasUpdates = hasUpdates
      ..users = users.toBuilder()
      ..type = docType
      ..venue = doc[VENUE]
      ..authorId = doc[AUTHORID]
      ..startDate = date
      ..hasStartTime = doc[HAS_START_TIME]);
  }

  static DateTime _parseStringDate(doc) {
    try {
      return DateTime.parse(doc[START_DATE]).toLocal();
    } catch (error) {
      return null;
    }
  }
}
