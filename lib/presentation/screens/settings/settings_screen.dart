import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';

/// Settings screen - App preferences and configuration
///
/// Allows users to toggle:
/// - Sound effects
/// - Haptic feedback
/// - Dark mode (placeholder for future)
///
/// For Phase 1, uses local state only. Phase 2 will add persistence.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEffectsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _darkModeEnabled = false;

  void _restoreDefaults() {
    setState(() {
      _soundEffectsEnabled = true;
      _hapticFeedbackEnabled = true;
      _darkModeEnabled = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings restored to defaults'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // Audio Section
          _SectionHeader(title: 'Audio'),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Play sounds during gameplay'),
            value: _soundEffectsEnabled,
            onChanged: (value) {
              setState(() {
                _soundEffectsEnabled = value;
              });
            },
            secondary: const Icon(Icons.volume_up),
          ),
          const Divider(),

          // Haptics Section
          _SectionHeader(title: 'Haptics'),
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate on interactions'),
            value: _hapticFeedbackEnabled,
            onChanged: (value) {
              setState(() {
                _hapticFeedbackEnabled = value;
              });
            },
            secondary: const Icon(Icons.vibration),
          ),
          const Divider(),

          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Coming soon in a future update'),
            value: _darkModeEnabled,
            onChanged: null, // Disabled for now
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),

          // Reset Section
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryButton(
              onPressed: _restoreDefaults,
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
