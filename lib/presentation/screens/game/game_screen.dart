import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pes_vres/core/routing/app_router.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/data/models/mock_cards.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:pes_vres/presentation/screens/game/widgets/answer_grid.dart';
import 'package:pes_vres/presentation/screens/game/widgets/game_header.dart';
import 'package:pes_vres/presentation/screens/game/widgets/prompt_card.dart';
import 'package:pes_vres/presentation/screens/game/widgets/round_result_dialog.dart';
import 'package:pes_vres/presentation/screens/game/widgets/timer_display.dart';
import 'package:pes_vres/presentation/widgets/common/primary_button.dart';

/// Game screen - Core gameplay
///
/// Three game states:
/// 1. Pre-Round (ready) - "Pass device to [Team Name]" screen
/// 2. Active Round (playing) - Timer, prompt, answer discovery
/// 3. Round End (results) - Results dialog
///
/// For Phase 1, uses local state and mock data.
/// Phase 2 will integrate Riverpod for state management.
enum GamePhase {
  ready,
  playing,
  roundEnd,
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();

  // TODO: In Phase 2, get these from Riverpod providers
  // For now, using mock data for UI development
  late List<Team> _teams;
  late int _numberOfRounds;
  late int _roundDuration;

  // Game state
  int _currentRound = 1;
  int _currentTeamIndex = 0;
  GamePhase _gamePhase = GamePhase.ready;

  // Round state
  CardItem? _currentCard;
  List<String> _selectedAnswers = [];
  Set<String> _foundAnswers = {};
  int _secondsRemaining = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeMockGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Initialize game with mock data
  /// TODO: In Phase 2, replace with data from Riverpod providers
  void _initializeMockGame() {
    _teams = [
      Team(
        id: '1',
        name: 'Team Alpha',
        color: AppColors.teamColors[0],
        score: 0,
      ),
      Team(
        id: '2',
        name: 'Team Beta',
        color: AppColors.teamColors[1],
        score: 0,
      ),
    ];
    _numberOfRounds = 5;
    _roundDuration = 60;
  }

  Team get _currentTeam => _teams[_currentTeamIndex];

  /// Start a new round
  void _startRound() {
    // Select random card
    final card = mockCards[_random.nextInt(mockCards.length)];

    // Select 10 random answers from card
    final shuffledAnswers = List<String>.from(card.answersEn)..shuffle(_random);
    final selectedAnswers = shuffledAnswers.take(10).toList()..shuffle(_random);

    setState(() {
      _currentCard = card;
      _selectedAnswers = selectedAnswers;
      _foundAnswers = {};
      _secondsRemaining = _roundDuration;
      _gamePhase = GamePhase.playing;
    });

    _startTimer();
  }

  /// Start countdown timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });

      if (_secondsRemaining <= 0) {
        _endRound();
      }
    });
  }

  /// Handle answer tap
  void _onAnswerTap(String answer) {
    if (_gamePhase != GamePhase.playing) return;
    if (_foundAnswers.contains(answer)) return;

    setState(() {
      _foundAnswers.add(answer);
    });

    // Check if all answers found
    if (_foundAnswers.length == _selectedAnswers.length) {
      _endRound();
    }
  }

  /// End the current round
  void _endRound() {
    _timer?.cancel();

    // Update team score
    final pointsEarned = _foundAnswers.length;
    setState(() {
      _teams[_currentTeamIndex] = _teams[_currentTeamIndex].copyWith(
        score: _teams[_currentTeamIndex].score + pointsEarned,
      );
      _gamePhase = GamePhase.roundEnd;
    });

    // Show results dialog
    _showResultsDialog();
  }

  /// Show round results dialog
  void _showResultsDialog() {
    final foundList = _foundAnswers.toList()..sort();
    final missedList = _selectedAnswers
        .where((answer) => !_foundAnswers.contains(answer))
        .toList()
      ..sort();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RoundResultDialog(
        team: _currentTeam,
        pointsEarned: _foundAnswers.length,
        foundAnswers: foundList,
        missedAnswers: missedList,
        prompt: _currentCard!.promptEn,
        source: _currentCard!.source,
        onContinue: () {
          Navigator.of(context).pop();
          _continueToNextRound();
        },
      ),
    );
  }

  /// Continue to next round or end game
  void _continueToNextRound() {
    // Move to next team
    _currentTeamIndex = (_currentTeamIndex + 1) % _teams.length;

    // Check if all rounds completed
    if (_currentTeamIndex == 0) {
      _currentRound++;
      if (_currentRound > _numberOfRounds) {
        _endGame();
        return;
      }
    }

    // Start next round
    setState(() {
      _gamePhase = GamePhase.ready;
    });
  }

  /// End the game and navigate to results
  void _endGame() {
    // TODO: In Phase 2, save results to Riverpod provider
    // For now, pass teams data via route extras
    context.pushReplacementNamed(
      AppRoutes.results,
      extra: _teams,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: _buildGamePhaseContent(),
        ),
      ),
    );
  }

  Widget _buildGamePhaseContent() {
    switch (_gamePhase) {
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
              color: _currentTeam.color,
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
                color: _currentTeam.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _currentTeam.color,
                  width: 3,
                ),
              ),
              child: Text(
                _currentTeam.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: _currentTeam.color,
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
                    'Round $_currentRound of $_numberOfRounds',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find 10 answers in $_roundDuration seconds',
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
    if (_currentCard == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Header
        GameHeader(
          currentRound: _currentRound,
          totalRounds: _numberOfRounds,
          currentTeam: _currentTeam,
          foundCount: _foundAnswers.length,
          totalAnswers: _selectedAnswers.length,
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
                    secondsRemaining: _secondsRemaining,
                  ),
                ),
                const SizedBox(height: 24),

                // Prompt
                PromptCard(
                  prompt: _currentCard!.promptEn,
                  difficulty: _currentCard!.difficulty,
                ),
                const SizedBox(height: 32),

                // Answer Grid
                AnswerGrid(
                  answers: _selectedAnswers,
                  foundAnswers: _foundAnswers,
                  onAnswerTap: _onAnswerTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
