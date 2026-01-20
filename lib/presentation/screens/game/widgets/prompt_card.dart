import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

/// Prompt card widget
///
/// Displays the card prompt/question for the current round
/// Shows difficulty badge if provided
/// Uses large, clear text for party game visibility
class PromptCard extends StatelessWidget {
  const PromptCard({
    super.key,
    required this.prompt,
    this.difficulty,
  });

  final String prompt;
  final Difficulty? difficulty;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.05),
              AppColors.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            // Difficulty Badge (if provided)
            if (difficulty != null) ...[
              _DifficultyBadge(difficulty: difficulty!),
              const SizedBox(height: 16),
            ],

            // Prompt Text
            Text(
              prompt,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final Difficulty difficulty;

  Color get _color {
    switch (difficulty) {
      case Difficulty.easy:
        return AppColors.success;
      case Difficulty.medium:
        return AppColors.warning;
      case Difficulty.hard:
        return AppColors.error;
    }
  }

  String _label(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (difficulty) {
      case Difficulty.easy:
        return l10n.easy;
      case Difficulty.medium:
        return l10n.medium;
      case Difficulty.hard:
        return l10n.hard;
    }
  }

  IconData get _icon {
    switch (difficulty) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied;
      case Difficulty.medium:
        return Icons.sentiment_neutral;
      case Difficulty.hard:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _color,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            color: _color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            _label(context),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
