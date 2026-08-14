import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

/// Widget for selecting an issue type when reporting a card correction
class IssueTypeSelector extends StatelessWidget {
  const IssueTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Currently selected issue type
  final IssueType? value;

  /// Callback when issue type changes
  final ValueChanged<IssueType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: IssueType.values.map((type) {
        final isSelected = value == type;
        return _IssueTypeOption(
          type: type,
          label: _getLabel(l10n, type),
          description: _getDescription(l10n, type),
          isSelected: isSelected,
          onTap: () => onChanged(isSelected ? null : type),
        );
      }).toList(),
    );
  }

  String _getLabel(AppLocalizations l10n, IssueType type) {
    switch (type) {
      case IssueType.wrongAnswer:
        return l10n.issueTypeWrongAnswer;
      case IssueType.outdatedInfo:
        return l10n.issueTypeOutdated;
      case IssueType.spellingGrammar:
        return l10n.issueTypeSpelling;
      case IssueType.unclearQuestion:
        return l10n.issueTypeUnclear;
      case IssueType.other:
        return l10n.issueTypeOther;
    }
  }

  String _getDescription(AppLocalizations l10n, IssueType type) {
    switch (type) {
      case IssueType.wrongAnswer:
        return l10n.issueTypeWrongAnswerDesc;
      case IssueType.outdatedInfo:
        return l10n.issueTypeOutdatedDesc;
      case IssueType.spellingGrammar:
        return l10n.issueTypeSpellingDesc;
      case IssueType.unclearQuestion:
        return l10n.issueTypeUnclearDesc;
      case IssueType.other:
        return l10n.issueTypeOtherDesc;
    }
  }
}

/// Single issue type option
class _IssueTypeOption extends StatelessWidget {
  const _IssueTypeOption({
    required this.type,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  final IssueType type;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (type) {
      case IssueType.wrongAnswer:
        return Icons.error_outline;
      case IssueType.outdatedInfo:
        return Icons.update;
      case IssueType.spellingGrammar:
        return Icons.spellcheck;
      case IssueType.unclearQuestion:
        return Icons.help_outline;
      case IssueType.other:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : context.palette.surfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : context.palette.surfaceVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Radio indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : context.palette.textSecondary,
                    width: 2,
                  ),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Icon
              Icon(
                _icon,
                size: 24,
                color: isSelected ? AppColors.primary : context.palette.textSecondary,
              ),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isSelected
                            ? AppColors.primary
                            : context.palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
