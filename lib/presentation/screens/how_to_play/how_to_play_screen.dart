import 'package:flutter/material.dart';
import 'package:pes_vres/core/theme/app_colors.dart';

/// How to Play screen - Game instructions and rules
///
/// Explains the game mechanics, scoring, and gameplay flow.
class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          _InstructionStep(
            stepNumber: 1,
            icon: Icons.groups,
            title: 'Set Up Teams',
            description:
                'Create 2-4 teams and choose unique names and colors for each team. Each team will take turns guessing answers.',
          ),
          _InstructionStep(
            stepNumber: 2,
            icon: Icons.psychology,
            title: 'Read the Prompt',
            description:
                'Each round, the active team sees a prompt (like "Name European capital cities"). Their goal is to guess 10 correct answers from a hidden list.',
          ),
          _InstructionStep(
            stepNumber: 3,
            icon: Icons.timer,
            title: 'Beat the Clock',
            description:
                'Teams have a time limit (30-90 seconds) to find as many answers as possible. Tap the hidden chips to reveal answers when you guess correctly.',
          ),
          _InstructionStep(
            stepNumber: 4,
            icon: Icons.star,
            title: 'Score Points',
            description:
                'Each correct answer found earns 1 point. There are no penalties for wrong guesses, so keep trying! Only the 10 selected answers for that round count.',
          ),
          _InstructionStep(
            stepNumber: 5,
            icon: Icons.loop,
            title: 'Take Turns',
            description:
                'Teams take turns playing rounds until all configured rounds are complete. The game alternates between teams in order.',
          ),
          _InstructionStep(
            stepNumber: 6,
            icon: Icons.emoji_events,
            title: 'Win the Game',
            description:
                'After all rounds, the team with the most points wins! If there\'s a tie for first place, overtime rounds determine the winner.',
          ),
          SizedBox(height: 24),
          _TipCard(
            title: 'Pro Tips',
            tips: [
              'Communication is key! Discuss answers with your team.',
              'Think of multiple variations of an answer (e.g., "USA" vs "United States").',
              'Watch the timer! The last 10 seconds are critical.',
              'Learn from revealed answers at the end of each round.',
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
                    color: AppColors.textSecondary,
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
                            color: AppColors.textSecondary,
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
