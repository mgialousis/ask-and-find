import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/analytics/analytics_service.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/screens/results/scoreboard_widget.dart';
import 'package:pes_vres/presentation/state/game_setup_provider.dart';
import 'package:pes_vres/presentation/state/game_state_provider.dart';
import 'package:pes_vres/presentation/state/timer_provider.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';
import 'package:pes_vres/presentation/widgets/common/secondary_button.dart';

/// Results screen - Final game results
///
/// Displays:
/// - Winner announcement (or tie)
/// - Sorted scoreboard
/// - Action buttons (Play Again, New Setup, Share, Home)
///
/// Phase 2: Now uses Riverpod providers for state management.
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  late final ConfettiController _confettiController;
  bool _didPlayConfetti = false;
  bool _didCaptureCompletion = false;
  OverlayEntry? _confettiOverlay;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playConfettiIfNeeded();
      _captureGameCompleted();
    });
  }

  void _showConfettiOverlay() {
    _confettiOverlay?.remove();
    _confettiOverlay = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: IgnorePointer(
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.12,
            numberOfParticles: 16,
            gravity: 0.2,
            minBlastForce: 10,
            maxBlastForce: 25,
            particleDrag: 0.05,
            shouldLoop: false,
            colors: const [
              Color(0xFFF94144),
              Color(0xFFF3722C),
              Color(0xFFF9C74F),
              Color(0xFF90BE6D),
              Color(0xFF43AA8B),
              Color(0xFF577590),
            ],
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );

    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }
    overlay.insert(_confettiOverlay!);

    Future.delayed(const Duration(seconds: 6), () {
      _confettiOverlay?.remove();
      _confettiOverlay = null;
    });
  }

  void _playConfettiIfNeeded() {
    if (_didPlayConfetti) return;
    _didPlayConfetti = true;
    _showConfettiOverlay();
    _confettiController.play();
  }

  void _captureGameCompleted() {
    if (_didCaptureCompletion) return;
    _didCaptureCompletion = true;

    final setupState = ref.read(gameSetupProvider);
    final totalPoints =
        setupState.teams.fold<int>(0, (total, team) => total + team.score);
    final winners = _winners(ref);
    final isTie = _isTie(ref);
    final winnerIndices = winners
        .map((winner) => setupState.teams.indexOf(winner))
        .where((index) => index >= 0)
        .toList();

    unawaited(
      AnalyticsService.instance.capture(
        'game_completed',
        properties: {
          'total_rounds': setupState.config.numberOfRounds,
          'total_points': totalPoints,
          'winner_indices': winnerIndices,
          'is_tie': isTie,
        },
      ),
    );
  }

  @override
  void dispose() {
    _confettiOverlay?.remove();
    _confettiOverlay = null;
    _confettiController.dispose();
    super.dispose();
  }

  List<Team> _sortedTeams(WidgetRef ref) {
    final setupState = ref.watch(gameSetupProvider);
    final sorted = List<Team>.from(setupState.teams);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  List<Team> _winners(WidgetRef ref) {
    final sorted = _sortedTeams(ref);
    if (sorted.isEmpty) return [];
    final highestScore = sorted.first.score;
    return sorted.where((team) => team.score == highestScore).toList();
  }

  bool _isTie(WidgetRef ref) => _winners(ref).length > 1;

  String _winnerText(AppLocalizations l10n, WidgetRef ref) {
    final winners = _winners(ref);
    if (winners.isEmpty) return l10n.noWinner;
    if (_isTie(ref)) {
      return l10n.itsATie;
    }
    return l10n.teamWins(winners.first.name);
  }

  IconData _winnerIcon(WidgetRef ref) {
    if (_isTie(ref)) return Icons.people;
    return Icons.emoji_events;
  }

  Color _winnerColor(WidgetRef ref) {
    if (_isTie(ref)) return AppColors.warning;
    return AppColors.success;
  }

  void _shareResults(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.shareResults),
        content: Text(_buildShareText(ref, l10n)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  String _buildShareText(WidgetRef ref, AppLocalizations l10n) {
    final buffer = StringBuffer();
    final sortedTeams = _sortedTeams(ref);
    final winners = _winners(ref);
    final isTie = _isTie(ref);

    buffer.writeln(l10n.shareTitle);
    buffer.writeln();

    if (isTie) {
      buffer.writeln(l10n.shareTie);
      for (final winner in winners) {
        buffer.writeln('- ${winner.name}: ${l10n.nPoints(winner.score)}');
      }
    } else if (winners.isNotEmpty) {
      buffer.writeln('${l10n.shareWinner} ${winners.first.name}');
      buffer.writeln('${l10n.shareScore} ${l10n.nPoints(winners.first.score)}');
    }

    buffer.writeln();
    buffer.writeln(l10n.shareFinalStandings);
    for (int i = 0; i < sortedTeams.length; i++) {
      final team = sortedTeams[i];
      buffer.writeln('${i + 1}. ${team.name}: ${l10n.nPoints(team.score)}');
    }

    return buffer.toString();
  }

  void _playAgain(BuildContext context, WidgetRef ref) {
    // Reset team scores in setup provider
    ref.read(gameSetupProvider.notifier).resetScores();

    // Reset game state provider
    ref.read(gameStateProvider.notifier).reset();

    // Reset timer provider
    ref.read(timerProvider.notifier).reset();

    // Navigate to game screen
    context.pushReplacementNamed('game');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _playConfettiIfNeeded();
    });

    final sortedTeams = _sortedTeams(ref);
    final winners = _winners(ref);
    final isTie = _isTie(ref);
    final winnerColor = _winnerColor(ref);
    final winnerIcon = _winnerIcon(ref);
    final l10n = AppLocalizations.of(context);
    final winnerText = _winnerText(l10n, ref);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Game Over Header
                const SizedBox(height: 24),
                Text(
                  l10n.gameOver,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),

                // Winner Announcement
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: winnerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: winnerColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        winnerIcon,
                        size: 64,
                        color: winnerColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        winnerText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: winnerColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isTie) ...[
                        const SizedBox(height: 12),
                        Text(
                          winners.map((t) => t.name).join(' & '),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (winners.isEmpty)
                        Text(
                          l10n.noScoresRecorded,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        )
                      else
                        TweenAnimationBuilder<int>(
                          tween: IntTween(begin: 0, end: winners.first.score),
                          duration: const Duration(milliseconds: 2400),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Text(
                              l10n.nPoints(value),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Scoreboard
                ScoreboardWidget(teams: sortedTeams, animate: true),
                const SizedBox(height: 32),

                // Action Buttons
                Column(
                  children: [
                    // Play Again Button
                    PrimaryButton(
                      onPressed: () => _playAgain(context, ref),
                      isFullWidth: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.replay, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.playAgain),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // New Setup Button
                    SecondaryButton(
                      onPressed: () {
                        ref.read(gameSetupProvider.notifier).reset();
                        ref.read(gameStateProvider.notifier).reset();
                        ref.read(timerProvider.notifier).reset();
                        context.goNamed('setup');
                      },
                      isFullWidth: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.settings, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.newSetup),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Share Results Button
                    SecondaryButton(
                      onPressed: () => _shareResults(context, ref, l10n),
                      isFullWidth: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.share, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.shareResults),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Home Button
                    SecondaryButton(
                      onPressed: () {
                        ref.read(gameSetupProvider.notifier).reset();
                        ref.read(gameStateProvider.notifier).reset();
                        ref.read(timerProvider.notifier).reset();
                        context.goNamed('home');
                      },
                      isFullWidth: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.home, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.home),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
