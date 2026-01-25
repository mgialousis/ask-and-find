import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pes_vres/core/analytics/analytics_service.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/screens/submission/widgets/answer_list_editor.dart';
import 'package:pes_vres/presentation/screens/submission/widgets/card_preview_widget.dart';
import 'package:pes_vres/presentation/screens/submission/widgets/card_selector_dialog.dart';
import 'package:pes_vres/presentation/screens/submission/widgets/issue_type_selector.dart';
import 'package:pes_vres/presentation/state/submission_form_provider.dart';
import 'package:pes_vres/presentation/state/submission_provider.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';

/// Screen mode for card submission
enum SubmissionMode {
  newCard,
  correction,
}

/// Screen for submitting new cards or reporting issues with existing cards
class CardSubmissionScreen extends ConsumerStatefulWidget {
  const CardSubmissionScreen({
    super.key,
    this.mode = SubmissionMode.newCard,
    this.preselectedCard,
    this.returnToGame = false,
  });

  /// The submission mode
  final SubmissionMode mode;

  /// Pre-selected card for correction mode (from round result dialog)
  final CardItem? preselectedCard;

  /// Whether to return to the game flow after reporting an issue
  final bool returnToGame;

  @override
  ConsumerState<CardSubmissionScreen> createState() =>
      _CardSubmissionScreenState();
}

class _CardSubmissionScreenState extends ConsumerState<CardSubmissionScreen> {
  late SubmissionMode _mode;
  final _formKey = GlobalKey<FormState>();
  String? _appVersion;

  // Controllers for text fields
  final _promptController = TextEditingController();
  final _sourceController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mode = widget.mode;
    _loadAppVersion();
    unawaited(
      AnalyticsService.instance.capture(
        'submission_opened',
        properties: {
          'mode': _mode.name,
        },
      ),
    );

