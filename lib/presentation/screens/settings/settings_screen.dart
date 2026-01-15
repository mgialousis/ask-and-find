import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/presentation/state/settings_provider.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';

/// Settings screen - App preferences and configuration
///
/// Allows users to toggle:
/// - Sound effects
/// - Haptic feedback
/// - Dark mode (placeholder for future)
///
/// Phase 2: Now uses Riverpod state management with SharedPreferences persistence.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _restoreDefaults(BuildContext context, WidgetRef ref) {
    ref.read(settingsProvider.notifier).restoreDefaults();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings restored to defaults'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // Audio Section
          const _SectionHeader(title: 'Audio'),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Play sounds during gameplay'),
            value: settings.soundEffectsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setSoundEffects(value);
            },
            secondary: const Icon(Icons.volume_up),
          ),
          const Divider(),

          // Haptics Section
          const _SectionHeader(title: 'Haptics'),
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate on interactions'),
            value: settings.hapticFeedbackEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setHapticFeedback(value);
            },
            secondary: const Icon(Icons.vibration),
          ),
          const Divider(),

          // Appearance Section
          const _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Coming soon in a future update'),
            value: settings.darkModeEnabled,
            onChanged: null, // Disabled for now
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),

          // Reset Section
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryButton(
              onPressed: () => _restoreDefaults(context, ref),
              isFullWidth: true,
              child: const Text('Restore Defaults'),
            ),
          ),
          const SizedBox(height: 16),

          // App Info
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Say & Find',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
