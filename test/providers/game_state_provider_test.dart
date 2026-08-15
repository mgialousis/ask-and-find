import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/card_language_mode.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/domain/entities/game_config.dart';
import 'package:pes_vres/presentation/state/cards_provider.dart';
import 'package:pes_vres/presentation/state/game_setup_provider.dart';
import 'package:pes_vres/presentation/state/game_state_provider.dart';

// Mock cards for testing
final _mockCards = [
  CardItem(
    id: 'test-card-1',
    promptEn: 'Test Question 1',
    promptEs: 'Pregunta de Prueba 1',
    answersEn: [
      'Answer 1',
      'Answer 2',
      'Answer 3',
      'Answer 4',
      'Answer 5',
      'Answer 6',
      'Answer 7',
      'Answer 8',
      'Answer 9',
      'Answer 10',
    ],
    answersEs: [
      'Respuesta 1',
      'Respuesta 2',
      'Respuesta 3',
      'Respuesta 4',
      'Respuesta 5',
      'Respuesta 6',
      'Respuesta 7',
      'Respuesta 8',
      'Respuesta 9',
      'Respuesta 10',
    ],
    difficulty: Difficulty.easy,
    source: 'Test',
  ),
  CardItem(
    id: 'test-card-2',
    promptEn: 'Test Question 2',
    promptEs: 'Pregunta de Prueba 2',
    answersEn: ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'A9', 'A10'],
    answersEs: ['E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9', 'E10'],
    difficulty: Difficulty.easy,
    source: 'Test',
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('GameState', () {
    test('initial state has correct defaults', () {
      final state = GameState.initial();

      expect(state.currentRound, 1);
      expect(state.currentTeamIndex, 0);
      expect(state.gamePhase, GamePhase.ready);
      expect(state.currentCard, isNull);
      expect(state.selectedAnswers, isEmpty);
      expect(state.foundAnswers, isEmpty);
      expect(state.usedCardIdsInRound, isEmpty);
      expect(state.usedCardIdsInGame, isEmpty);
      expect(state.lastRoundResult, isNull);
    });

    test('copyWith creates new instance with updated values', () {
      final original = GameState.initial();
      final copied = original.copyWith(
        currentRound: 3,
        currentTeamIndex: 1,
        gamePhase: GamePhase.playing,
      );

      expect(copied.currentRound, 3);
      expect(copied.currentTeamIndex, 1);
      expect(copied.gamePhase, GamePhase.playing);
      // Original should be unchanged
      expect(original.currentRound, 1);
      expect(original.currentTeamIndex, 0);
      expect(original.gamePhase, GamePhase.ready);
    });

    test('equality works correctly', () {
      final state1 = GameState.initial();
      final state2 = GameState.initial();
      final state3 = GameState.initial().copyWith(currentRound: 2);

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('Card language display', () {
    final card = _mockCards.first;

    test('returns English content in English mode', () {
      expect(
        card.getPrimaryPrompt(CardLanguageMode.english),
        'Test Question 1',
      );
      expect(
        card.getPrimaryAnswer('Answer 1', CardLanguageMode.english),
        'Answer 1',
      );
      expect(
        card.getSecondaryAnswer('Answer 1', CardLanguageMode.english),
        isNull,
      );
    });

    test('returns Spanish content in Spanish mode', () {
      expect(
        card.getPrimaryPrompt(CardLanguageMode.spanish),
        'Pregunta de Prueba 1',
      );
      expect(
        card.getPrimaryAnswer('Answer 1', CardLanguageMode.spanish),
        'Respuesta 1',
      );
    });

    test('returns paired content in bilingual mode', () {
      expect(
        card.getPrimaryPrompt(CardLanguageMode.bilingual),
        'Test Question 1',
      );
      expect(
        card.getSecondaryPrompt(CardLanguageMode.bilingual),
        'Pregunta de Prueba 1',
      );
      expect(
        card.getPrimaryAnswer('Answer 1', CardLanguageMode.bilingual),
        'Answer 1',
      );
      expect(
        card.getSecondaryAnswer('Answer 1', CardLanguageMode.bilingual),
        'Respuesta 1',
      );
    });
  });

  group('RoundResult', () {
    test('missedAnswers calculates correctly', () {
      const result = RoundResult(
        roundNumber: 1,
        teamIndex: 0,
        teamName: 'Team 1',
        selectedAnswers: ['A', 'B', 'C', 'D', 'E'],
        foundAnswers: ['A', 'C', 'E'],
        pointsEarned: 3,
      );

      expect(result.missedAnswers, containsAll(['B', 'D']));
      expect(result.missedAnswers.length, 2);
    });

    test('missedAnswers is empty when all answers found', () {
      const result = RoundResult(
        roundNumber: 1,
        teamIndex: 0,
        teamName: 'Team 1',
        selectedAnswers: ['A', 'B', 'C'],
        foundAnswers: ['A', 'B', 'C'],
        pointsEarned: 3,
      );

      expect(result.missedAnswers, isEmpty);
    });

    test('equality works correctly', () {
      const result1 = RoundResult(
        roundNumber: 1,
        teamIndex: 0,
        teamName: 'Team 1',
        selectedAnswers: ['A', 'B'],
        foundAnswers: ['A'],
        pointsEarned: 1,
      );
      const result2 = RoundResult(
        roundNumber: 1,
        teamIndex: 0,
        teamName: 'Team 1',
        selectedAnswers: ['A', 'B'],
        foundAnswers: ['A'],
        pointsEarned: 1,
      );
      const result3 = RoundResult(
        roundNumber: 2,
        teamIndex: 0,
        teamName: 'Team 1',
        selectedAnswers: ['A', 'B'],
        foundAnswers: ['A'],
        pointsEarned: 1,
      );

      expect(result1, equals(result2));
      expect(result1, isNot(equals(result3)));
    });
  });

  group('GameStateNotifier', () {
    late ProviderContainer container;

    setUp(() {
      // Create container with mocked cards provider
      container = ProviderContainer(
        overrides: [cardsProvider.overrideWith((ref) async => _mockCards)],
      );
      // Initialize teams for testing
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container
          .read(gameSetupProvider.notifier)
          .updateConfig(
            GameConfig(
              numberOfRounds: 5,
              roundDurationSeconds: 60,
              difficulties: {Difficulty.easy},
            ),
          );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is ready phase', () {
      final state = container.read(gameStateProvider);

      expect(state.gamePhase, GamePhase.ready);
      expect(state.currentRound, 1);
      expect(state.currentTeamIndex, 0);
    });

    test('reset returns to initial state', () {
      final notifier = container.read(gameStateProvider.notifier);
      notifier.reset();

      final state = container.read(gameStateProvider);

      expect(state.gamePhase, GamePhase.ready);
      expect(state.currentRound, 1);
      expect(state.currentTeamIndex, 0);
      expect(state.currentCard, isNull);
      expect(state.foundAnswers, isEmpty);
    });

    test('toggleAnswer does nothing in ready phase', () {
      final notifier = container.read(gameStateProvider.notifier);

      // Try to toggle without starting round
      notifier.toggleAnswer('Test Answer');

      final state = container.read(gameStateProvider);
      expect(state.foundAnswers, isEmpty);
    });

    test('beginTurn does nothing if not in preview phase', () {
      final notifier = container.read(gameStateProvider.notifier);

      // Try to begin turn without starting round
      notifier.beginTurn();

      final state = container.read(gameStateProvider);
      expect(state.gamePhase, GamePhase.ready);
    });

    test('endRound does nothing if not in playing phase', () {
      final notifier = container.read(gameStateProvider.notifier);

      // Try to end round without playing
      notifier.endRound();

      final state = container.read(gameStateProvider);
      expect(state.gamePhase, GamePhase.ready);
      expect(state.lastRoundResult, isNull);
    });

    test('startRound transitions to preview phase', () async {
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();

      final state = container.read(gameStateProvider);
      expect(state.gamePhase, GamePhase.preview);
      expect(state.currentCard, isNotNull);
      expect(state.selectedAnswers.length, 10);
    });

    test('bilingual mode keeps canonical answers for scoring', () async {
      container
          .read(gameSetupProvider.notifier)
          .updateCardLanguageMode(CardLanguageMode.bilingual);
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();

      final state = container.read(gameStateProvider);
      final card = state.currentCard!;
      expect(state.selectedAnswers, everyElement(isIn(card.answersEn)));
      for (final answer in state.selectedAnswers) {
        expect(
          card.getSecondaryAnswer(answer, CardLanguageMode.bilingual),
          isNotNull,
        );
      }
    });

    test('beginTurn transitions from preview to playing', () async {
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();
      expect(container.read(gameStateProvider).gamePhase, GamePhase.preview);

      notifier.beginTurn();
      expect(container.read(gameStateProvider).gamePhase, GamePhase.playing);
    });

    test('toggleAnswer adds answer when not present', () async {
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();
      notifier.beginTurn();

      final stateBeforeToggle = container.read(gameStateProvider);
      final testAnswer = stateBeforeToggle.selectedAnswers.first;

      notifier.toggleAnswer(testAnswer);

      final state = container.read(gameStateProvider);
      expect(state.foundAnswers, contains(testAnswer));
    });

    test('toggleAnswer removes answer when already present', () async {
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();
      notifier.beginTurn();

      final stateBeforeToggle = container.read(gameStateProvider);
      final testAnswer = stateBeforeToggle.selectedAnswers.first;

      // Toggle on
      notifier.toggleAnswer(testAnswer);
      expect(
        container.read(gameStateProvider).foundAnswers,
        contains(testAnswer),
      );

      // Toggle off
      notifier.toggleAnswer(testAnswer);
      expect(
        container.read(gameStateProvider).foundAnswers,
        isNot(contains(testAnswer)),
      );
    });

    test('endRound transitions to roundEnd phase', () async {
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();
      notifier.beginTurn();
      notifier.endRound();

      final state = container.read(gameStateProvider);
      expect(state.gamePhase, GamePhase.roundEnd);
      expect(state.lastRoundResult, isNotNull);
    });

    test('endRound creates correct round result', () async {
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();
      notifier.beginTurn();

      // Find some answers
      final selectedAnswers = container.read(gameStateProvider).selectedAnswers;
      notifier.toggleAnswer(selectedAnswers[0]);
      notifier.toggleAnswer(selectedAnswers[1]);

      notifier.endRound();

      final state = container.read(gameStateProvider);
      final result = state.lastRoundResult!;

      expect(result.roundNumber, 1);
      expect(result.teamIndex, 0);
      expect(result.foundAnswers.length, 2);
      expect(result.pointsEarned, greaterThan(0));
    });

    test('continueToNextRound advances team index within same round', () async {
      final notifier = container.read(gameStateProvider.notifier);

      // Complete first team's turn
      await notifier.startRound();
      notifier.beginTurn();
      notifier.endRound();

      // Continue to next team
      final continues = notifier.continueToNextRound();

      final state = container.read(gameStateProvider);
      expect(continues, true);
      expect(state.currentRound, 1); // Still round 1
      expect(state.currentTeamIndex, 1); // Team 2's turn
      expect(state.gamePhase, GamePhase.ready);
    });

    test('continueToNextRound advances round after all teams play', () async {
      final notifier = container.read(gameStateProvider.notifier);

      // Team 1 plays
      await notifier.startRound();
      notifier.beginTurn();
      notifier.endRound();
      notifier.continueToNextRound();

      // Team 2 plays
      await notifier.startRound();
      notifier.beginTurn();
      notifier.endRound();
      notifier.continueToNextRound();

      final state = container.read(gameStateProvider);
      expect(state.currentRound, 2); // Now round 2
      expect(state.currentTeamIndex, 0); // Back to team 1
    });

    test('continueToNextRound returns false when game ends', () async {
      // Set up for 1 round game
      container
          .read(gameSetupProvider.notifier)
          .updateConfig(
            GameConfig(
              numberOfRounds: 1,
              roundDurationSeconds: 60,
              difficulties: {Difficulty.easy},
            ),
          );

      final notifier = container.read(gameStateProvider.notifier);

      // Team 1 plays
      await notifier.startRound();
      notifier.beginTurn();
      notifier.endRound();
      notifier.continueToNextRound();

      // Team 2 plays (last turn of the game)
      await notifier.startRound();
      notifier.beginTurn();
      notifier.endRound();

      // Game should end
      final continues = notifier.continueToNextRound();
      expect(continues, false);
    });

    test('startRound tracks used card IDs', () async {
      final notifier = container.read(gameStateProvider.notifier);

      await notifier.startRound();
      final firstCardId = container.read(gameStateProvider).currentCard!.id;

      // Complete round
      notifier.beginTurn();
      notifier.endRound();
      notifier.continueToNextRound();

      // Next team starts
      await notifier.startRound();

      // First card should be tracked
      final state = container.read(gameStateProvider);
      expect(state.usedCardIdsInGame, contains(firstCardId));
    });
  });

  group('GameSetupNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has no teams', () {
      final state = container.read(gameSetupProvider);

      expect(state.teams, isEmpty);
      expect(state.isReadyToStart, false);
    });

    test('initializeTeams creates correct number of teams', () {
      container.read(gameSetupProvider.notifier).initializeTeams(3);

      final state = container.read(gameSetupProvider);
      expect(state.teams.length, 3);
    });

    test('initializeTeams assigns unique colors', () {
      container.read(gameSetupProvider.notifier).initializeTeams(4);

      final state = container.read(gameSetupProvider);
      final colors = state.teams.map((t) => t.color).toSet();
      expect(colors.length, 4); // All colors should be unique
    });

    test('initializeTeams throws for invalid team count', () {
      expect(
        () => container.read(gameSetupProvider.notifier).initializeTeams(1),
        throwsArgumentError,
      );
      expect(
        () => container.read(gameSetupProvider.notifier).initializeTeams(5),
        throwsArgumentError,
      );
    });

    test('updateTeamName changes team name', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container.read(gameSetupProvider.notifier).updateTeamName(0, 'Dragons');

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].name, 'Dragons');
    });

    test('updateTeamColor changes team color', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container
          .read(gameSetupProvider.notifier)
          .updateTeamColor(0, Colors.purple);

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].color, Colors.purple);
    });

    test('updateTeamScore adds points to team', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container.read(gameSetupProvider.notifier).updateTeamScore(0, 5);

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].score, 5);
    });

    test('updateTeamScore accumulates points', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container.read(gameSetupProvider.notifier).updateTeamScore(0, 5);
      container.read(gameSetupProvider.notifier).updateTeamScore(0, 3);

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].score, 8);
    });

    test('resetScores sets all team scores to zero', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container.read(gameSetupProvider.notifier).updateTeamScore(0, 10);
      container.read(gameSetupProvider.notifier).updateTeamScore(1, 15);
      container.read(gameSetupProvider.notifier).resetScores();

      final state = container.read(gameSetupProvider);
      expect(state.teams[0].score, 0);
      expect(state.teams[1].score, 0);
    });

    test('isReadyToStart returns true with valid setup', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);

      final state = container.read(gameSetupProvider);
      expect(state.isReadyToStart, true);
    });

    test('isReadyToStart returns false with empty team name', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container.read(gameSetupProvider.notifier).updateTeamName(0, '');

      final state = container.read(gameSetupProvider);
      expect(state.isReadyToStart, false);
    });

    test('reset clears all state', () {
      container.read(gameSetupProvider.notifier).initializeTeams(2);
      container.read(gameSetupProvider.notifier).updateTeamScore(0, 10);
      container.read(gameSetupProvider.notifier).reset();

      final state = container.read(gameSetupProvider);
      expect(state.teams, isEmpty);
    });

    test('updateNumberOfRounds changes config', () {
      container.read(gameSetupProvider.notifier).updateNumberOfRounds(10);

      final state = container.read(gameSetupProvider);
      expect(state.config.numberOfRounds, 10);
    });

    test('updateRoundDuration changes config', () {
      container.read(gameSetupProvider.notifier).updateRoundDuration(90);

      final state = container.read(gameSetupProvider);
      expect(state.config.roundDurationSeconds, 90);
    });

    test('updateDifficulties changes config', () {
      container.read(gameSetupProvider.notifier).updateDifficulties({
        Difficulty.hard,
      });

      final state = container.read(gameSetupProvider);
      expect(state.config.difficulties, {Difficulty.hard});
    });

    test('updateCardLanguageMode changes config', () {
      container
          .read(gameSetupProvider.notifier)
          .updateCardLanguageMode(CardLanguageMode.bilingual);

      final state = container.read(gameSetupProvider);
      expect(state.config.cardLanguageMode, CardLanguageMode.bilingual);
    });
  });
}
