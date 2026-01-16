import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/presentation/screens/home/home_screen.dart';
import 'package:pes_vres/presentation/screens/how_to_play/how_to_play_screen.dart';
import 'package:pes_vres/presentation/screens/settings/settings_screen.dart';
import 'package:pes_vres/presentation/screens/setup/setup_screen.dart';
import 'package:pes_vres/presentation/screens/game/game_screen.dart';
import 'package:pes_vres/presentation/screens/results/results_screen.dart';

/// Route paths
class AppRoutes {
  static const String home = '/';
  static const String setup = '/setup';
  static const String game = '/game';
  static const String results = '/results';
  static const String settings = '/settings';
  static const String howToPlay = '/how-to-play';
}

/// Router configuration for the app
class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.setup,
          name: 'setup',
          builder: (context, state) => const SetupScreen(),
        ),
        GoRoute(
          path: AppRoutes.game,
          name: 'game',
          builder: (context, state) => const GameScreen(),
        ),
        GoRoute(
          path: AppRoutes.results,
          name: 'results',
          builder: (context, state) => const ResultsScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: AppRoutes.howToPlay,
          name: 'howToPlay',
          builder: (context, state) => const HowToPlayScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Page not found: ${state.matchedLocation}'),
        ),
      ),
    );
  }
}
