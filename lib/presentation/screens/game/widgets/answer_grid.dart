import 'package:flutter/material.dart';
import 'package:pes_vres/presentation/widgets/common/responsive_layout.dart';
import 'package:pes_vres/presentation/widgets/game/answer_chip.dart';

/// Answer grid widget
///
/// Displays a grid of answer chips (10 total)
/// - Responsive: 2 columns on phone, 3 columns on tablet
/// - Uses AnswerChip widget with three states (hidden/revealed/found)
/// - Handles tap callbacks for answer discovery
class AnswerGrid extends StatelessWidget {
  const AnswerGrid({
    super.key,
    required this.answers,
    required this.foundAnswers,
    required this.onAnswerTap,
    this.showAll = false,
  });

  final List<String> answers;
  final Set<String> foundAnswers;
  final ValueChanged<String> onAnswerTap;
  final bool showAll;

  AnswerChipState _getChipState(String answer) {
    if (foundAnswers.contains(answer)) {
      return AnswerChipState.found;
    } else if (showAll) {
      return AnswerChipState.revealed;
    } else {
      return AnswerChipState.hidden;
    }
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
          index: state == AnswerChipState.hidden ? index : null,
        );
      },
    );
  }
}
