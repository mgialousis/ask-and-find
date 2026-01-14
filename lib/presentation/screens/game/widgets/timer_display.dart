import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';

/// Timer display widget
///
/// Shows countdown timer in MM:SS format
/// - Visual warning when < 10 seconds (red color, pulsing animation)
/// - Large, clear display for party game visibility
class TimerDisplay extends StatelessWidget {
  const TimerDisplay({
    super.key,
    required this.secondsRemaining,
  });

  final int secondsRemaining;

  bool get _isWarning => secondsRemaining <= 10;
  bool get _isCritical => secondsRemaining <= 5;

  Color get _color {
    if (_isCritical) return AppColors.error;
    if (_isWarning) return AppColors.warning;
    return AppColors.primary;
  }

  String get _formattedTime {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: _isWarning ? 1.1 : 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _color,
                width: 3,
              ),
              boxShadow: _isWarning
                  ? [
                      BoxShadow(
                        color: _color.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: _color,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: _color,
                    fontFeatures: const [
                      FontFeature.tabularFigures(),
                    ],
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
