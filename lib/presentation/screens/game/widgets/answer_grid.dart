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
  });

  final List<String> answers;
  final Set<String> foundAnswers;
  final ValueChanged<String> onAnswerTap;
  final int Function(String answer) pointsForAnswer;

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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: answers.length,
      itemBuilder: (context, index) {
        final answer = answers[index];
        final state = _getChipState(answer);

        return AnswerChip(
          answer: answer,
          state: state,
          onTap: () => onAnswerTap(answer),
          pointValue: pointsForAnswer(answer),
        );
      },
    );
  }
}
