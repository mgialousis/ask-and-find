import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/presentation/widgets/game/answer_chip.dart';

void main() {
  group('AnswerChip', () {
    testWidgets('displays answer text and points', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnswerChip(
              answer: 'Test Answer',
              state: AnswerChipState.unselected,
              onTap: _noop,
              pointValue: 2,
            ),
          ),
        ),
      );

      expect(find.textContaining('Test Answer'), findsOneWidget);
      expect(find.textContaining('2 pts'), findsOneWidget);
    });

    testWidgets('shows checkmark when selected', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnswerChip(
              answer: 'Test Answer',
              state: AnswerChipState.selected,
              onTap: _noop,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('calls onTap after animation', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnswerChip(
              answer: 'Test Answer',
              state: AnswerChipState.unselected,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AnswerChip));
      // Wait for animation to complete (forward + reverse = 200ms total)
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}

void _noop() {}
