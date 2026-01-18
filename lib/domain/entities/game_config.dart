import 'package:equatable/equatable.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// Configuration for a game session
class GameConfig extends Equatable {
  final int numberOfRounds;
  final int roundDurationSeconds;
  final Set<Difficulty> difficulties;

  const GameConfig({
    required this.numberOfRounds,
    required this.roundDurationSeconds,
    required this.difficulties,
  });

  /// Create a default game configuration
  factory GameConfig.defaultConfig() {
    return const GameConfig(
      numberOfRounds: 5,
      roundDurationSeconds: 60,
      difficulties: {Difficulty.medium},
    );
  }

  /// Common round options
  static const List<int> roundOptions = [5, 7, 10];

  /// Common timer duration options (in seconds)
  static const List<int> timerOptions = [30, 45, 60, 90];

  /// Check if the configuration is valid
  bool get isValid {
    return numberOfRounds > 0 &&
        roundDurationSeconds > 0 &&
        roundDurationSeconds <= 180 && // Max 3 minutes per round
        difficulties.isNotEmpty;
  }

  /// Get the total estimated game duration in minutes
  int get estimatedDurationMinutes {
    // Estimate: round duration + 30 seconds between rounds
    final totalSeconds = numberOfRounds * (roundDurationSeconds + 30);
    return (totalSeconds / 60).ceil();
  }

  /// Create a copy with updated fields
  GameConfig copyWith({
    int? numberOfRounds,
    int? roundDurationSeconds,
    Set<Difficulty>? difficulties,
  }) {
    return GameConfig(
      numberOfRounds: numberOfRounds ?? this.numberOfRounds,
      roundDurationSeconds: roundDurationSeconds ?? this.roundDurationSeconds,
      difficulties: difficulties ?? this.difficulties,
    );
  }

  @override
  List<Object?> get props => [numberOfRounds, roundDurationSeconds, difficulties];

  @override
  String toString() =>
      'GameConfig(rounds: $numberOfRounds, duration: ${roundDurationSeconds}s, difficulties: $difficulties)';
}
