import "package:built_collection/built_collection.dart";
import "package:circles_app/data/user_repository.dart";
import "package:circles_app/model/user.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "FirestoreMocks.dart";

main() {
  group("User Repository", () {
    final user = User((u) => u
      ..uid = "ID"
      ..name = "NAME"
      ..email = "EMAIL"
      ..unreadUpdates = MapBuilder({}));

    test("should map user to Map<String, dynamic>", () {
      final map = UserRepository.toMap(user);
      expect(map, {
        "uid": "ID",
        "name": "NAME",
        "email": "EMAIL",
      });
    });

    test("should map DocumentSnapshot to User", () {
      final document = MockDocumentSnapshot();
      when(document["name"]).thenReturn("NAME");
      when(document["email"]).thenReturn("EMAIL");
      when(document.documentID).thenReturn("ID");
      when(document["unreadUpdates"]).thenReturn({});
      final userFromDoc = UserRepository.fromDoc(document);
      expect(userFromDoc, user);
    });
  });
}
