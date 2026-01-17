import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/presentation/screens/game/widgets/answer_grid.dart';
import 'package:pes_vres/presentation/screens/game/widgets/game_header.dart';
import 'package:pes_vres/presentation/screens/game/widgets/prompt_card.dart';
import 'package:pes_vres/presentation/screens/game/widgets/round_result_dialog.dart';
import 'package:pes_vres/presentation/screens/game/widgets/timer_display.dart';
import 'package:pes_vres/presentation/state/game_setup_provider.dart';
import 'package:pes_vres/presentation/state/game_state_provider.dart';
import 'package:pes_vres/presentation/state/timer_provider.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';
import 'package:pes_vres/presentation/widgets/common/secondary_button.dart';

/// Game screen - Core gameplay
///
/// Three game phases:
/// 1. Pre-Round (ready) - "Pass device to [Team Name]" screen
/// 2. Active Round (playing) - Timer, prompt, answer discovery
/// 3. Round End (results) - Results dialog
///
/// Phase 2: Now uses Riverpod providers for state management.
/// Connects setup configuration to actual gameplay.
class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();

    // Listen for timer expiration
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(timerProvider, (previous, current) {
        if (current.isExpired && previous?.isRunning == true) {
          // Timer just expired, end round
          _endRound();
        }
      });
    });
  }

  /// Start a new round
  void _startRound() {
    final setupState = ref.read(gameSetupProvider);

    // Start round in game state provider (selects card and answers)
    ref.read(gameStateProvider.notifier).startRound();

    // Start timer with configured duration
    ref.read(timerProvider.notifier).start(
          setupState.config.roundDurationSeconds,
        );
  }

  /// Handle answer tap (toggle selection)
  void _onAnswerTap(String answer) {
    // Toggle answer selection (select/deselect)
    ref.read(gameStateProvider.notifier).toggleAnswer(answer);
  }

  /// End the current round
  void _endRound() {
    // Stop timer
    ref.read(timerProvider.notifier).pause();

    // End round in game state (updates scores, creates result)
    ref.read(gameStateProvider.notifier).endRound();

    // Show results dialog
    _showResultsDialog();
  }

  /// Show round results dialog
  void _showResultsDialog() {
    final gameState = ref.read(gameStateProvider);
    final result = gameState.lastRoundResult!;
    final setupState = ref.read(gameSetupProvider);
    final currentTeam = setupState.teams[result.teamIndex];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RoundResultDialog(
        team: currentTeam,
        pointsEarned: result.pointsEarned,
        foundAnswers: result.foundAnswers,
        missedAnswers: result.missedAnswers,
        prompt: gameState.currentCard!.promptEn,
        source: gameState.currentCard!.source,
        onContinue: () {
          Navigator.of(context).pop();
          _continueToNextRound();
        },
        onEndGame: () {
          Navigator.of(context).pop();
          _endGame();
        },
      ),
    );
  }

  /// Continue to next round or end game
  void _continueToNextRound() {
    final continues = ref.read(gameStateProvider.notifier).continueToNextRound();

    if (!continues) {
      // Game ended, navigate to results
      _endGame();
    }
  }

  /// End the game and navigate to results
  void _endGame() {
    // Navigate to results screen (will read teams from provider)
    context.pushReplacementNamed('results');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: _buildGamePhaseContent(gameState.gamePhase),
        ),
      ),
    );
  }

  Widget _buildGamePhaseContent(GamePhase phase) {
    switch (phase) {
      case GamePhase.ready:
        return _buildReadyPhase();
      case GamePhase.playing:
        return _buildPlayingPhase();
      case GamePhase.roundEnd:
        // Results dialog is shown, display playing phase underneath
        return _buildPlayingPhase();
    }
  }

  /// Build pre-round "ready" screen
  Widget _buildReadyPhase() {
    final gameState = ref.watch(gameStateProvider);
    final setupState = ref.watch(gameSetupProvider);
    final currentTeam = setupState.teams[gameState.currentTeamIndex];
    final totalRounds = setupState.config.numberOfRounds;
    final roundDuration = setupState.config.roundDurationSeconds;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pass Device Message
            Icon(
              Icons.sync_alt,
              size: 80,
              color: currentTeam.color,
            ),
            const SizedBox(height: 24),
            Text(
              'Pass device to',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: currentTeam.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: currentTeam.color,
                  width: 3,
                ),
              ),
              child: Text(
                currentTeam.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: currentTeam.color,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Round Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Round ${gameState.currentRound} of $totalRounds',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find 10 answers in $roundDuration seconds',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Start Round Button
            PrimaryButton(
              onPressed: _startRound,
              isFullWidth: true,
              child: const Text('Ready? Start Round'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build active round "playing" screen
  Widget _buildPlayingPhase() {
    final gameState = ref.watch(gameStateProvider);
    final setupState = ref.watch(gameSetupProvider);
    final timerState = ref.watch(timerProvider);

    if (gameState.currentCard == null) return const SizedBox.shrink();

    final currentTeam = setupState.teams[gameState.currentTeamIndex];

    return Column(
      children: [
        // Header
        GameHeader(
          currentRound: gameState.currentRound,
          totalRounds: setupState.config.numberOfRounds,
          currentTeam: currentTeam,
          foundCount: gameState.foundAnswers.length,
          totalAnswers: gameState.selectedAnswers.length,
        ),

        // Main Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Timer
                Center(
                  child: TimerDisplay(
                    secondsRemaining: timerState.secondsRemaining,
                  ),
                ),
                const SizedBox(height: 24),

                // Prompt
                PromptCard(
                  prompt: gameState.currentCard!.promptEn,
                  difficulty: gameState.currentCard!.difficulty,
                ),
                const SizedBox(height: 32),

                // Answer Grid
                AnswerGrid(
                  answers: gameState.selectedAnswers,
                  foundAnswers: gameState.foundAnswers.toSet(),
                  onAnswerTap: _onAnswerTap,
                  pointValue: gameState.currentCard!.difficulty.pointsPerAnswer,
                ),
                const SizedBox(height: 24),

                // End Round Button
                SecondaryButton(
                  onPressed: _endRound,
                  isFullWidth: true,
                  child: const Text('End Round'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
