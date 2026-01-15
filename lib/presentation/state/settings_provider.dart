import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  });

  final bool soundEffectsEnabled;
  final bool hapticFeedbackEnabled;
  final bool darkModeEnabled;

  /// Default settings (all enabled except dark mode)
  factory SettingsState.defaults() => const SettingsState(
        soundEffectsEnabled: true,
        hapticFeedbackEnabled: true,
        darkModeEnabled: false,
      );

  /// Create a copy with optional field updates
  SettingsState copyWith({
    bool? soundEffectsEnabled,
    bool? hapticFeedbackEnabled,
    bool? darkModeEnabled,
  }) {
    return SettingsState(
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
    );
  }

  @override
  List<Object?> get props =>
      [soundEffectsEnabled, hapticFeedbackEnabled, darkModeEnabled];
}

/// Settings notifier - manages settings state and persistence
///
/// Automatically loads settings from SharedPreferences on initialization
/// and saves changes immediately when settings are updated.
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.defaults()) {
    _loadSettings();
  }

  // SharedPreferences keys
  static const String _keySound = 'settings_sound_effects';
  static const String _keyHaptic = 'settings_haptic_feedback';
  static const String _keyDarkMode = 'settings_dark_mode';

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      soundEffectsEnabled: prefs.getBool(_keySound) ?? true,
      hapticFeedbackEnabled: prefs.getBool(_keyHaptic) ?? true,
      darkModeEnabled: prefs.getBool(_keyDarkMode) ?? false,
    );
  }

  /// Enable or disable sound effects
  Future<void> setSoundEffects(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySound, enabled);
    state = state.copyWith(soundEffectsEnabled: enabled);
  }

  /// Enable or disable haptic feedback
  Future<void> setHapticFeedback(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptic, enabled);
    state = state.copyWith(hapticFeedbackEnabled: enabled);
  }

  /// Enable or disable dark mode
  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, enabled);
    state = state.copyWith(darkModeEnabled: enabled);
  }

  /// Restore all settings to defaults
  Future<void> restoreDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySound);
    await prefs.remove(_keyHaptic);
    await prefs.remove(_keyDarkMode);
    state = SettingsState.defaults();
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