    // Initialize form based on mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_mode == SubmissionMode.newCard) {
        ref.read(newCardFormProvider.notifier).reset();
        ref.read(newCardFormProvider.notifier).initializeAnswers(10);
      } else {
        ref.read(correctionFormProvider.notifier).reset();
        if (widget.preselectedCard != null) {
          ref
              .read(correctionFormProvider.notifier)
              .setSelectedCard(widget.preselectedCard);
        }
      }
    });
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      final buildSuffix =
          info.buildNumber.isNotEmpty ? '+${info.buildNumber}' : '';
      setState(() {
        _appVersion = '${info.version}$buildSuffix';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _appVersion = null;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _sourceController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    if (_mode == SubmissionMode.newCard) {
      final form = ref.read(newCardFormProvider);
      final result = await ref.read(submissionProvider.notifier).submitNewCard(
            promptEn: form.promptEn,
            answersEn: form.answersEn.where((a) => a.isNotEmpty).toList(),
            difficulty: form.difficulty!,
            source: form.source.isNotEmpty ? form.source : null,
            submitterName: form.submitterName.isNotEmpty ? form.submitterName : null,
            submitterEmail:
                form.submitterEmail.isNotEmpty ? form.submitterEmail : null,
            appVersion: _appVersion,
            locale: locale,
          );

      _handleResult(result, l10n);
    } else {
      final form = ref.read(correctionFormProvider);
      final result =
          await ref.read(submissionProvider.notifier).submitCorrection(
                existingCardId: form.selectedCard!.id,
                existingCardPrompt: form.selectedCard!.promptEn,
                issueType: form.issueType!,
                issueDescription: form.issueDescription,
                submitterEmail:
                    form.submitterEmail.isNotEmpty ? form.submitterEmail : null,
                appVersion: _appVersion,
                locale: locale,
              );

      _handleResult(result, l10n);
    }
  }

  void _handleResult(SubmissionResult result, AppLocalizations l10n) {
    if (!mounted) return;

    unawaited(
      AnalyticsService.instance.capture(
        'submission_submitted',
        properties: {
          'mode': _mode.name,
          'result': result.name,
          'locale': Localizations.localeOf(context).languageCode,
        },
      ),
    );

    switch (result) {
      case SubmissionResult.success:
        _navigateAfterSubmit();
        break;
      case SubmissionResult.savedLocally:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.offlineSubmissionSaved),
            backgroundColor: AppColors.warning,
          ),
        );
        _navigateAfterSubmit();
        break;
      case SubmissionResult.failed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.submissionError),
            backgroundColor: AppColors.error,
          ),
        );
        break;
    }
  }

  void _navigateAfterSubmit() {
    if (widget.returnToGame) {
      context.push(
        AppRoutes.submissionSuccess,
        extra: const SubmissionSuccessArgs(returnToGame: true),
      );
      return;
    }
    context.go(AppRoutes.submissionSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final submissionState = ref.watch(submissionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _mode == SubmissionMode.newCard
              ? l10n.submitCardTitle
              : l10n.reportIssueTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mode toggle
              _ModeToggle(
                mode: _mode,
                onModeChanged: (mode) {
                  setState(() {
                    _mode = mode;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Form content based on mode
              if (_mode == SubmissionMode.newCard)
                _NewCardForm(
                  promptController: _promptController,
                  sourceController: _sourceController,
                  nameController: _nameController,
                  emailController: _emailController,
                )
              else
                _CorrectionForm(
                  descriptionController: _descriptionController,
                  emailController: _emailController,
                  preselectedCard: widget.preselectedCard,
                ),

              const SizedBox(height: 32),

              // Submit button
              PrimaryButton(
                onPressed: submissionState.isSubmitting ? null : _handleSubmit,
                isFullWidth: true,
                child: submissionState.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _mode == SubmissionMode.newCard
                            ? l10n.submitCard
                            : l10n.submitReport,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toggle between new card and correction modes
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.mode,
    required this.onModeChanged,
  });

  final SubmissionMode mode;
  final ValueChanged<SubmissionMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SegmentedButton<SubmissionMode>(
      segments: [
        ButtonSegment(
          value: SubmissionMode.newCard,
          label: Text(l10n.submitNewCard),
          icon: const Icon(Icons.add_circle_outline),
        ),
        ButtonSegment(
          value: SubmissionMode.correction,
          label: Text(l10n.reportIssue),
          icon: const Icon(Icons.flag_outlined),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) {
        onModeChanged(selection.first);
      },
    );
  }
}

/// Form for submitting a new card
class _NewCardForm extends ConsumerWidget {
  const _NewCardForm({
    required this.promptController,
    required this.sourceController,
    required this.nameController,
    required this.emailController,
  });

  final TextEditingController promptController;
  final TextEditingController sourceController;
  final TextEditingController nameController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final form = ref.watch(newCardFormProvider);
    final notifier = ref.read(newCardFormProvider.notifier);
    final previewPrompt =
        form.promptEn.trim().isNotEmpty ? form.promptEn.trim() : l10n.questionHint;
    final previewAnswers = form.answersEn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question field
        _SectionHeader(title: l10n.questionLabel),
        TextFormField(
          controller: promptController,
          decoration: InputDecoration(
            hintText: l10n.questionHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 2,
          maxLength: 200,
          onChanged: notifier.setPrompt,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.validationQuestionRequired;
            }
            if (value.length < 10) {
              return l10n.validationQuestionTooShort;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Difficulty selector
        _SectionHeader(title: l10n.difficulty),
        _DifficultySelector(
          value: form.difficulty,
          onChanged: notifier.setDifficulty,
        ),
        const SizedBox(height: 16),

        // Answers list
        _SectionHeader(title: l10n.answersLabel),
        Text(
          l10n.answersHint,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        AnswerListEditor(
          answers: form.answersEn,
          onAnswersChanged: notifier.setAnswers,
          minAnswers: 10,
          maxAnswers: 10,
        ),
        const SizedBox(height: 16),

        // Preview
        if (previewAnswers.any((answer) => answer.trim().isNotEmpty) ||
            form.promptEn.trim().isNotEmpty) ...[
          _SectionHeader(title: l10n.previewCard),
          CardPreviewWidget(
            prompt: previewPrompt,
            answers: previewAnswers,
            difficulty: form.difficulty,
          ),
          const SizedBox(height: 16),
        ],

        // Source field (optional)
        _SectionHeader(title: l10n.sourceLabel, isOptional: true),
        TextFormField(
          controller: sourceController,
          decoration: InputDecoration(
            hintText: l10n.sourceHint,
            border: const OutlineInputBorder(),
          ),
          maxLength: 200,
          onChanged: notifier.setSource,
        ),
        const SizedBox(height: 16),

        // Contact info section
        _SectionHeader(title: l10n.yourNameLabel, isOptional: true),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: l10n.yourNameHint,
            border: const OutlineInputBorder(),
          ),
          onChanged: notifier.setSubmitterName,
        ),
        const SizedBox(height: 16),

        _SectionHeader(title: l10n.yourEmailLabel, isOptional: true),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: l10n.yourEmailHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.setSubmitterEmail,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
              if (!emailRegex.hasMatch(value)) {
                return l10n.validationInvalidEmail;
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Form for submitting a correction
class _CorrectionForm extends ConsumerWidget {
  const _CorrectionForm({
    required this.descriptionController,
    required this.emailController,
    this.preselectedCard,
  });

  final TextEditingController descriptionController;
  final TextEditingController emailController;
  final CardItem? preselectedCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final form = ref.watch(correctionFormProvider);
    final notifier = ref.read(correctionFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card selector
        _SectionHeader(title: l10n.cardBeingCorrected),
        if (form.selectedCard != null) ...[
          _SelectedCardDisplay(card: form.selectedCard!),
          TextButton.icon(
            onPressed: () => _showCardSelector(context, notifier),
            icon: const Icon(Icons.swap_horiz),
            label: Text(l10n.changeCard),
          ),
          const SizedBox(height: 12),
          _SectionHeader(title: l10n.previewCard),
          CardPreviewWidget(
            prompt: form.selectedCard!
                .getPrompt(Localizations.localeOf(context)),
            answers: form.selectedCard!
                .getAnswers(Localizations.localeOf(context)),
            difficulty: form.selectedCard!.difficulty,
            maxAnswers: 10,
          ),
        ] else
          OutlinedButton.icon(
            onPressed: () => _showCardSelector(context, notifier),
            icon: const Icon(Icons.add),
            label: Text(l10n.selectCard),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        const SizedBox(height: 16),

        // Issue type selector
        _SectionHeader(title: l10n.issueTypeLabel),
        IssueTypeSelector(
          value: form.issueType,
          onChanged: notifier.setIssueType,
        ),
        const SizedBox(height: 16),

        // Description field
        _SectionHeader(title: l10n.describeIssue),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            hintText: l10n.describeIssueHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 5,
          maxLength: 1000,
          onChanged: notifier.setIssueDescription,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.validationDescriptionRequired;
            }
            if (value.length < 20) {
              return l10n.validationDescriptionTooShort;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email field (optional)
        _SectionHeader(title: l10n.yourEmailLabel, isOptional: true),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: l10n.yourEmailHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.setSubmitterEmail,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
              if (!emailRegex.hasMatch(value)) {
                return l10n.validationInvalidEmail;
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  void _showCardSelector(BuildContext context, CorrectionFormNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => CardSelectorDialog(
        onCardSelected: (card) {
          notifier.setSelectedCard(card);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Displays the selected card for correction
class _SelectedCardDisplay extends StatelessWidget {
  const _SelectedCardDisplay({required this.card});

  final CardItem card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DifficultyBadge(difficulty: card.difficulty),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  card.promptEn,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.isOptional = false,
  });

  final String title;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (isOptional) ...[
            const SizedBox(width: 4),
            Text(
              '(${l10n.optional})',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Difficulty selector
class _DifficultySelector extends StatelessWidget {
  const _DifficultySelector({
    required this.value,
    required this.onChanged,
  });

  final Difficulty? value;
  final ValueChanged<Difficulty?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SegmentedButton<Difficulty>(
      segments: [
        ButtonSegment(
          value: Difficulty.easy,
          label: Text(l10n.easy),
        ),
        ButtonSegment(
          value: Difficulty.medium,
          label: Text(l10n.medium),
        ),
        ButtonSegment(
          value: Difficulty.hard,
          label: Text(l10n.hard),
        ),
      ],
      selected: value != null ? {value!} : {},
      onSelectionChanged: (selection) {
        onChanged(selection.isNotEmpty ? selection.first : null);
      },
      emptySelectionAllowed: true,
    );
  }
}

/// Small badge showing difficulty
class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final color = switch (difficulty) {
      Difficulty.easy => AppColors.success,
      Difficulty.medium => AppColors.warning,
      Difficulty.hard => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        difficulty.displayName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
