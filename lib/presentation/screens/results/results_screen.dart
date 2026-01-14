import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/presentation/screens/results/scoreboard_widget.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';
import 'package:pes_vres/presentation/widgets/common/secondary_button.dart';

/// Results screen - Final game results
///
/// Displays:
/// - Winner announcement (or tie)
/// - Sorted scoreboard
/// - Action buttons (Play Again, New Setup, Share, Home)
///
/// For Phase 1, uses teams passed via route extras.
/// Phase 2 will integrate Riverpod for state management.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    this.teams,
  });

  final List<Team>? teams;

  List<Team> get _sortedTeams {
    if (teams == null || teams!.isEmpty) return _getMockTeams();
    final sorted = List<Team>.from(teams!);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  List<Team> _getMockTeams() {
    // Mock data for Phase 1 if no teams passed
    return [
      Team(
        id: '1',
        name: 'Team Alpha',
        color: AppColors.teamColors[0],
        score: 42,
      ),
      Team(
        id: '2',
        name: 'Team Beta',
        color: AppColors.teamColors[1],
        score: 38,
      ),
    ];
  }

  List<Team> get _winners {
    final sorted = _sortedTeams;
    if (sorted.isEmpty) return [];
    final highestScore = sorted.first.score;
    return sorted.where((team) => team.score == highestScore).toList();
  }

  bool get _isTie => _winners.length > 1;

  String get _winnerText {
    if (_winners.isEmpty) return 'No winner';
    if (_isTie) {
      return 'It\'s a Tie!';
    }
    return '${_winners.first.name} Wins!';
  }

  IconData get _winnerIcon {
    if (_isTie) return Icons.people;
    return Icons.emoji_events;
  }

  Color get _winnerColor {
    if (_isTie) return AppColors.warning;
    return AppColors.success;
  }

  void _shareResults(BuildContext context) {
    // TODO: Phase 2 - Implement actual sharing
    // For now, show a placeholder dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Results'),
        content: Text(_buildShareText()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _buildShareText() {
    final buffer = StringBuffer();
    buffer.writeln('Say & Find - Game Results');
    buffer.writeln();

    if (_isTie) {
      buffer.writeln('Tie between:');
      for (final winner in _winners) {
        buffer.writeln('- ${winner.name}: ${winner.score} points');
      }
    } else if (_winners.isNotEmpty) {
      buffer.writeln('Winner: ${_winners.first.name}');
      buffer.writeln('Score: ${_winners.first.score} points');
    }

    buffer.writeln();
    buffer.writeln('Final Standings:');
    for (int i = 0; i < _sortedTeams.length; i++) {
      final team = _sortedTeams[i];
      buffer.writeln('${i + 1}. ${team.name}: ${team.score} points');
    }

    return buffer.toString();
  }

  void _playAgain(BuildContext context) {
    // TODO: Phase 2 - Reset game state and navigate to game
    // For now, show info that this requires state management
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Play Again will be implemented in Phase 2 with state management'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    color: _winnerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _winnerColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _winnerIcon,
                        size: 64,
                        color: _winnerColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _winnerText,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _winnerColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_isTie) ...[
                        const SizedBox(height: 12),
                        Text(
                          _winners.map((t) => t.name).join(' & '),
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
                        _winners.isEmpty
                            ? 'No scores recorded'
                            : '${_winners.first.score} ${_winners.first.score == 1 ? 'point' : 'points'}',
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
                ScoreboardWidget(teams: _sortedTeams),
                const SizedBox(height: 32),

                // Action Buttons
                Column(
                  children: [
                    // Play Again Button (disabled for Phase 1)
                    PrimaryButton(
                      onPressed: () => _playAgain(context),
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
                      onPressed: () => _shareResults(context),
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
