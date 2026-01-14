import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// Game configuration section for setup screen
///
/// Allows users to configure:
/// - Number of rounds (5/7/10)
/// - Round duration (30/45/60/90 seconds)
/// - Difficulty level (Easy/Medium/Hard/Mixed)
class GameConfigSection extends StatelessWidget {
  const GameConfigSection({
    super.key,
    required this.numberOfRounds,
    required this.roundDuration,
    required this.difficulty,
    required this.onRoundsChanged,
    required this.onDurationChanged,
    required this.onDifficultyChanged,
  });

  final int numberOfRounds;
  final int roundDuration;
  final Difficulty difficulty;
  final ValueChanged<int> onRoundsChanged;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<Difficulty> onDifficultyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'Game Settings'),
        const SizedBox(height: 16),

        // Number of Rounds
        _SettingGroup(
          label: 'Number of Rounds',
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
          label: 'Round Duration',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ChoiceButton(
                label: '30s',
                isSelected: roundDuration == 30,
                onTap: () => onDurationChanged(30),
              ),
              _ChoiceButton(
                label: '45s',
                isSelected: roundDuration == 45,
                onTap: () => onDurationChanged(45),
              ),
              _ChoiceButton(
                label: '60s',
                isSelected: roundDuration == 60,
                onTap: () => onDurationChanged(60),
              ),
              _ChoiceButton(
                label: '90s',
                isSelected: roundDuration == 90,
                onTap: () => onDurationChanged(90),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Difficulty
        _SettingGroup(
          label: 'Difficulty',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ChoiceButton(
                      label: 'Easy',
                      isSelected: difficulty == Difficulty.easy,
                      onTap: () => onDifficultyChanged(Difficulty.easy),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ChoiceButton(
                      label: 'Medium',
                      isSelected: difficulty == Difficulty.medium,
                      onTap: () => onDifficultyChanged(Difficulty.medium),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ChoiceButton(
                      label: 'Hard',
                      isSelected: difficulty == Difficulty.hard,
                      onTap: () => onDifficultyChanged(Difficulty.hard),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ChoiceButton(
                      label: 'Mixed',
                      isSelected: difficulty == Difficulty.mixed,
                      onTap: () => onDifficultyChanged(Difficulty.mixed),
                    ),
                  ),
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
