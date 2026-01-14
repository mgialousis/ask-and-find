import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';
import 'package:pes_vres/presentation/widgets/common/secondary_button.dart';

/// Home screen - Main entry point of the app
///
/// Shows app branding and navigation to key features:
/// - New Game (starts setup flow)
/// - How to Play (game instructions)
/// - Settings (app preferences)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // App Title
                const Text(
                  'Say & Find',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Tagline
                Text(
                  'The Ultimate Party Trivia Game',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),

                // New Game Button
                PrimaryButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.setup);
                  },
                  isFullWidth: true,
                  child: const Text('New Game'),
                ),
                const SizedBox(height: 16),

                // How to Play Button
                SecondaryButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.howToPlay);
                  },
                  isFullWidth: true,
                  child: const Text('How to Play'),
                ),
                const SizedBox(height: 16),

                // Settings Button
                SecondaryButton(
                  onPressed: () {
                    context.pushNamed(AppRoutes.settings);
                  },
                  isFullWidth: true,
                  child: const Text('Settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
