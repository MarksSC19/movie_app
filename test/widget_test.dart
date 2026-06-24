import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/main.dart';

void main() {
  testWidgets('Smoke test for CineVerse App', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MovieApp());

    // Verify that CineVerse app bar text exists.
    expect(find.text('Cine'), findsOneWidget);
  });
}
