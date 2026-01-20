import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/widgets/game/team_indicator.dart';

/// Game header widget
///
/// Displays:
/// - Round counter ("Round 3 of 10")
/// - Current team indicator with color badge
/// - Optional found counter during active gameplay
class GameHeader extends StatelessWidget {
  const GameHeader({
    super.key,
    required this.currentRound,
    required this.totalRounds,
    required this.currentTeam,
    this.foundCount,
    this.totalAnswers,
  });

  final int currentRound;
  final int totalRounds;
  final Team currentTeam;
  final int? foundCount;
  final int? totalAnswers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Round Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.roundOf(currentRound, totalRounds),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              if (foundCount != null && totalAnswers != null)
                _FoundCounter(
                  found: foundCount!,
                  total: totalAnswers!,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Current Team
          TeamIndicator(
            team: currentTeam,
            size: TeamIndicatorSize.large,
          ),
        ],
      ),
    );
  }
}

class _FoundCounter extends StatelessWidget {
  const _FoundCounter({
    required this.found,
    required this.total,
  });

  final int found;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.success,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '$found/$total',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
