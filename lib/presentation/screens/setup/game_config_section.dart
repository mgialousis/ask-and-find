import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

/// Game configuration section for setup screen
///
/// Allows users to configure:
/// - Number of rounds (5/7/10)
/// - Round duration (30/45/60/90 seconds)
/// - Difficulty level (Easy/Medium/Hard)
class GameConfigSection extends StatelessWidget {
  const GameConfigSection({
    super.key,
    required this.numberOfRounds,
    required this.roundDuration,
    required this.difficulties,
    required this.onRoundsChanged,
    required this.onDurationChanged,
    required this.onDifficultiesChanged,
  });

  final int numberOfRounds;
  final int roundDuration;
  final Set<Difficulty> difficulties;
  final ValueChanged<int> onRoundsChanged;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<Set<Difficulty>> onDifficultiesChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    void toggleDifficulty(Difficulty difficulty) {
      final updated = Set<Difficulty>.from(difficulties);

      if (updated.contains(difficulty)) {
        updated.remove(difficulty);
        if (updated.isEmpty) {
          updated.add(difficulty);
        }
      } else {
        updated.add(difficulty);
      }

      onDifficultiesChanged(updated);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: l10n.gameSettings),
        const SizedBox(height: 16),

        // Number of Rounds
        _SettingGroup(
          label: l10n.numberOfRounds,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ChoiceButton(
                label: '5',
                isSelected: numberOfRounds == 5,
                onTap: () => onRoundsChanged(5),
              ),
              _ChoiceButton(
                label: '7',
                isSelected: numberOfRounds == 7,
                onTap: () => onRoundsChanged(7),
              ),
              _ChoiceButton(
                label: '10',
                isSelected: numberOfRounds == 10,
                onTap: () => onRoundsChanged(10),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Round Duration
        _SettingGroup(
          label: l10n.roundDuration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ChoiceButton(
                label: l10n.seconds30,
                isSelected: roundDuration == 30,
                onTap: () => onDurationChanged(30),
              ),
              _ChoiceButton(
                label: l10n.seconds45,
                isSelected: roundDuration == 45,
                onTap: () => onDurationChanged(45),
              ),
              _ChoiceButton(
                label: l10n.seconds60,
                isSelected: roundDuration == 60,
                onTap: () => onDurationChanged(60),
              ),
              _ChoiceButton(
                label: l10n.seconds90,
                isSelected: roundDuration == 90,
                onTap: () => onDurationChanged(90),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Difficulty
        _SettingGroup(
          label: l10n.difficulty,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ChoiceButton(
                      label: l10n.easy,
                      isSelected: difficulties.contains(Difficulty.easy),
                      onTap: () => toggleDifficulty(Difficulty.easy),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ChoiceButton(
                      label: l10n.medium,
                      isSelected: difficulties.contains(Difficulty.medium),
                      onTap: () => toggleDifficulty(Difficulty.medium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ChoiceButton(
                      label: l10n.hard,
                      isSelected: difficulties.contains(Difficulty.hard),
                      onTap: () => toggleDifficulty(Difficulty.hard),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SettingGroup extends StatelessWidget {
  const _SettingGroup({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 2 : 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.surfaceVariant,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
