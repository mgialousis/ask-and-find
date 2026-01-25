import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/presentation/screens/home/home_screen.dart';
import 'package:pes_vres/presentation/screens/how_to_play/how_to_play_screen.dart';
import 'package:pes_vres/presentation/screens/settings/settings_screen.dart';
import 'package:pes_vres/presentation/screens/setup/setup_screen.dart';
import 'package:pes_vres/presentation/screens/game/game_screen.dart';
import 'package:pes_vres/presentation/screens/results/results_screen.dart';
import 'package:pes_vres/presentation/screens/submission/card_submission_screen.dart';
import 'package:pes_vres/presentation/screens/submission/submission_success_screen.dart';

/// Route paths
class AppRoutes {
  static const String home = '/';
  static const String setup = '/setup';
  static const String game = '/game';
  static const String results = '/results';
  static const String settings = '/settings';
  static const String howToPlay = '/how-to-play';
  static const String cardSubmission = '/submit-card';
  static const String reportIssue = '/report-issue';
  static const String submissionSuccess = '/submission-success';
}

class ReportIssueLookback {
  const ReportIssueLookback({
    required this.returnToGame,
    this.card,
  });

  final bool returnToGame;
  final CardItem? card;
}

class CardSubmissionLookback {
  const CardSubmissionLookback({
    required this.returnToGame,
  });

  final bool returnToGame;
}

class SubmissionSuccessArgs {
  const SubmissionSuccessArgs({
    required this.returnToGame,
  });

  final bool returnToGame;
}

/// Route names (for use with pushNamed)
class AppRouteNames {
  static const String home = 'home';
  static const String setup = 'setup';
  static const String game = 'game';
  static const String results = 'results';
  static const String settings = 'settings';
  static const String howToPlay = 'howToPlay';
  static const String cardSubmission = 'cardSubmission';
  static const String reportIssue = 'reportIssue';
  static const String submissionSuccess = 'submissionSuccess';
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
        GoRoute(
          path: AppRoutes.cardSubmission,
          name: 'cardSubmission',
          builder: (context, state) {
            final CardSubmissionLookback? lookback =
                state.extra is CardSubmissionLookback
                    ? state.extra as CardSubmissionLookback
                    : null;
            return CardSubmissionScreen(
              mode: SubmissionMode.newCard,
              returnToGame: lookback?.returnToGame ?? false,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.reportIssue,
          name: 'reportIssue',
          builder: (context, state) {
            final ReportIssueLookback? lookback = state.extra
                    is ReportIssueLookback
                ? state.extra as ReportIssueLookback
                : null;
            final preselectedCard = lookback?.card ??
                (state.extra is CardItem ? state.extra as CardItem : null);
            return CardSubmissionScreen(
              mode: SubmissionMode.correction,
              preselectedCard: preselectedCard,
              returnToGame: lookback?.returnToGame ?? false,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.submissionSuccess,
          name: 'submissionSuccess',
          builder: (context, state) {
            final args = state.extra is SubmissionSuccessArgs
                ? state.extra as SubmissionSuccessArgs
                : const SubmissionSuccessArgs(returnToGame: false);
            return SubmissionSuccessScreen(returnToGame: args.returnToGame);
          },
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
