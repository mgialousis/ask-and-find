import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/presentation/screens/game/widgets/timer_display.dart';

void main() {
  group('TimerDisplay', () {
    testWidgets('formats time correctly (MM:SS)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(secondsRemaining: 65),
          ),
        ),
      );

      expect(find.text('01:05'), findsOneWidget);
    });

    testWidgets('shows warning time under 10 seconds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(secondsRemaining: 8),
          ),
        ),
      );

      expect(find.text('00:08'), findsOneWidget);
    });

    testWidgets('shows critical time under 5 seconds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(secondsRemaining: 3),
          ),
        ),
      );

      expect(find.text('00:03'), findsOneWidget);
    });
  });
}
