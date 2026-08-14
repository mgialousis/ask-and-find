import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/core/theme/app_text_styles.dart';

/// Theme configuration for the "Ask & Find" app
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
        brightness: Brightness.light,
      ),

      // Scaffold background
      scaffoldBackgroundColor: AppColors.background,

      // AppBar theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.surface,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, 56),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
          minimumSize: const Size(0, 56),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AppTextStyles.body1.copyWith(
          color: AppColors.textSecondary,
        ),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: AppTextStyles.h3,
        contentTextStyle: AppTextStyles.body1,
      ),

      // Bottom sheet theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        elevation: 8,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        disabledColor: AppColors.surfaceVariant.withValues(alpha: 0.5),
        selectedColor: AppColors.primary,
        secondarySelectedColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        labelStyle: AppTextStyles.body2,
        secondaryLabelStyle: AppTextStyles.body2.copyWith(
          color: AppColors.textOnPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
          }
          return AppColors.surfaceVariant;
        }),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceVariant,
        thickness: 1,
        space: 24,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Text theme
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        displaySmall: AppTextStyles.h3,
        headlineMedium: AppTextStyles.h4,
        bodyLarge: AppTextStyles.body1,
        bodyMedium: AppTextStyles.body2,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
      ),
    );
  }

  /// Dark theme configuration.
  ///
  /// Derived from [lightTheme] so shape, spacing and typography stay identical
  /// and only colour is overridden. Brand and semantic colours are deliberately
  /// unchanged — they were chosen to be legible on both backgrounds — while
  /// surfaces and text come from [AppPalette.dark], the same values widgets
  /// resolve through `context.palette`.
  static ThemeData get darkTheme {
    const palette = AppPalette.dark;
    final base = lightTheme;

    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.primaryLight,
        surface: palette.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSurface: palette.textPrimary,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: palette.background,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: palette.surface,
        foregroundColor: palette.textPrimary,
        titleTextStyle: base.appBarTheme.titleTextStyle?.copyWith(
          color: palette.textPrimary,
        ),
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      cardTheme: base.cardTheme.copyWith(color: palette.surface),
      dialogTheme: base.dialogTheme.copyWith(
        backgroundColor: palette.surface,
        titleTextStyle: base.dialogTheme.titleTextStyle?.copyWith(
          color: palette.textPrimary,
        ),
        contentTextStyle: base.dialogTheme.contentTextStyle?.copyWith(
          color: palette.textPrimary,
        ),
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: palette.surface,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        fillColor: palette.surfaceVariant,
        hintStyle: base.inputDecorationTheme.hintStyle?.copyWith(
          color: palette.textSecondary,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: palette.surfaceVariant,
        disabledColor: palette.surfaceVariant.withValues(alpha: 0.5),
        labelStyle: base.chipTheme.labelStyle?.copyWith(
          color: palette.textPrimary,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return palette.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryDark;
          }
          return palette.surfaceVariant;
        }),
      ),
      dividerTheme: base.dividerTheme.copyWith(color: palette.surfaceVariant),
      iconTheme: base.iconTheme.copyWith(color: palette.textPrimary),
      textTheme: base.textTheme.apply(
        bodyColor: palette.textPrimary,
        displayColor: palette.textPrimary,
      ),
    );
  }
}
