import 'package:equatable/equatable.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// Represents a card/question in the game
class CardItem extends Equatable {
  final String id;
  final String promptEn;
  final List<String> answersEn;
  final Difficulty difficulty;
  final Map<String, int>? answerPoints;
  final String? source;

  const CardItem({
    required this.id,
    required this.promptEn,
    required this.answersEn,
    required this.difficulty,
    this.answerPoints,
    this.source,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    final answers = (json['answersEn'] as List<dynamic>)
        .map((value) => value as String)
        .toList();
    final rawPoints = json['answerPoints'] ?? json['answerDifficulties'];
    final answerPoints = rawPoints is Map<String, dynamic>
        ? rawPoints.map(
            (key, value) => MapEntry(key, _parsePoints(value)),
          )
        : null;

    return CardItem(
      id: json['id'] as String,
      promptEn: json['promptEn'] as String,
      answersEn: answers,
      difficulty: parseDifficulty(json['difficulty'] as String),
      answerPoints: answerPoints,
      source: json['source'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promptEn': promptEn,
      'answersEn': answersEn,
      'difficulty': difficulty.name,
      if (answerPoints != null) 'answerPoints': answerPoints,
      if (source != null) 'source': source,
    };
  }

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

  int pointsForAnswer(String answer) {
    final points = answerPoints?[answer];
    if (points != null) {
      return points.clamp(1, 5);
    }
    return difficulty.pointsPerAnswer;
  }

  static int _parsePoints(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.parse(value);
    throw ArgumentError('Invalid point value: $value');
  }

  int pointsForAnswers(Iterable<String> answers) {
    return answers.fold(
      0,
      (total, answer) => total + pointsForAnswer(answer),
    );
  }

  @override
  List<Object?> get props => [
        id,
        promptEn,
        answersEn,
        difficulty,
        answerPoints,
        source,
      ];

  @override
  String toString() =>
      'CardItem(id: $id, prompt: $promptEn, difficulty: $difficulty, answers: ${answersEn.length})';
}
