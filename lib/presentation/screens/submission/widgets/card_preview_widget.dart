import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/presentation/screens/game/widgets/prompt_card.dart';

/// Preview card shown while composing a new submission.
class CardPreviewWidget extends StatelessWidget {
  const CardPreviewWidget({
    super.key,
    required this.prompt,
    required this.answers,
    this.difficulty,
    this.maxAnswers = 15,
  });

  final String prompt;
  final List<String> answers;
  final Difficulty? difficulty;
  final int maxAnswers;

  @override
  Widget build(BuildContext context) {
    final previewAnswers = answers
        .map((answer) => answer.trim())
        .where((answer) => answer.isNotEmpty)
        .take(maxAnswers)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PromptCard(
          prompt: prompt,
          difficulty: difficulty,
        ),
        if (previewAnswers.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: previewAnswers.map((answer) {
              return Chip(
                label: Text(
                  answer,
                  overflow: TextOverflow.ellipsis,
                ),
                backgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.4),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
