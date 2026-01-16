import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
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
class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

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

  String _winnerText(WidgetRef ref) {
    final winners = _winners(ref);
    if (winners.isEmpty) return 'No winner';
    if (_isTie(ref)) {
      return 'It\'s a Tie!';
    }
    return '${winners.first.name} Wins!';
  }

  IconData _winnerIcon(WidgetRef ref) {
    if (_isTie(ref)) return Icons.people;
    return Icons.emoji_events;
  }

  Color _winnerColor(WidgetRef ref) {
    if (_isTie(ref)) return AppColors.warning;
    return AppColors.success;
  }

  void _shareResults(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Results'),
        content: Text(_buildShareText(ref)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _buildShareText(WidgetRef ref) {
    final buffer = StringBuffer();
    final sortedTeams = _sortedTeams(ref);
    final winners = _winners(ref);
    final isTie = _isTie(ref);

    buffer.writeln('Say & Find - Game Results');
    buffer.writeln();

    if (isTie) {
      buffer.writeln('Tie between:');
      for (final winner in winners) {
        buffer.writeln('- ${winner.name}: ${winner.score} points');
      }
    } else if (winners.isNotEmpty) {
      buffer.writeln('Winner: ${winners.first.name}');
      buffer.writeln('Score: ${winners.first.score} points');
    }

    buffer.writeln();
    buffer.writeln('Final Standings:');
    for (int i = 0; i < sortedTeams.length; i++) {
      final team = sortedTeams[i];
      buffer.writeln('${i + 1}. ${team.name}: ${team.score} points');
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
    context.pushReplacementNamed(AppRoutes.game);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedTeams = _sortedTeams(ref);
    final winners = _winners(ref);
    final isTie = _isTie(ref);
    final winnerColor = _winnerColor(ref);
    final winnerIcon = _winnerIcon(ref);
    final winnerText = _winnerText(ref);

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
                const Text(
                  'Game Over!',
                  style: TextStyle(
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
                      Text(
                        winners.isEmpty
                            ? 'No scores recorded'
                            : '${winners.first.score} ${winners.first.score == 1 ? 'point' : 'points'}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Scoreboard
                ScoreboardWidget(teams: sortedTeams),
                const SizedBox(height: 32),

                // Action Buttons
                Column(
                  children: [
                    // Play Again Button
                    PrimaryButton(
                      onPressed: () => _playAgain(context, ref),
                      isFullWidth: true,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.replay, size: 20),
                          SizedBox(width: 8),
                          Text('Play Again'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // New Setup Button
                    SecondaryButton(
                      onPressed: () {
                        context.goNamed(AppRoutes.setup);
                      },
                      isFullWidth: true,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, size: 20),
                          SizedBox(width: 8),
                          Text('New Setup'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Share Results Button
                    SecondaryButton(
                      onPressed: () => _shareResults(context, ref),
                      isFullWidth: true,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, size: 20),
                          SizedBox(width: 8),
                          Text('Share Results'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Home Button
                    SecondaryButton(
                      onPressed: () {
                        context.goNamed(AppRoutes.home);
                      },
                      isFullWidth: true,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, size: 20),
                          SizedBox(width: 8),
                          Text('Home'),
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
