import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';
import 'package:pes_vres/presentation/widgets/common/secondary_button.dart';
import 'package:pes_vres/presentation/widgets/game/team_indicator.dart';

/// Round result dialog
///
/// Shows results after a round ends:
/// - Team name and points earned
/// - Found vs missed answers
/// - Optional source attribution
/// - "Show Answers" expandable section
/// - "Continue" button to next round
/// - "End Game" button to skip to final results
class RoundResultDialog extends StatefulWidget {
  const RoundResultDialog({
    super.key,
    required this.team,
    required this.teams,
    required this.foundAnswers,
    required this.missedAnswers,
    required this.prompt,
    required this.card,
    this.source,
    required this.pointsForAnswer,
    required this.onScoreAdjust,
    required this.onContinue,
    required this.onEndGame,
  });

  final Team team;
  final List<Team> teams;
  final List<String> foundAnswers;
  final List<String> missedAnswers;
  final String prompt;
  final CardItem card;
  final String? source;
  final int Function(String answer) pointsForAnswer;
  final ValueChanged<int> onScoreAdjust;
  final VoidCallback onContinue;
  final VoidCallback onEndGame;

  @override
  State<RoundResultDialog> createState() => _RoundResultDialogState();
}

class _RoundResultDialogState extends State<RoundResultDialog> {
  bool _showAnswers = false;
  late List<String> _foundAnswers;
  late List<String> _missedAnswers;
  late int _pointsEarned;
  late List<Team> _sortedTeams;

  @override
  void initState() {
    super.initState();
    _foundAnswers = List<String>.from(widget.foundAnswers)..sort();
    _missedAnswers = List<String>.from(widget.missedAnswers)..sort();
    _pointsEarned = _sumPoints(_foundAnswers);
    _sortedTeams = List<Team>.from(widget.teams)
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  int _sumPoints(Iterable<String> answers) {
    return answers.fold(0, (total, answer) => total + widget.pointsForAnswer(answer));
  }

  void _toggleAnswerSelection(String answer, bool currentlyFound) {
    if (currentlyFound) {
      _foundAnswers.remove(answer);
      _missedAnswers.add(answer);
    } else {
      _missedAnswers.remove(answer);
      _foundAnswers.add(answer);
    }

    _foundAnswers.sort();
    _missedAnswers.sort();

    final newPoints = _sumPoints(_foundAnswers);
    final delta = newPoints - _pointsEarned;
    if (delta != 0) {
      widget.onScoreAdjust(delta);
    }

    setState(() {
      _pointsEarned = newPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Text(
                  l10n.roundComplete,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Team Indicator
                TeamIndicator(
                  team: widget.team,
                  size: TeamIndicatorSize.large,
                ),
                const SizedBox(height: 24),

                // Points Earned
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: AppColors.success,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.nPoints(_pointsEarned),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.foundOf(
                          _foundAnswers.length,
                          _foundAnswers.length + _missedAnswers.length,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Scores So Far
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.surfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.scoresSoFar,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sortedTeams.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final team = _sortedTeams[index];
                          return Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: team.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  team.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                l10n.nPts(team.score),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Report Issue and Show Answers Toggle
                TextButton.icon(
                  onPressed: () {
                    context.push(
                      AppRoutes.reportIssue,
                      extra: ReportIssueLookback(
                        returnToGame: true,
                        card: widget.card,
                      ),
                    );
                  },
                  icon: const Icon(Icons.flag_outlined, size: 18),
                  label: Text(l10n.reportIssue),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAnswers = !_showAnswers;
                    });
                  },
                  icon: Icon(
                    _showAnswers
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                  label: Text(
                    _showAnswers ? l10n.hideAnswers : l10n.showAnswers,
                  ),
                ),

                // Answers Section (expandable)
                if (_showAnswers) ...[
                  const SizedBox(height: 16),
                  _AnswersSection(
                    prompt: widget.prompt,
                    foundAnswers: _foundAnswers,
                    missedAnswers: _missedAnswers,
                    source: widget.source,
                    pointsForAnswer: widget.pointsForAnswer,
                    onToggleAnswer: _toggleAnswerSelection,
                  ),
                  const SizedBox(height: 16),
                ],

                // Continue Button
                const SizedBox(height: 8),
                PrimaryButton(
                  onPressed: widget.onContinue,
                  isFullWidth: true,
                  child: Text(l10n.continueButton),
                ),
                const SizedBox(height: 12),

                // End Game Button
                SecondaryButton(
                  onPressed: widget.onEndGame,
                  isFullWidth: true,
                  child: Text(l10n.endGame),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswersSection extends StatelessWidget {
  const _AnswersSection({
    required this.prompt,
    required this.foundAnswers,
    required this.missedAnswers,
    this.source,
    required this.pointsForAnswer,
    required this.onToggleAnswer,
  });

  final String prompt;
  final List<String> foundAnswers;
  final List<String> missedAnswers;
  final String? source;
  final int Function(String answer) pointsForAnswer;
  final void Function(String answer, bool currentlyFound) onToggleAnswer;

  int _sumPoints(Iterable<String> answers) {
    return answers.fold(0, (total, answer) => total + pointsForAnswer(answer));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt
          Text(
            prompt,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Found Answers
          if (foundAnswers.isNotEmpty) ...[
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.foundWithCount(
                    foundAnswers.length,
                    _sumPoints(foundAnswers),
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: foundAnswers.map((answer) {
                return FilterChip(
                  selected: true,
                  onSelected: (_) => onToggleAnswer(answer, true),
                  label: Text(
                    '$answer (${l10n.nPts(pointsForAnswer(answer))})',
                    style: const TextStyle(fontSize: 12),
                  ),
                  selectedColor: AppColors.success.withValues(alpha: 0.15),
                  backgroundColor: AppColors.surfaceVariant.withValues(alpha: 0.3),
                  checkmarkColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Missed Answers
          if (missedAnswers.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.missedWithCount(missedAnswers.length),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: missedAnswers.map((answer) {
                return FilterChip(
                  selected: false,
                  onSelected: (_) => onToggleAnswer(answer, false),
                  label: Text(
                    '$answer (${l10n.nPts(pointsForAnswer(answer))})',
                    style: const TextStyle(fontSize: 12),
                  ),
                  selectedColor: AppColors.success.withValues(alpha: 0.15),
                  backgroundColor:
                      AppColors.surfaceVariant.withValues(alpha: 0.3),
                  checkmarkColor: AppColors.success,
                  side: BorderSide(color: AppColors.textSecondary),
                );
              }).toList(),
            ),
          ],

          // Source (if provided)
          if (source != null && source!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              source!,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
