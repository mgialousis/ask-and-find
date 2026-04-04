// Basic widget test for Ask & Find app
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package.

import 'package:flutter_test/flutter_test.dart';

import 'package:pes_vres/app.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the home screen renders with app title
    expect(find.text('Ask & Find'), findsOneWidget);
    expect(find.text('New Game'), findsOneWidget);
  });
}
