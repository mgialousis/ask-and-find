import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/l10n/app_localizations.dart';
import 'package:pes_vres/presentation/screens/game/widgets/answer_grid.dart';
import 'package:pes_vres/presentation/screens/game/widgets/game_header.dart';
import 'package:pes_vres/presentation/screens/game/widgets/prompt_card.dart';
import 'package:pes_vres/presentation/screens/game/widgets/round_result_dialog.dart';
import 'package:pes_vres/presentation/screens/game/widgets/timer_display.dart';
import 'package:pes_vres/presentation/state/game_setup_provider.dart';
import 'package:pes_vres/presentation/state/game_state_provider.dart';
import 'package:pes_vres/presentation/state/locale_provider.dart';
import 'package:pes_vres/presentation/state/settings_provider.dart';
import 'package:pes_vres/presentation/state/timer_provider.dart';
import 'package:pes_vres/presentation/widgets/game/team_indicator.dart';
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

enum _RoundResultAction {
  continueGame,
  endGame,
}

class _GameScreenState extends ConsumerState<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Listen for timer expiration
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(timerProvider, (previous, current) {
        if (previous == null) return;

        if (current.isRunning &&
            previous.isRunning &&
            current.secondsRemaining != previous.secondsRemaining &&
            current.secondsRemaining > 0 &&
            current.secondsRemaining <= 10) {
          _playCountdownTick(current.secondsRemaining);
        }

        if (previous.secondsRemaining > 0 && current.secondsRemaining == 0) {
          // Timer just expired, end round
          _playTimerEndSound();
          _endRound();
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playCountdownTick(int secondsRemaining) {
    final settings = ref.read(settingsProvider);
    if (!settings.soundEffectsEnabled) return;
    final intensity = (11 - secondsRemaining) / 10.0;
    final volume = (0.2 + intensity * 0.8).clamp(0.2, 1.0);
    _audioPlayer.play(
      AssetSource('sounds/countdown_tick.wav'),
      volume: volume,
    );
  }

  void _playTimerEndSound() {
    final settings = ref.read(settingsProvider);
    if (!settings.soundEffectsEnabled) return;
    _audioPlayer.play(
      AssetSource('sounds/timer_end.wav'),
      volume: 1.0,
    );
  }

  /// Play selection sound (short tick)
  void _playSelectionSound() {
    final settings = ref.read(settingsProvider);
    if (!settings.soundEffectsEnabled) return;
    _audioPlayer.play(
      AssetSource('sounds/countdown_tick.wav'),
      volume: 0.5,
    );
  }

  /// Trigger haptic feedback
  void _triggerHaptic({bool heavy = false}) {
    final settings = ref.read(settingsProvider);
    if (!settings.hapticFeedbackEnabled) return;
    if (heavy) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  /// Start a new round
  Future<void> _startRound() async {
    // Start round in game state provider (selects card and answers)
    await ref.read(gameStateProvider.notifier).startRound();
  }

  /// Begin the active turn (start timer and reveal answers)
  void _beginTurn() {
    final setupState = ref.read(gameSetupProvider);
    ref.read(gameStateProvider.notifier).beginTurn();
    ref.read(timerProvider.notifier).start(
          setupState.config.roundDurationSeconds,
        );
  }

  /// Handle answer tap (toggle selection)
  void _onAnswerTap(String answer) {
    // Play sound and haptic feedback
    _playSelectionSound();
    _triggerHaptic();

    // Toggle answer selection (select/deselect)
    ref.read(gameStateProvider.notifier).toggleAnswer(answer);
  }

  /// End the current round
  Future<void> _endRound() async {
    final gameState = ref.read(gameStateProvider);
    if (gameState.gamePhase != GamePhase.playing) {
      return;
    }

    // Stop timer
    ref.read(timerProvider.notifier).pause();

    // End round in game state (updates scores, creates result)
    ref.read(gameStateProvider.notifier).endRound();

    // Show results dialog
    await _showResultsDialog();
  }

  /// Show round results dialog
  Future<void> _showResultsDialog() async {
    final gameState = ref.read(gameStateProvider);
    final result = gameState.lastRoundResult!;
    final setupState = ref.read(gameSetupProvider);
    final currentTeam = setupState.teams[result.teamIndex];
    final currentCard = gameState.currentCard!;
    final locale = ref.read(localeProvider);

    final action = await showDialog<_RoundResultAction>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RoundResultDialog(
        team: currentTeam,
        teams: setupState.teams,
        foundAnswers: result.foundAnswers,
        missedAnswers: result.missedAnswers,
        prompt: currentCard.getPrompt(locale),
        card: currentCard,
        source: currentCard.source,
        pointsForAnswer: currentCard.pointsForAnswer,
        onScoreAdjust: (delta) {
          ref.read(gameSetupProvider.notifier).updateTeamScore(
                result.teamIndex,
                delta,
              );
        },
        onContinue: () =>
            Navigator.of(context).pop(_RoundResultAction.continueGame),
        onEndGame: () => Navigator.of(context).pop(_RoundResultAction.endGame),
      ),
    );

    if (!mounted) return;

    if (action == null) return;

    if (action == _RoundResultAction.endGame) {
      _endGame();
    } else {
      _continueToNextRound();
    }
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
      case GamePhase.preview:
        return _buildPreviewPhase();
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
    final l10n = AppLocalizations.of(context);
    if (setupState.teams.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final currentTeam = setupState.teams[gameState.currentTeamIndex];
    final nextTeam =
        setupState.teams[(gameState.currentTeamIndex + 1) % setupState.teams.length];
    final totalRounds = setupState.config.numberOfRounds;
    final roundDuration = setupState.config.roundDurationSeconds;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
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
              l10n.passDeviceMessage(currentTeam.name, nextTeam.name),
              textAlign: TextAlign.center,
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
                    l10n.roundOf(gameState.currentRound, totalRounds),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.findAnswersInTime(roundDuration),
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
              child: Text(l10n.showQuestion),
            ),
          ],
        ),
      ),
    );
  }

  /// Build pre-turn question preview screen
  Widget _buildPreviewPhase() {
    final gameState = ref.watch(gameStateProvider);
    final setupState = ref.watch(gameSetupProvider);
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    if (setupState.teams.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final currentTeam = setupState.teams[gameState.currentTeamIndex];

    if (gameState.currentCard == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TeamIndicator(
              team: currentTeam,
              size: TeamIndicatorSize.large,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.tapToStartTimer,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                ref.read(gameStateProvider.notifier).refreshCard();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refreshQuestion),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _beginTurn,
              child: PromptCard(
                prompt: gameState.currentCard!.getPrompt(locale),
                difficulty: gameState.currentCard!.difficulty,
              ),
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
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    if (setupState.teams.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
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
                  prompt: gameState.currentCard!.getPrompt(locale),
                  difficulty: gameState.currentCard!.difficulty,
                ),
                const SizedBox(height: 32),

                // Answer Grid
                AnswerGrid(
                  answers: gameState.selectedAnswers,
                  foundAnswers: gameState.foundAnswers.toSet(),
                  onAnswerTap: _onAnswerTap,
                  pointsForAnswer:
                      (answer) => gameState.currentCard!.pointsForAnswer(answer),
                ),
                const SizedBox(height: 24),

                // End Turn Button
                SecondaryButton(
                  onPressed: _endRound,
                  isFullWidth: true,
                  child: Text(l10n.endTurn),
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
