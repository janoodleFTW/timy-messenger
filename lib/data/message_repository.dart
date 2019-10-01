import "package:built_collection/built_collection.dart";
import "package:circles_app/data/firestore_paths.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/model/reaction.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/foundation.dart";

class MessageRepository {
  static const BODY = "body";
  static const AUTHOR = "author";
  static const REACTION = "reaction";
  static const TYPE = "type";
  static const TIMESTAMP = "timestamp";
  static const EMOJI = "emoji";
  static const USER_ID = "user_id";
  static const USER_NAME = "user_name";
  static const MEDIA = "media";
  static const MEDIA_STATUS = "media_status";
  static const MEDIA_ASPECT_RATIO = "media_aspect_ratio";

  final Firestore _firestore;

  MessageRepository(this._firestore);

  Future<Message> sendMessage(String groupId,
      String channelId,
      Message message,) async {
    final messagesPath = FirestorePaths.messagesPath(groupId, channelId);
    final data = toMap(message);
    final reference = await _firestore.collection(messagesPath).add(data);
    final doc = await reference.get();
    return fromDoc(doc);
  }

  Stream<List<Message>> getMessagesStream(String groupId,
      String channelId,
      String userId,) {
    return _firestore
        .collection(FirestorePaths.messagesPath(groupId, channelId))
        .orderBy(TIMESTAMP, descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((querySnapshot) {
      return querySnapshot.documents
          .where((documentSnapshot) =>
          isValidDocument(documentSnapshot, userId))
          .map((documentSnapshot) => fromDoc(documentSnapshot))
          .toList();
    });
  }

  Future<void> addReaction({
    @required String groupId,
    @required String channelId,
    @required String messageId,
    @required Reaction reaction,
  }) async {
    final path = FirestorePaths.messagePath(groupId, channelId, messageId);
    final snapshot = await _firestore.document(path).get();
    final message = fromDoc(snapshot);
    // Cannot add reactions to their own message
    if (message.authorId == reaction.userId) {
      return;
    }
    final reactions = message.reactions.toBuilder();
    reactions[reaction.userId] = reaction;
    await _firestore.document(path).updateData({
      REACTION: _reactionsToMap(reactions.build()),
    });
  }

  Future<void> removeReaction({
    @required String groupId,
    @required String channelId,
    @required String messageId,
    @required String userId,
  }) async {
    final path = FirestorePaths.messagePath(groupId, channelId, messageId);
    final snapshot = await _firestore.document(path).get();
    final reaction = fromDoc(snapshot).reactions;
    final builder = reaction.toBuilder();
    builder.remove(userId);
    return await _firestore
        .document(path)
        .updateData({REACTION: _reactionsToMap(builder.build())});
  }

  Future<void> deleteMessage(String groupId, String channelId, String messageId) async {
    final path = FirestorePaths.messagePath(groupId, channelId, messageId);
    return await _firestore
        .document(path)
        .delete();
  }

  static Message fromDoc(DocumentSnapshot document) {
    final messageType = MessageTypeHelper.valueOf(document[TYPE]);

    return Message((m) =>
    m
      ..id = document.documentID
      ..body = document[BODY]
      ..authorId = messageType == MessageType.SYSTEM ? null : document[AUTHOR]
      ..reactions = _parseReactions(document)
      ..messageType = messageType
      ..media = ListBuilder(document[MEDIA] ?? [])
      ..mediaStatus = MediaStatusHelper.valueOf(document[MEDIA_STATUS])
      ..mediaAspectRatio =
      double.tryParse(document[MEDIA_ASPECT_RATIO] ?? "1.0")
      ..timestamp = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(document[TIMESTAMP]) ?? 0)
      ..pending = document.metadata.hasPendingWrites);
  }

  static MapBuilder<String, Reaction> _parseReactions(
      DocumentSnapshot document) {
    final map = MapBuilder<String, Reaction>();
    if (document[REACTION] == null) {
      return map;
    }
    for (final key in document[REACTION].keys) {
      final value = document[REACTION][key];
      try {
        map[key] = _parseReaction(value);
      } catch (e) {
        // Ignore reactions in old format
      }
    }
    return map;
  }

  static Reaction _parseReaction(data) {
    return Reaction((r) =>
    r
      ..emoji = data[EMOJI]
      ..userId = data[USER_ID]
      ..userName = data[USER_NAME]
      ..timestamp = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(data[TIMESTAMP]) ?? 0));
  }

  static Map<String, dynamic> _reactionsToMap(
      BuiltMap<String, Reaction> reactions) {
    return reactions
        .map((k, v) =>
        MapEntry(k, {
          EMOJI: v.emoji,
          USER_ID: v.userId,
          USER_NAME: v.userName,
          TIMESTAMP: v.timestamp.millisecondsSinceEpoch.toString(),
        }))
        .toMap();
  }

  static toMap(Message message) {
    return {
      BODY: message.body,
      AUTHOR: message.authorId,
      REACTION: _reactionsToMap(message.reactions),
      TYPE: MessageTypeHelper.stringOf(message.messageType),
      TIMESTAMP: message.timestamp.millisecondsSinceEpoch.toString(),
    };
  }

  static bool isValidDocument(DocumentSnapshot documentSnapshot, [String userId = ""]) {
    final docType = MessageTypeHelper.valueOf(documentSnapshot[TYPE]);
    switch (docType) {
      case MessageType.SYSTEM:
        return true;
        break;
      case MessageType.RSVP:
        return true;
        break;
      case MessageType.USER:
        return _hasValidAuthor(documentSnapshot);
        break;
      case MessageType.MEDIA:
        return _hasValidAuthor(documentSnapshot) && _isVisibleToUser(documentSnapshot, userId);
        break;
      default:
        return false;
        break;
    }
  }

  static bool _hasValidAuthor(DocumentSnapshot documentSnapshot) {
    return documentSnapshot[AUTHOR] != null &&
        // Legacy messages have a different author payload
        documentSnapshot[AUTHOR] is String;
  }

  static bool _isVisibleToUser(DocumentSnapshot documentSnapshot, String userId) {
    final mediaStatus = MediaStatusHelper.valueOf(documentSnapshot[MEDIA_STATUS]);
    final author = documentSnapshot[AUTHOR];
    switch (mediaStatus) {
      case MediaStatus.DONE:
        return true;
        break;
      case MediaStatus.UPLOADING:
      case MediaStatus.ERROR:
      default:
        return author == userId;
        break;
    }
  }

}
