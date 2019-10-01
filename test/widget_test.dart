import "package:circles_app/circles_app.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("App loads test", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(CirclesApp());

  });
}
