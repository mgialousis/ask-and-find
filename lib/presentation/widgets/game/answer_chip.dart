import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

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
/// Includes bounce animation on tap for satisfying feedback.
class AnswerChip extends StatefulWidget {
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
  State<AnswerChip> createState() => _AnswerChipState();
}

class _AnswerChipState extends State<AnswerChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Play bounce animation, then trigger callback
    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        widget.onTap();
      });
    });
  }

  bool get _isSelected => widget.state == AnswerChipState.selected;

  Color get _backgroundColor {
    switch (widget.state) {
      case AnswerChipState.unselected:
        return AppColors.surface;
      case AnswerChipState.selected:
        return AppColors.success;
    }
  }

  Color get _textColor {
    switch (widget.state) {
      case AnswerChipState.unselected:
        return AppColors.textPrimary;
      case AnswerChipState.selected:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Material(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        elevation: _isSelected ? 0 : 2,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSelected) ...[
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.answer,
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 16,
                            fontWeight:
                                _isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' (${l10n.nPts(widget.pointValue)})',
                          style: TextStyle(
                            color: _textColor.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
