import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';

/// Card widget displaying a team's score
///
/// Shows team name, color, and current score in a card format.
class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.team,
    this.rank,
    this.isWinner = false,
  });

  final Team team;
  final int? rank;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isWinner ? 8 : 2,
      color: isWinner
          ? team.color.withValues(alpha: 0.1)
          : AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (rank != null) ...[
              _RankBadge(rank: rank!),
              const SizedBox(width: 16),
            ],
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: team.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isWinner) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.emoji_events,
                          color: AppColors.warning,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${team.score} ${team.score == 1 ? 'point' : 'points'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${team.score}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: team.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _getRankColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getRankText(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _getRankText() {
    switch (rank) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${rank}th';
    }
  }

  Color _getRankColor() {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.textSecondary;
    }
  }
}
