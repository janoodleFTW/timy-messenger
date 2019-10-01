import "package:built_collection/built_collection.dart";
import "package:circles_app/data/firestore_paths.dart";
import "package:circles_app/model/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

class UserRepository {
  static const NAME = "name";
  static const EMAIL = "email";
  static const IMAGE = "image";
  static const UID = "uid";
  static const TOKEN = "token";
  static const LOCALE = "locale";
  static const UPDATEDGROUPS = "updatedGroups";
  static const JOINEDGROUPS = "joinedGroups";
  static const STATUS = "status";

  final FirebaseAuth _firebaseAuth;
  final Firestore _firestore;

  const UserRepository(
    this._firebaseAuth,
    this._firestore,
  );

  Stream<User> getUserStream(userId) {
    return _firestore
        .collection(FirestorePaths.PATH_USERS)
        .document(userId)
        .snapshots()
        .map((userSnapshot) {
      return fromDoc(userSnapshot);
    });
  }

  Stream<List<User>> getUsersStream(groupId) {
    return _firestore
        .collection(FirestorePaths.PATH_USERS)
        .where(JOINEDGROUPS, arrayContains: groupId)
        .snapshots()
        .map((userSnapshot) {
      final users = userSnapshot.documents.map(fromDoc).toList();
      users.sort((a, b) => a.name.compareTo(b.name));
      return users;
    });
  }

  Stream<User> getAuthenticationStateChange() {
    return _firebaseAuth.onAuthStateChanged.asyncMap((firebaseUser) {
      return _fromFirebaseUser(firebaseUser);
    });
  }

  Future<User> signIn(String email, String password) async {
    final firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return await _fromFirebaseUser(firebaseUser.user);
  }

  Future<User> _fromFirebaseUser(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) return Future.value(null);

    final documentReference =
        _firestore.document(FirestorePaths.userPath(firebaseUser.uid));
    final snapshot = await documentReference.get();

    User user;
    if (snapshot.data == null) {
      user = User((u) => u
            ..uid = firebaseUser.uid
            ..email = firebaseUser.email
            ..name = firebaseUser
                .email // Default name will be the email, let user change later
          );
      await documentReference.setData(toMap(user));
    } else {
      user = fromDoc(snapshot);
    }
    return user;
  }

  Future<void> logOut() async {
    await updateUserToken(null);
    await _firebaseAuth.signOut();
  }

  Future<void> updateUserToken(String token) async {
    final firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser != null) {
      final documentReference =
          _firestore.document(FirestorePaths.userPath(firebaseUser.uid));
      return documentReference.updateData({
        TOKEN: token,
      });
    }
  }

  ///
  /// Allows to update the User, but only the following fields:
  /// - name
  /// - status
  /// - image
  ///
  Future<void> updateUser(User user) async {
    final firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser != null) {
      final documentReference =
          _firestore.document(FirestorePaths.userPath(firebaseUser.uid));
      return documentReference.updateData({
        STATUS: user.status,
        NAME: user.name,
        IMAGE: user.image,
      });
    }
  }

  // Sets a users locale on our backend.
  // The locale is used to send localized notifications.
  Future<void> updateUserLocale(String locale) async {
    final firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser != null) {
      final documentReference =
          _firestore.document(FirestorePaths.userPath(firebaseUser.uid));
      return documentReference.updateData({
        LOCALE: locale,
      });
    }
  }

  static toMap(User user) {
    return {
      UID: user.uid,
      NAME: user.name,
      EMAIL: user.email,
    };
  }

  static User fromDoc(DocumentSnapshot document) {
    return User((u) => u
      ..uid = document.documentID
      ..name = document[NAME]
      ..email = document[EMAIL]
      ..image = document[IMAGE]
      ..status = document[STATUS]
      ..unreadUpdates = MapBuilder(_parseUnreadChannels(document)));
  }

  // We keep an updated list of groups in each document which can be accessed via `UPDATEDGROUPS`.
  // This list is used to access all updated channels for a group via the `groupId`.
  // This method returns a map which represents the updated channels and groups.
  // Its values can be used to update the UI for a logged in user accordingly.
  static Map<String, BuiltList> _parseUnreadChannels(document) {
    final groupsList = document[UPDATEDGROUPS];
    final groupIds = groupsList != null ? List<String>.from(groupsList) : [];

    final unreadChannelsMap = Map<String, BuiltList<String>>();
    groupIds.forEach((groupId) {
      final unreadChannels = document[groupId];
      if (unreadChannels != null) {
        unreadChannelsMap[groupId] = BuiltList<String>(unreadChannels);
      }
    });

    return unreadChannelsMap;
  }

  static User fromMessageAuthor(document) {
    return User((u) => u
      ..uid = document[UID]
      ..name = document[NAME]
      ..email = document[EMAIL]);
  }
}
