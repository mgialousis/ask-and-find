import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/core/theme/app_colors.dart';
import 'package:pes_vres/domain/entities/card_language_mode.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:pes_vres/domain/entities/game_config.dart';
import 'package:pes_vres/domain/entities/team.dart';
import 'package:uuid/uuid.dart';

/// Game setup state - holds team configuration and game settings
///
/// This state is configured during the setup screen and used
/// throughout the game session.
class GameSetupState extends Equatable {
  const GameSetupState({required this.teams, required this.config});

  final List<Team> teams;
  final GameConfig config;

  /// Initial empty state with default config
  factory GameSetupState.initial() =>
      GameSetupState(teams: [], config: GameConfig.defaultConfig());

  /// Create a copy with optional field updates
  GameSetupState copyWith({List<Team>? teams, GameConfig? config}) {
    return GameSetupState(
      teams: teams ?? this.teams,
      config: config ?? this.config,
    );
  }

  /// Check if setup is ready for game start
  bool get isReadyToStart {
    return teams.length >= 2 &&
        teams.length <= 4 &&
        teams.every((team) => team.name.trim().isNotEmpty) &&
        config.isValid;
  }

  @override
  List<Object?> get props => [teams, config];

  @override
  String toString() =>
      'GameSetupState(teams: ${teams.length}, config: $config)';
}

/// Game setup notifier - manages team and configuration setup
///
/// Provides methods to:
/// - Initialize teams with default names and colors
/// - Update individual team properties
/// - Update game configuration
/// - Reset scores for "Play Again" functionality
/// - Clear all setup data
class GameSetupNotifier extends StateNotifier<GameSetupState> {
  GameSetupNotifier() : super(GameSetupState.initial());

  final _uuid = const Uuid();

  /// Initialize teams with default names and colors
  ///
  /// Creates [numberOfTeams] teams (2-4) with:
  /// - Unique IDs
  /// - Default names ("Team 1", "Team 2", etc.)
  /// - Distinct colors from AppColors.teamColors
  /// - Zero scores
  void initializeTeams(int numberOfTeams) {
    if (numberOfTeams < 2 || numberOfTeams > 4) {
      throw ArgumentError('Number of teams must be between 2 and 4');
    }

    final teams = List.generate(
      numberOfTeams,
      (index) => Team(
        id: _uuid.v4(),
        name: 'Team ${index + 1}',
        color: AppColors.teamColors[index % AppColors.teamColors.length],
        score: 0,
      ),
    );

    state = state.copyWith(teams: teams);
  }

  /// Update a team at the specified index
  ///
  /// Throws RangeError if index is out of bounds
  void updateTeam(int index, Team team) {
    if (index < 0 || index >= state.teams.length) {
      throw RangeError('Team index $index out of bounds');
    }

    final updatedTeams = List<Team>.from(state.teams);
    updatedTeams[index] = team;
    state = state.copyWith(teams: updatedTeams);
  }

  /// Update team name at the specified index
  void updateTeamName(int index, String name) {
    if (index < 0 || index >= state.teams.length) {
      return;
    }
    final team = state.teams[index];
    updateTeam(index, team.copyWith(name: name));
  }

  /// Update team color at the specified index
  void updateTeamColor(int index, Color color) {
    if (index < 0 || index >= state.teams.length) {
      return;
    }
    final team = state.teams[index];
    updateTeam(index, team.copyWith(color: color));
  }

  /// Update game configuration
  void updateConfig(GameConfig config) {
    state = state.copyWith(config: config);
  }

  /// Update number of rounds
  void updateNumberOfRounds(int rounds) {
    state = state.copyWith(
      config: state.config.copyWith(numberOfRounds: rounds),
    );
  }

  /// Update round duration in seconds
  void updateRoundDuration(int seconds) {
    state = state.copyWith(
      config: state.config.copyWith(roundDurationSeconds: seconds),
    );
  }

  /// Update difficulty level
  void updateDifficulties(Set<Difficulty> difficulties) {
    state = state.copyWith(
      config: state.config.copyWith(difficulties: difficulties),
    );
  }

  /// Update the language used to display card content.
  void updateCardLanguageMode(CardLanguageMode mode) {
    state = state.copyWith(
      config: state.config.copyWith(cardLanguageMode: mode),
    );
  }

  /// Reset all team scores to zero
  ///
  /// Used for "Play Again" functionality - keeps teams and config,
  /// but resets scores for a new game session.
  void resetScores() {
    final resetTeams = state.teams.map((team) => team.resetScore()).toList();
    state = state.copyWith(teams: resetTeams);
  }

  /// Update team score (for active gameplay)
  void updateTeamScore(int index, int points) {
    final team = state.teams[index];
    updateTeam(index, team.addPoints(points));
  }

  /// Clear all setup data and return to initial state
  void reset() {
    state = GameSetupState.initial();
  }
}

/// Provider for game setup state
///
/// Usage:
/// ```dart
/// // Initialize teams
/// ref.read(gameSetupProvider.notifier).initializeTeams(2);
///
/// // Update a team
/// ref.read(gameSetupProvider.notifier).updateTeamName(0, 'Red Dragons');
///
/// // Update config
/// ref.read(gameSetupProvider.notifier).updateNumberOfRounds(10);
///
/// // Read state
/// final setup = ref.watch(gameSetupProvider);
/// if (setup.isReadyToStart) { /* start game */ }
/// ```
final gameSetupProvider =
    StateNotifierProvider<GameSetupNotifier, GameSetupState>(
      (ref) => GameSetupNotifier(),
    );
