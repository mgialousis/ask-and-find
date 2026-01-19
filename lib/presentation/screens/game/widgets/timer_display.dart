import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';

/// Timer display widget
///
/// Shows countdown timer in MM:SS format
/// - Visual warning when < 10 seconds (orange color, pulsing animation)
/// - Critical warning when < 5 seconds (red color, faster pulsing)
/// - Large, clear display for party game visibility
class TimerDisplay extends StatefulWidget {
  const TimerDisplay({
    super.key,
    required this.secondsRemaining,
  });

  final int secondsRemaining;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool get _isWarning => widget.secondsRemaining <= 10 && widget.secondsRemaining > 0;
  bool get _isCritical => widget.secondsRemaining <= 5 && widget.secondsRemaining > 0;

  Color get _color {
    if (_isCritical) return AppColors.error;
    if (_isWarning) return AppColors.warning;
    return AppColors.primary;
  }

  String get _formattedTime {
    final minutes = widget.secondsRemaining ~/ 60;
    final seconds = widget.secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _updatePulseAnimation();
  }

  @override
  void didUpdateWidget(TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.secondsRemaining != widget.secondsRemaining) {
      _updatePulseAnimation();
    }
  }

  void _updatePulseAnimation() {
    if (_isCritical) {
      // Faster pulsing when critical (< 5s)
      _pulseController.duration = const Duration(milliseconds: 250);
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else if (_isWarning) {
      // Normal pulsing when warning (< 10s)
      _pulseController.duration = const Duration(milliseconds: 500);
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      // Stop pulsing when not in warning state
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isWarning ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
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
  }
}
