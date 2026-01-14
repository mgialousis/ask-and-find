import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';

/// State of an answer chip in the game
enum AnswerChipState {
  /// Answer is hidden, not yet revealed
  hidden,

  /// Answer is revealed but not found yet
  revealed,

  /// Answer has been successfully found
  found,
}

/// Tappable chip that displays an answer in the game
///
/// This is a critical game component that handles the main interaction.
/// Shows different visual states for hidden, revealed, and found answers.
class AnswerChip extends StatelessWidget {
  const AnswerChip({
    super.key,
    required this.answer,
    required this.state,
    required this.onTap,
    this.index,
  });

  final String answer;
  final AnswerChipState state;
  final VoidCallback onTap;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _getBackgroundColor(),
      borderRadius: BorderRadius.circular(12),
      elevation: state == AnswerChipState.found ? 0 : 2,
      child: InkWell(
        onTap: state == AnswerChipState.found ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state == AnswerChipState.found) ...[
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  _getDisplayText(),
                  style: TextStyle(
                    color: _getTextColor(),
                    fontSize: 16,
                    fontWeight: state == AnswerChipState.found
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (state) {
      case AnswerChipState.hidden:
        return AppColors.surfaceVariant;
      case AnswerChipState.revealed:
        return AppColors.surface;
      case AnswerChipState.found:
        return AppColors.success;
    }
  }

  Color _getTextColor() {
    switch (state) {
      case AnswerChipState.hidden:
        return AppColors.textSecondary;
      case AnswerChipState.revealed:
        return AppColors.textPrimary;
      case AnswerChipState.found:
        return Colors.white;
    }
  }

  String _getDisplayText() {
    if (state == AnswerChipState.hidden) {
      return index != null ? '${index! + 1}' : '?';
    }
    return answer;
  }
}
