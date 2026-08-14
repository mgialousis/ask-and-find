import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';
import 'package:pes_vres/presentation/widgets/common/secondary_button.dart';

/// Screen shown after a successful submission
class SubmissionSuccessScreen extends StatefulWidget {
  const SubmissionSuccessScreen({
    super.key,
    required this.returnToGame,
  });

  final bool returnToGame;

  @override
  State<SubmissionSuccessScreen> createState() =>
      _SubmissionSuccessScreenState();
}

class _SubmissionSuccessScreenState extends State<SubmissionSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success icon with animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 80,
                        color: AppColors.success,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Success text with fade animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    Text(
                      l10n.submissionSuccess,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: context.palette.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.submissionSuccessMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: context.palette.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    PrimaryButton(
                      onPressed: () => context.go(
                        AppRoutes.cardSubmission,
                        extra: CardSubmissionLookback(
                          returnToGame: widget.returnToGame,
                        ),
                      ),
                      isFullWidth: true,
                      child: Text(l10n.submitAnother),
                    ),
                    const SizedBox(height: 12),
                    if (widget.returnToGame)
                      SecondaryButton(
                        onPressed: () {
                          final router = GoRouter.of(context);
                          if (router.canPop()) {
                            router.pop();
                          }
                          if (router.canPop()) {
                            router.pop();
                          }
                        },
                        isFullWidth: true,
                        child: Text(l10n.backToGame),
                      )
                    else
                      SecondaryButton(
                        onPressed: () => context.go(AppRoutes.settings),
                        isFullWidth: true,
                        child: Text(l10n.backToSettings),
                      ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.home),
                      child: Text(l10n.home),
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
