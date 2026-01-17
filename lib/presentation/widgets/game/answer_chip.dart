import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';

/// State of an answer chip in the game
enum AnswerChipState {
  /// Answer is not selected (default state, always visible)
  unselected,

  /// Answer has been selected by the player
  selected,
}

/// Tappable chip that displays an answer in the game
///
/// This is a critical game component that handles the main interaction.
/// Always shows the answer text with point value in parentheses.
/// Players tap to select/deselect answers.
class AnswerChip extends StatelessWidget {
  const AnswerChip({
    super.key,
    required this.answer,
    required this.state,
    required this.onTap,
    this.pointValue = 1,
  });

  final String answer;
  final AnswerChipState state;
  final VoidCallback onTap;
  final int pointValue;

  @override
  Widget build(BuildContext context) {
    final isSelected = state == AnswerChipState.selected;

    return Material(
      color: _getBackgroundColor(),
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 0 : 2,
      child: InkWell(
        onTap: onTap, // Always tappable for toggle behavior
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: RichText(
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: answer,
                        style: TextStyle(
                          color: _getTextColor(),
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: ' ($pointValue ${pointValue == 1 ? 'pt' : 'pts'})',
                        style: TextStyle(
                          color: _getTextColor().withValues(alpha: 0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
      case AnswerChipState.unselected:
        return AppColors.surface;
      case AnswerChipState.selected:
        return AppColors.success;
    }
  }

  Color _getTextColor() {
    switch (state) {
      case AnswerChipState.unselected:
        return AppColors.textPrimary;
      case AnswerChipState.selected:
        return Colors.white;
    }
  }
}
