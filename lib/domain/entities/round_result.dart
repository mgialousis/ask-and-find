import 'package:equatable/equatable.dart';

/// Represents the result of a single round in the game
class RoundResult extends Equatable {
  final int roundNumber;
  final String teamId;
  final String cardId;
  final List<String> selectedAnswers;
  final List<String> foundAnswers;
  final int pointsEarned;
  final bool isOvertime;

  const RoundResult({
    required this.roundNumber,
    required this.teamId,
    required this.cardId,
    required this.selectedAnswers,
    required this.foundAnswers,
    required this.pointsEarned,
    this.isOvertime = false,
  });

  /// Calculate the number of missed answers
  int get missedAnswersCount => selectedAnswers.length - foundAnswers.length;

  /// Get the list of missed answers
  List<String> get missedAnswers {
    return selectedAnswers
        .where((answer) => !foundAnswers.contains(answer))
        .toList();
  }

  /// Calculate the success rate as a percentage
  double get successRate {
    if (selectedAnswers.isEmpty) return 0.0;
    return (foundAnswers.length / selectedAnswers.length) * 100;
  }

  /// Check if the round was a perfect score
  bool get isPerfect => foundAnswers.length == selectedAnswers.length;

  @override
  List<Object?> get props => [
        roundNumber,
        teamId,
        cardId,
        selectedAnswers,
        foundAnswers,
        pointsEarned,
        isOvertime,
      ];

  @override
  String toString() =>
      'RoundResult(round: $roundNumber, team: $teamId, found: ${foundAnswers.length}/${selectedAnswers.length}, points: $pointsEarned)';
}
