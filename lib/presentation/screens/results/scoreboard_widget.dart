import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/widgets/game/score_card.dart';

/// Scoreboard widget
///
/// Displays sorted list of teams by score (descending)
/// Shows rank indicators with medals/trophies for top 3
/// Highlights winner with special styling
class ScoreboardWidget extends StatefulWidget {
  const ScoreboardWidget({
    super.key,
    required this.teams,
    this.animate = true,
  });

  final List<Team> teams;
  final bool animate;

  @override
  State<ScoreboardWidget> createState() => _ScoreboardWidgetState();
}

class _ScoreboardWidgetState extends State<ScoreboardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  List<Team> get _sortedTeams {
    final sorted = List<Team>.from(widget.teams);
    sorted.sort((a, b) => b.score.compareTo(a.score));
    return sorted;
  }

  int _getHighestScore() {
    if (widget.teams.isEmpty) return 0;
    return widget.teams.map((t) => t.score).reduce((a, b) => a > b ? a : b);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(ScoreboardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    } else if (!widget.animate && _controller.value != 1) {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedTeams = _sortedTeams;
    final highestScore = _getHighestScore();
    final l10n = AppLocalizations.of(context);

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
              Text(
                l10n.finalScores,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '${sortedTeams.length} ${sortedTeams.length == 1 ? l10n.team : l10n.teams}',
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
              final start = (index * 0.12).clamp(0.0, 1.0);
              final end = (start + 0.5).clamp(0.0, 1.0);
              final animation = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  start,
                  end,
                  curve: Curves.easeOutCubic,
                ),
              );

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.12),
                    end: Offset.zero,
                  ).animate(animation),
                  child: ScoreCard(
                    team: team,
                    rank: rank,
                    isWinner: isWinner,
                    animateScore: widget.animate,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
