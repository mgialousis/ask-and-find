import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/presentation/widgets/game/score_card.dart';

/// Scoreboard widget
///
/// Displays sorted list of teams by score (descending)
/// Shows rank indicators with medals/trophies for top 3
/// Highlights winner with special styling
class ScoreboardWidget extends StatelessWidget {
  const ScoreboardWidget({
    super.key,
    required this.teams,
  });

  final List<Team> teams;

  List<Team> get _sortedTeams {
    final sorted = List<Team>.from(teams);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  int _getHighestScore() {
    if (teams.isEmpty) return 0;
    return teams.map((t) => t.score).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final sortedTeams = _sortedTeams;
    final highestScore = _getHighestScore();

    return Column(
      children: [
        // Scoreboard Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Final Scores',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${sortedTeams.length} ${sortedTeams.length == 1 ? 'Team' : 'Teams'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Team Score Cards
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(
              color: AppColors.surfaceVariant,
              width: 1,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: sortedTeams.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final team = sortedTeams[index];
              final rank = index + 1;
              final isWinner = team.score == highestScore;

              return ScoreCard(
                team: team,
                rank: rank,
                isWinner: isWinner,
              );
            },
          ),
        ),
      ],
    );
  }
}
