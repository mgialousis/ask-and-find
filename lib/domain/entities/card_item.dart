import 'package:equatable/equatable.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// Represents a card/question in the game
class CardItem extends Equatable {
  final String id;
  final String promptEn;
  final List<String> answersEn;
  final Difficulty difficulty;
  final String? source;

  const CardItem({
    required this.id,
    required this.promptEn,
    required this.answersEn,
    required this.difficulty,
    this.source,
  });

  /// Validate that the card has the required number of answers (10-15)
  bool get isValid {
    return answersEn.length >= 10 && answersEn.length <= 15;
  }

  /// Get a random subset of answers for a round (exactly 10 answers)
  List<String> getRandomAnswers() {
    if (answersEn.length < 10) {
      throw StateError('Card must have at least 10 answers');
    }

    final shuffled = List<String>.from(answersEn)..shuffle();
    return shuffled.take(10).toList();
  }

  @override
  List<Object?> get props => [id, promptEn, answersEn, difficulty, source];

  @override
  String toString() =>
      'CardItem(id: $id, prompt: $promptEn, difficulty: $difficulty, answers: ${answersEn.length})';
}
