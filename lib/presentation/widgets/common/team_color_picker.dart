import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';

/// Color picker for team selection
///
/// Displays all available team colors in a grid layout.
/// Shows which colors are already taken by other teams.
class TeamColorPicker extends StatelessWidget {
  const TeamColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.unavailableColors = const [],
  });

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color> unavailableColors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: AppColors.teamColors.map((color) {
        final isSelected = AppColors.areColorsSame(color, selectedColor);
        final isUnavailable = unavailableColors.any(
          (unavailable) => AppColors.areColorsSame(color, unavailable),
        );

        return _ColorOption(
          color: color,
          isSelected: isSelected,
          isUnavailable: isUnavailable,
          onTap: isUnavailable ? null : () => onColorSelected(color),
        );
      }).toList(),
    );
  }
}

class _ColorOption extends StatelessWidget {
  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.isUnavailable,
    this.onTap,
  });

  final Color color;
  final bool isSelected;
  final bool isUnavailable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: AppColors.textPrimary,
                  width: 3,
                )
              : null,
        ),
        child: isUnavailable
            ? Icon(
                Icons.close,
                color: Colors.white.withValues(alpha: 0.8),
                size: 24,
              )
            : isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  )
                : null,
      ),
    );
  }
}
