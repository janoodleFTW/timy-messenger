import "dart:core";
import "package:circles_app/data/firestore_paths.dart";
import "package:circles_app/model/group.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class GroupRepository {
  static const String NAME = "name";
  static const String ABBREVIATION = "abbreviation";
  static const String IMAGE = "image";
  static const String COLOR = "color";
  static const String MEMBERS = "members";

  final Firestore firestore;

  const GroupRepository(this.firestore);

  Future<Group> getGroup(String id) async {
    final doc = await firestore.document(FirestorePaths.groupPath(id)).get();
    return fromDoc(doc);
  }

  Stream<List<Group>> getGroupStream(userId) {
    return firestore
        .collection(FirestorePaths.PATH_GROUPS)
        .where(MEMBERS, arrayContains: userId)
        .snapshots()
        .map((snapShot) {
      return snapShot.documents.map((doc) => fromDoc(doc)).toList();
    });
  }

  static Group fromDoc(DocumentSnapshot doc) {
    return Group((c) => c
      ..id = doc.documentID
      ..name = doc[NAME]
      ..image = doc[IMAGE]
      ..abbreviation = doc[ABBREVIATION]
      ..hexColor = doc[COLOR]);
  }
}
