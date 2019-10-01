import "package:circles_app/data/group_repository.dart";
import "package:circles_app/model/group.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";


class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

main() {
  group("Circle Repository", () {
    final circle = Group((c) => c
      ..id = "ID"
      ..name = "CIRCLE"
      ..hexColor = "FFFFFF"
      ..abbreviation = "CI"
    );

    test("should map DocumentSnapshot to Circle", () {
      final document = MockDocumentSnapshot();
      when(document["name"]).thenReturn("CIRCLE");
      when(document.documentID).thenReturn("ID");
      when(document["color"]).thenReturn("FFFFFF");
      when(document["abbreviation"]).thenReturn("CI");
      final outCircle = GroupRepository.fromDoc(document);
      expect(outCircle, circle);
    });
  });
}
