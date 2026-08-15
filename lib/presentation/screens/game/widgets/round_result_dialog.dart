import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/card_language_mode.dart';
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
    required this.card,
    required this.cardLanguageMode,
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
  final CardItem card;
  final CardLanguageMode cardLanguageMode;
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
    _foundAnswers = List<String>.from(widget.foundAnswers);
    _missedAnswers = List<String>.from(widget.missedAnswers);
    _sortAnswers();
    _pointsEarned = _sumPoints(_foundAnswers);
    _sortedTeams = List<Team>.from(widget.teams)
      ..sort((a, b) => b.score.compareTo(a.score));
  }

  int _sumPoints(Iterable<String> answers) {
    return answers.fold(
      0,
      (total, answer) => total + widget.pointsForAnswer(answer),
    );
  }

  void _sortAnswers() {
    int compare(String left, String right) {
      final leftLabel = widget.card.getPrimaryAnswer(
        left,
        widget.cardLanguageMode,
      );
      final rightLabel = widget.card.getPrimaryAnswer(
        right,
        widget.cardLanguageMode,
      );
      return leftLabel.compareTo(rightLabel);
    }

    _foundAnswers.sort(compare);
    _missedAnswers.sort(compare);
  }

  void _toggleAnswerSelection(String answer, bool currentlyFound) {
    if (currentlyFound) {
      _foundAnswers.remove(answer);
      _missedAnswers.add(answer);
    } else {
      _missedAnswers.remove(answer);
      _foundAnswers.add(answer);
    }

    _sortAnswers();

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
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: context.palette.textPrimary,
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
                      border: Border.all(color: AppColors.success, width: 2),
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
                            color: context.palette.textSecondary,
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
                      color: context.palette.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.palette.surfaceVariant,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.scoresSoFar,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: context.palette.textPrimary,
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
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: context.palette.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  l10n.nPts(team.score),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: context.palette.textSecondary,
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
                      foregroundColor: context.palette.textSecondary,
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
                      prompt: widget.card.getPrimaryPrompt(
                        widget.cardLanguageMode,
                      ),
                      secondaryPrompt: widget.card.getSecondaryPrompt(
                        widget.cardLanguageMode,
                      ),
                      foundAnswers: _foundAnswers,
                      missedAnswers: _missedAnswers,
                      source: widget.source,
                      pointsForAnswer: widget.pointsForAnswer,
                      primaryAnswerFor: (answer) => widget.card
                          .getPrimaryAnswer(answer, widget.cardLanguageMode),
                      secondaryAnswerFor: (answer) => widget.card
                          .getSecondaryAnswer(answer, widget.cardLanguageMode),
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
      ),
    );
  }
}

class _AnswersSection extends StatelessWidget {
  const _AnswersSection({
    required this.prompt,
    this.secondaryPrompt,
    required this.foundAnswers,
    required this.missedAnswers,
    this.source,
    required this.pointsForAnswer,
    required this.primaryAnswerFor,
    required this.secondaryAnswerFor,
    required this.onToggleAnswer,
  });

  final String prompt;
  final String? secondaryPrompt;
  final List<String> foundAnswers;
  final List<String> missedAnswers;
  final String? source;
  final int Function(String answer) pointsForAnswer;
  final String Function(String answer) primaryAnswerFor;
  final String? Function(String answer) secondaryAnswerFor;
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
        color: context.palette.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.palette.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt
          Text(
            prompt,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.palette.textPrimary,
            ),
          ),
          if (secondaryPrompt != null) ...[
            const SizedBox(height: 6),
            Text(
              secondaryPrompt!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: context.palette.textSecondary,
              ),
            ),
          ],
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
                  label: _ResultAnswerLabel(
                    primary: primaryAnswerFor(answer),
                    secondary: secondaryAnswerFor(answer),
                    points: l10n.nPts(pointsForAnswer(answer)),
                  ),
                  selectedColor: AppColors.success.withValues(alpha: 0.15),
                  backgroundColor: context.palette.surfaceVariant.withValues(
                    alpha: 0.3,
                  ),
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
                  color: context.palette.textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.missedWithCount(missedAnswers.length),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.palette.textSecondary,
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
                  label: _ResultAnswerLabel(
                    primary: primaryAnswerFor(answer),
                    secondary: secondaryAnswerFor(answer),
                    points: l10n.nPts(pointsForAnswer(answer)),
                  ),
                  selectedColor: AppColors.success.withValues(alpha: 0.15),
                  backgroundColor: context.palette.surfaceVariant.withValues(
                    alpha: 0.3,
                  ),
                  checkmarkColor: AppColors.success,
                  side: BorderSide(color: context.palette.textSecondary),
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
                color: context.palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultAnswerLabel extends StatelessWidget {
  const _ResultAnswerLabel({
    required this.primary,
    required this.secondary,
    required this.points,
  });

  final String primary;
  final String? secondary;
  final String points;

  @override
  Widget build(BuildContext context) {
    if (secondary == null) {
      return Text(
        '$primary ($points)',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primary,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
        if (secondary != null)
          Text(
            secondary!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: context.palette.textSecondary,
            ),
          ),
        Text(points, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
