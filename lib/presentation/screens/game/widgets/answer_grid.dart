import 'package:flutter/material.dart';
import 'package:pes_vres/presentation/widgets/common/responsive_layout.dart';
import 'package:pes_vres/presentation/widgets/game/answer_chip.dart';

/// Answer grid widget
///
/// Displays a grid of answer chips (10 total)
/// - Responsive: 2 columns on phone, 3 columns on tablet
/// - All answers always visible with point values
/// - Tap to select/deselect answers
class AnswerGrid extends StatelessWidget {
  const AnswerGrid({
    super.key,
    required this.answers,
    required this.foundAnswers,
    required this.onAnswerTap,
    required this.pointsForAnswer,
    this.primaryAnswerFor,
    this.secondaryAnswerFor,
  });

  final List<String> answers;
  final Set<String> foundAnswers;
  final ValueChanged<String> onAnswerTap;
  final int Function(String answer) pointsForAnswer;
  final String Function(String answer)? primaryAnswerFor;
  final String? Function(String answer)? secondaryAnswerFor;

  AnswerChipState _getChipState(String answer) {
    return foundAnswers.contains(answer)
        ? AnswerChipState.selected
        : AnswerChipState.unselected;
  }

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveValue<int>(
      phone: 2,
      tablet: 3,
    ).getValue(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final availableWidth = constraints.maxWidth;
        final itemWidth =
            (availableWidth - (spacing * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final answer in answers)
              SizedBox(
                width: itemWidth,
                child: AnswerChip(
                  answer: primaryAnswerFor?.call(answer) ?? answer,
                  secondaryAnswer: secondaryAnswerFor?.call(answer),
                  state: _getChipState(answer),
                  onTap: () => onAnswerTap(answer),
                  pointValue: pointsForAnswer(answer),
                ),
              ),
          ],
        );
      },
    );
  }
}
