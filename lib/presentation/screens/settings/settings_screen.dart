import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/state/locale_provider.dart';
import 'package:pes_vres/presentation/state/settings_provider.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';

/// Settings screen - App preferences and configuration
///
/// Allows users to toggle:
/// - Sound effects
/// - Haptic feedback
/// - Dark mode (placeholder for future)
/// - Language selection
///
/// Phase 2: Now uses Riverpod state management with SharedPreferences persistence.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _restoreDefaults(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    ref.read(settingsProvider.notifier).restoreDefaults();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.settingsRestored),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.read(localeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: Text(l10n.english),
              value: const Locale('en'),
              groupValue: currentLocale,
              onChanged: (locale) {
                ref.read(localeProvider.notifier).setLocale(locale!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<Locale>(
              title: Text(l10n.spanish),
              value: const Locale('es'),
              groupValue: currentLocale,
              onChanged: (locale) {
                ref.read(localeProvider.notifier).setLocale(locale!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(BuildContext context, Locale locale) {
    final l10n = AppLocalizations.of(context);
    switch (locale.languageCode) {
      case 'es':
        return l10n.spanish;
      case 'en':
      default:
        return l10n.english;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // Language Section
          _SectionHeader(title: l10n.language),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(_getLanguageName(context, currentLocale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          const Divider(),

          // Audio Section
          _SectionHeader(title: l10n.audio),
          SwitchListTile(
            title: Text(l10n.soundEffects),
            subtitle: Text(l10n.soundEffectsDesc),
            value: settings.soundEffectsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setSoundEffects(value);
            },
            secondary: const Icon(Icons.volume_up),
          ),
          const Divider(),

          // Haptics Section
          _SectionHeader(title: l10n.haptics),
          SwitchListTile(
            title: Text(l10n.hapticFeedback),
            subtitle: Text(l10n.hapticFeedbackDesc),
            value: settings.hapticFeedbackEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setHapticFeedback(value);
            },
            secondary: const Icon(Icons.vibration),
          ),
          const Divider(),

          // Appearance Section
          _SectionHeader(title: l10n.appearance),
          SwitchListTile(
            title: Text(l10n.darkMode),
            subtitle: Text(l10n.darkModeDesc),
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
              child: Text(l10n.restoreDefaults),
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
                    l10n.appTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.versionNumber('1.0.0'),
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
