import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pes_vres/core/analytics/analytics_service.dart';
import 'package:pes_vres/core/config/preferences_keys.dart';

/// Settings state for the app
///
/// Manages user preferences:
/// - Sound effects enabled/disabled
/// - Haptic feedback enabled/disabled
/// - Dark mode enabled/disabled
///
/// State is persisted to SharedPreferences automatically.
class SettingsState extends Equatable {
  const SettingsState({
    required this.soundEffectsEnabled,
    required this.hapticFeedbackEnabled,
    required this.darkModeEnabled,
    required this.analyticsEnabled,
  });

  final bool soundEffectsEnabled;
  final bool hapticFeedbackEnabled;
  final bool darkModeEnabled;
  final bool analyticsEnabled;

  /// Default settings (all enabled except dark mode)
  factory SettingsState.defaults() => const SettingsState(
        soundEffectsEnabled: true,
        hapticFeedbackEnabled: true,
        darkModeEnabled: false,
        analyticsEnabled: true,
      );

  /// Create a copy with optional field updates
  SettingsState copyWith({
    bool? soundEffectsEnabled,
    bool? hapticFeedbackEnabled,
    bool? darkModeEnabled,
    bool? analyticsEnabled,
  }) {
    return SettingsState(
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }

  @override
  List<Object?> get props =>
      [
        soundEffectsEnabled,
        hapticFeedbackEnabled,
        darkModeEnabled,
        analyticsEnabled,
      ];
}

/// Settings notifier - manages settings state and persistence
///
/// Automatically loads settings from SharedPreferences on initialization
/// and saves changes immediately when settings are updated.
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.defaults()) {
    _loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      soundEffectsEnabled: prefs.getBool(PreferencesKeys.soundEffects) ?? true,
      hapticFeedbackEnabled:
          prefs.getBool(PreferencesKeys.hapticFeedback) ?? true,
      darkModeEnabled: prefs.getBool(PreferencesKeys.darkMode) ?? false,
      analyticsEnabled:
          prefs.getBool(PreferencesKeys.analyticsEnabled) ?? true,
    );
  }

  /// Enable or disable sound effects
  Future<void> setSoundEffects(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferencesKeys.soundEffects, enabled);
    state = state.copyWith(soundEffectsEnabled: enabled);
    await AnalyticsService.instance.capture(
      'settings_changed',
      properties: {
        'sound': enabled,
      },
    );
  }

  /// Enable or disable haptic feedback
  Future<void> setHapticFeedback(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferencesKeys.hapticFeedback, enabled);
    state = state.copyWith(hapticFeedbackEnabled: enabled);
    await AnalyticsService.instance.capture(
      'settings_changed',
      properties: {
        'haptics': enabled,
      },
    );
  }

  /// Enable or disable dark mode
  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferencesKeys.darkMode, enabled);
    state = state.copyWith(darkModeEnabled: enabled);
    await AnalyticsService.instance.capture(
      'settings_changed',
      properties: {
        'dark_mode': enabled,
      },
    );
  }

  /// Enable or disable analytics
  Future<void> setAnalyticsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferencesKeys.analyticsEnabled, enabled);
    state = state.copyWith(analyticsEnabled: enabled);
    await AnalyticsService.instance.capture(
      'settings_changed',
      properties: {
        'analytics': enabled,
      },
    );
    await AnalyticsService.instance.setEnabled(enabled);
  }

  /// Restore all settings to defaults
  Future<void> restoreDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferencesKeys.soundEffects);
    await prefs.remove(PreferencesKeys.hapticFeedback);
    await prefs.remove(PreferencesKeys.darkMode);
    await prefs.remove(PreferencesKeys.analyticsEnabled);
    state = SettingsState.defaults();
    await AnalyticsService.instance.setEnabled(state.analyticsEnabled);
  }
}

/// Provider for app settings
///
/// Usage:
/// ```dart
/// // Read settings
/// final settings = ref.watch(settingsProvider);
/// if (settings.soundEffectsEnabled) { /* play sound */ }
///
/// // Update settings
/// ref.read(settingsProvider.notifier).setSoundEffects(false);
/// ```
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
