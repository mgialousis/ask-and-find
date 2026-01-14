import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';

/// Typography styles for the "Say & Find" app
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Base font family
  static const String _fontFamily = 'Roboto';

  // Headings
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body text
  static const TextStyle body1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Game-specific styles
  static const TextStyle timer = TextStyle(
    fontFamily: 'monospace',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.timerNormal,
    height: 1.0,
  );

  static const TextStyle timerWarning = TextStyle(
    fontFamily: 'monospace',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.timerWarning,
    height: 1.0,
  );

  static const TextStyle timerCritical = TextStyle(
    fontFamily: 'monospace',
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.timerCritical,
    height: 1.0,
  );

  static const TextStyle prompt = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle answer = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle score = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle teamName = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Utility method to scale text for different screen sizes
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final shortestSide = screenWidth < screenHeight ? screenWidth : screenHeight;

    // Scale factor based on screen size
    // Base size is for a 375px wide screen (iPhone SE/6/7/8)
    const baseScreenWidth = 375.0;
    final scaleFactor = shortestSide / baseScreenWidth;

    // Clamp scale factor to reasonable bounds
    final clampedScale = scaleFactor.clamp(0.85, 1.5);

    return baseFontSize * clampedScale;
  }
}
