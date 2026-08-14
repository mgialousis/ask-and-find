import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

/// Card widget displaying a team's score
///
/// Shows team name, color, and current score in a card format.
class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.team,
    this.rank,
    this.isWinner = false,
    this.animateScore = false,
  });

  final Team team;
  final int? rank;
  final bool isWinner;
  final bool animateScore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      elevation: isWinner ? 8 : 2,
      color: isWinner
          ? team.color.withValues(alpha: 0.1)
          : context.palette.surface,
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
                  _ScoreText(
                    score: team.score,
                    animate: animateScore,
                    style: TextStyle(
                      fontSize: 14,
                      color: context.palette.textSecondary,
                    ),
                    formatter: (score) => l10n.nPoints(score),
                  ),
                ],
              ),
            ),
            _ScoreText(
              score: team.score,
              animate: animateScore,
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

class _ScoreText extends StatelessWidget {
  const _ScoreText({
    required this.score,
    required this.style,
    this.animate = false,
    this.formatter,
  });

  final int score;
  final TextStyle style;
  final bool animate;
  final String Function(int score)? formatter;

  @override
  Widget build(BuildContext context) {
    if (!animate) {
      return Text(
        formatter?.call(score) ?? '$score',
        style: style,
      );
    }

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: score),
      duration: const Duration(milliseconds: 1800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          formatter?.call(value) ?? '$value',
          style: style,
        );
      },
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _getRankColor(context),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getRankText(l10n),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String _getRankText(AppLocalizations l10n) {
    switch (rank) {
      case 1:
        return l10n.rank1st;
      case 2:
        return l10n.rank2nd;
      case 3:
        return l10n.rank3rd;
      default:
        return l10n.rankNth(rank);
    }
  }

  Color _getRankColor(BuildContext context) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return context.palette.textSecondary;
    }
  }
}
