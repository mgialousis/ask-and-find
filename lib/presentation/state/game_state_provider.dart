import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/data/models/mock_cards.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/presentation/state/game_setup_provider.dart';

/// Game phases during gameplay
enum GamePhase {
  /// Pre-round: "Pass device to team" screen
  ready,

  /// Active round: Timer running, answers being discovered
  playing,

  /// Round ended: Showing results dialog
  roundEnd,
}

/// Round result data
class RoundResult extends Equatable {
  const RoundResult({
    required this.roundNumber,
    required this.teamIndex,
    required this.teamName,
    required this.selectedAnswers,
    required this.foundAnswers,
    required this.pointsEarned,
  });

  final int roundNumber;
  final int teamIndex;
  final String teamName;
  final List<String> selectedAnswers;
  final List<String> foundAnswers;
  final int pointsEarned;

  /// Get missed answers
  List<String> get missedAnswers => selectedAnswers
      .where((answer) => !foundAnswers.contains(answer))
      .toList()
    ..sort();

  @override
  List<Object?> get props => [
        roundNumber,
        teamIndex,
        teamName,
        selectedAnswers,
        foundAnswers,
        pointsEarned,
      ];
}

/// Active game state
///
/// Manages the current game session including rounds, teams, cards, and scoring.
class GameState extends Equatable {
  const GameState({
    required this.currentRound,
    required this.currentTeamIndex,
    required this.gamePhase,
    this.currentCard,
    this.selectedAnswers = const [],
    this.foundAnswers = const [],
    this.lastRoundResult,
  });

  final int currentRound;
  final int currentTeamIndex;
  final GamePhase gamePhase;
  final CardItem? currentCard;
  final List<String> selectedAnswers;
  final List<String> foundAnswers;
  final RoundResult? lastRoundResult;

  /// Initial game state (not started)
  factory GameState.initial() => const GameState(
        currentRound: 1,
        currentTeamIndex: 0,
        gamePhase: GamePhase.ready,
      );

  /// Create a copy with optional field updates
  GameState copyWith({
    int? currentRound,
    int? currentTeamIndex,
    GamePhase? gamePhase,
    CardItem? currentCard,
    List<String>? selectedAnswers,
    List<String>? foundAnswers,
    RoundResult? lastRoundResult,
  }) {
    return GameState(
      currentRound: currentRound ?? this.currentRound,
      currentTeamIndex: currentTeamIndex ?? this.currentTeamIndex,
      gamePhase: gamePhase ?? this.gamePhase,
      currentCard: currentCard ?? this.currentCard,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      foundAnswers: foundAnswers ?? this.foundAnswers,
      lastRoundResult: lastRoundResult ?? this.lastRoundResult,
    );
  }

  @override
  List<Object?> get props => [
        currentRound,
        currentTeamIndex,
        gamePhase,
        currentCard,
        selectedAnswers,
        foundAnswers,
        lastRoundResult,
      ];
}

/// Game state notifier - manages active gameplay
///
/// Orchestrates game flow:
/// - Round progression
/// - Card selection
/// - Answer discovery
/// - Score tracking
/// - Team rotation
class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier(this._ref) : super(GameState.initial());

  final Ref _ref;
  final Random _random = Random();

  /// Start a new round (transition from ready to playing)
  void startRound() {
    // Select random card
    final card = mockCards[_random.nextInt(mockCards.length)];

    // Select 10 random answers from card
    final shuffledAnswers = List<String>.from(card.answersEn)..shuffle(_random);
    final selectedAnswers = shuffledAnswers.take(10).toList()..shuffle(_random);

    state = state.copyWith(
      currentCard: card,
      selectedAnswers: selectedAnswers,
      foundAnswers: [],
      gamePhase: GamePhase.playing,
    );
  }

  /// Handle answer tap (reveal and mark as found)
  void revealAnswer(String answer) {
    if (state.gamePhase != GamePhase.playing) return;
    if (state.foundAnswers.contains(answer)) return;

    final updatedFoundAnswers = [...state.foundAnswers, answer];
    state = state.copyWith(foundAnswers: updatedFoundAnswers);

    // Check if all answers found
    if (updatedFoundAnswers.length == state.selectedAnswers.length) {
      endRound();
    }
  }

  /// End the current round (called when timer expires or all answers found)
  void endRound() {
    if (state.gamePhase != GamePhase.playing) return;

    final pointsEarned = state.foundAnswers.length;
    final setupState = _ref.read(gameSetupProvider);
    final currentTeam = setupState.teams[state.currentTeamIndex];

    // Update team score in setup provider
    _ref.read(gameSetupProvider.notifier).updateTeamScore(
          state.currentTeamIndex,
          pointsEarned,
        );

    // Create round result
    final result = RoundResult(
      roundNumber: state.currentRound,
      teamIndex: state.currentTeamIndex,
      teamName: currentTeam.name,
      selectedAnswers: List.from(state.selectedAnswers)..sort(),
      foundAnswers: List.from(state.foundAnswers)..sort(),
      pointsEarned: pointsEarned,
    );

    state = state.copyWith(
      gamePhase: GamePhase.roundEnd,
      lastRoundResult: result,
    );
  }

  /// Continue to next round or end game
  ///
  /// Returns true if game continues, false if game ends
  bool continueToNextRound() {
    final setupState = _ref.read(gameSetupProvider);
    final numberOfTeams = setupState.teams.length;
    final totalRounds = setupState.config.numberOfRounds;

    // Move to next team
    final nextTeamIndex = (state.currentTeamIndex + 1) % numberOfTeams;

    // Check if round is complete (all teams played)
    if (nextTeamIndex == 0) {
      // All teams played this round, move to next round
      final nextRound = state.currentRound + 1;

      if (nextRound > totalRounds) {
        // Game complete
        return false;
      }

      state = state.copyWith(
        currentRound: nextRound,
        currentTeamIndex: 0,
        gamePhase: GamePhase.ready,
        currentCard: null,
        selectedAnswers: [],
        foundAnswers: [],
      );
    } else {
      // Same round, next team
      state = state.copyWith(
        currentTeamIndex: nextTeamIndex,
        gamePhase: GamePhase.ready,
        currentCard: null,
        selectedAnswers: [],
        foundAnswers: [],
      );
    }

    return true;
  }

  /// Reset game state to initial (for new game)
  void reset() {
    state = GameState.initial();
  }
}

/// Provider for active game state
///
/// Usage:
/// ```dart
/// // Start round
/// ref.read(gameStateProvider.notifier).startRound();
///
/// // Reveal answer
/// ref.read(gameStateProvider.notifier).revealAnswer('Paris');
///
/// // Watch game state
/// final game = ref.watch(gameStateProvider);
/// if (game.gamePhase == GamePhase.playing) { /* show game */ }
///
/// // Continue to next round
/// final continues = ref.read(gameStateProvider.notifier).continueToNextRound();
/// if (!continues) {
///   // Game ended, navigate to results
/// }
/// ```
final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>(
  (ref) => GameStateNotifier(ref),
);
