import 'package:flutter/material.dart';

/// App-wide color palette for the "Ask & Find" game
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary brand colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5448CC);
  static const Color primaryLight = Color(0xFF8F88FF);

  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F1F5);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFFBBBBBB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Game-specific colors
  static const Color timerNormal = Color(0xFF6B7280);
  static const Color timerWarning = Color(0xFFF59E0B);
  static const Color timerCritical = Color(0xFFEF4444);

  // Team colors (minimum 8 distinct, color-blind friendly options)
  static const List<Color> teamColors = [
    Color(0xFFEF4444), // Red
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Orange
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFFF97316), // Deep Orange
    Color(0xFF06B6D4), // Cyan
    Color(0xFFA855F7), // Violet
    Color(0xFF84CC16), // Lime
    Color(0xFFFBBF24), // Yellow
  ];

  // Team color names for UI display
  static const List<String> teamColorNames = [
    'Red',
    'Blue',
    'Green',
    'Orange',
    'Purple',
    'Pink',
    'Teal',
    'Deep Orange',
    'Cyan',
    'Violet',
    'Lime',
    'Yellow',
  ];

  /// Get team color by index (wraps around if index exceeds available colors)
  static Color getTeamColor(int index) {
    return teamColors[index % teamColors.length];
  }

  /// Get team color name by index
  static String getTeamColorName(int index) {
    return teamColorNames[index % teamColorNames.length];
  }

  /// Check if two colors are the same (useful for validation)
  static bool areColorsSame(Color color1, Color color2) {
    return color1.toARGB32() == color2.toARGB32();
  }
}

/// The subset of colors that must flip between light and dark.
///
/// Brand and semantic colors ([AppColors.primary], success/error/warning and
/// the team colors) read correctly on either background and stay constant.
/// Surfaces and text do not, so widgets resolve them from the ambient theme
/// via [AppPaletteContext.palette] instead of referencing [AppColors] directly.
@immutable
class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
  });

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;

  /// Identical to the historical [AppColors] constants, so light mode renders
  /// exactly as it did before dark mode existed.
  static const AppPalette light = AppPalette(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceVariant: AppColors.surfaceVariant,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textDisabled: AppColors.textDisabled,
  );

  /// Dark surfaces are kept above pure black so elevation and the team colors
  /// stay legible. Text contrast against [surface] is ~15:1 for [textPrimary]
  /// and ~7.9:1 for [textSecondary], both above the WCAG AA 4.5:1 threshold.
  static const AppPalette dark = AppPalette(
    background: Color(0xFF121316),
    surface: Color(0xFF1C1E24),
    surfaceVariant: Color(0xFF282B33),
    textPrimary: Color(0xFFF3F4F6),
    textSecondary: Color(0xFFA9B0BD),
    textDisabled: Color(0xFF6B7280),
  );
}

extension AppPaletteContext on BuildContext {
  /// Surface and text colors for the current theme brightness.
  AppPalette get palette =>
      Theme.of(this).brightness == Brightness.dark
          ? AppPalette.dark
          : AppPalette.light;
}
