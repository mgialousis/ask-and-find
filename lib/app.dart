import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_theme.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/state/locale_provider.dart';
import 'package:pes_vres/presentation/state/settings_provider.dart';

/// Main app widget with Riverpod ProviderScope and routing
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: const _AppContent(),
    );
  }
}

/// Inner app content that can access providers
class _AppContent extends ConsumerWidget {
  const _AppContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final darkModeEnabled = ref.watch(
      settingsProvider.select((s) => s.darkModeEnabled),
    );

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.createRouter(),

      // Localization configuration
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
