import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/l10n/app_localizations.dart';

/// How to Play screen - Game instructions and rules
///
/// Explains the game mechanics, scoring, and gameplay flow.
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.howToPlayTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _InstructionStep(
            stepNumber: 1,
            icon: Icons.groups,
            title: l10n.step1Title,
            description: l10n.step1Desc,
          ),
          _InstructionStep(
            stepNumber: 2,
            icon: Icons.psychology,
            title: l10n.step2Title,
            description: l10n.step2Desc,
          ),
          _InstructionStep(
            stepNumber: 3,
            icon: Icons.timer,
            title: l10n.step3Title,
            description: l10n.step3Desc,
          ),
          _InstructionStep(
            stepNumber: 4,
            icon: Icons.star,
            title: l10n.step4Title,
            description: l10n.step4Desc,
          ),
          _InstructionStep(
            stepNumber: 5,
            icon: Icons.loop,
            title: l10n.step5Title,
            description: l10n.step5Desc,
          ),
          _InstructionStep(
            stepNumber: 6,
            icon: Icons.emoji_events,
            title: l10n.step6Title,
            description: l10n.step6Desc,
          ),
          const SizedBox(height: 24),
          _TipCard(
            title: l10n.proTips,
            tips: [
              l10n.tip1,
              l10n.tip2,
              l10n.tip3,
              l10n.tip4,
            ],
          ),
        ],
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  const _InstructionStep({
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
  });

  final int stepNumber;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: context.palette.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.title,
    required this.tips,
  });

  final String title;
  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryLight.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppColors.warning,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tip,
                          style: TextStyle(
                            fontSize: 15,
                            color: context.palette.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
