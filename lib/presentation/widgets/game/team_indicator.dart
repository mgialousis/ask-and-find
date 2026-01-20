import 'package:flutter/material.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

/// Displays a team name with its color badge
///
/// Used throughout the app to show which team is active.
class TeamIndicator extends StatelessWidget {
  const TeamIndicator({
    super.key,
    required this.team,
    this.size = TeamIndicatorSize.medium,
    this.showScore = false,
  });

  final Team team;
  final TeamIndicatorSize size;
  final bool showScore;

  @override
  Widget build(BuildContext context) {
    final dimensions = _getDimensions();
    final l10n = AppLocalizations.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dimensions.badgeSize,
          height: dimensions.badgeSize,
          decoration: BoxDecoration(
            color: team.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: team.color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(width: dimensions.spacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              team.name,
              style: TextStyle(
                fontSize: dimensions.nameSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (showScore) ...[
              const SizedBox(height: 2),
              Text(
                l10n.nPoints(team.score),
                style: TextStyle(
                  fontSize: dimensions.scoreSize,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  _TeamIndicatorDimensions _getDimensions() {
    switch (size) {
      case TeamIndicatorSize.small:
        return const _TeamIndicatorDimensions(
          badgeSize: 24,
          spacing: 8,
          nameSize: 14,
          scoreSize: 12,
        );
      case TeamIndicatorSize.medium:
        return const _TeamIndicatorDimensions(
          badgeSize: 32,
          spacing: 12,
          nameSize: 18,
          scoreSize: 14,
        );
      case TeamIndicatorSize.large:
        return const _TeamIndicatorDimensions(
          badgeSize: 48,
          spacing: 16,
          nameSize: 24,
          scoreSize: 16,
        );
    }
  }
}

enum TeamIndicatorSize {
  small,
  medium,
  large,
}

class _TeamIndicatorDimensions {
  const _TeamIndicatorDimensions({
    required this.badgeSize,
    required this.spacing,
    required this.nameSize,
    required this.scoreSize,
  });

  final double badgeSize;
  final double spacing;
  final double nameSize;
  final double scoreSize;
}
