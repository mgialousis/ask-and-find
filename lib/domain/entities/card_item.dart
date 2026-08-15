import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:pes_vres/domain/entities/card_language_mode.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// Represents a card/question in the game
class CardItem extends Equatable {
  final String id;
  final String promptEn;
  final String? promptEs;
  final List<String> answersEn;
  final List<String>? answersEs;
  final Difficulty difficulty;
  final Map<String, int>? answerPoints;
  final String? source;
  final List<String> languageScope;

  const CardItem({
    required this.id,
    required this.promptEn,
    this.promptEs,
    required this.answersEn,
    this.answersEs,
    required this.difficulty,
    this.answerPoints,
    this.source,
    this.languageScope = const ['en', 'es'],
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    final answers = (json['answersEn'] as List<dynamic>)
        .map((value) => value as String)
        .toList();
    final answersEs = (json['answersEs'] as List<dynamic>?)
        ?.map((value) => value as String)
        .toList();
    final languageScope =
        (json['languageScope'] as List<dynamic>?)
            ?.map((value) => value as String)
            .toList() ??
        const ['en', 'es'];
    final rawPoints = json['answerPoints'] ?? json['answerDifficulties'];
    final answerPoints = rawPoints is Map<String, dynamic>
        ? rawPoints.map((key, value) => MapEntry(key, _parsePoints(value)))
        : null;

    return CardItem(
      id: json['id'] as String,
      promptEn: json['promptEn'] as String,
      promptEs: json['promptEs'] as String?,
      answersEn: answers,
      answersEs: answersEs,
      difficulty: parseDifficulty(json['difficulty'] as String),
      answerPoints: answerPoints,
      source: json['source'] as String?,
      languageScope: languageScope,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'promptEn': promptEn,
      if (promptEs != null) 'promptEs': promptEs,
      'answersEn': answersEn,
      if (answersEs != null) 'answersEs': answersEs,
      'difficulty': difficulty.name,
      'languageScope': languageScope,
      if (answerPoints != null) 'answerPoints': answerPoints,
      if (source != null) 'source': source,
    };
  }

  /// Validate that the card has the required number of answers (10-15)
  bool get isValid {
    return answersEn.length >= 10 && answersEn.length <= 15;
  }

  String getPrompt(Locale locale) {
    if (locale.languageCode == 'es' && promptEs != null) {
      return promptEs!;
    }
    return promptEn;
  }

  List<String> getAnswers(Locale locale) {
    if (locale.languageCode == 'es' &&
        answersEs != null &&
        answersEs!.isNotEmpty) {
      return answersEs!;
    }
    return answersEn;
  }

  bool supportsLocale(Locale locale) {
    return languageScope.contains(locale.languageCode);
  }

  bool supportsLanguageMode(CardLanguageMode mode) {
    if (!mode.requiredLanguageCodes.every(languageScope.contains)) {
      return false;
    }
    if (mode == CardLanguageMode.english) {
      return true;
    }
    return promptEs != null &&
        answersEs != null &&
        answersEs!.length == answersEn.length;
  }

  String getPrimaryPrompt(CardLanguageMode mode) {
    return switch (mode) {
      CardLanguageMode.english || CardLanguageMode.bilingual => promptEn,
      CardLanguageMode.spanish => promptEs ?? promptEn,
    };
  }

  String? getSecondaryPrompt(CardLanguageMode mode) {
    if (mode != CardLanguageMode.bilingual || promptEs == null) {
      return null;
    }
    return promptEs == promptEn ? null : promptEs;
  }

  String getPrimaryAnswer(String canonicalAnswer, CardLanguageMode mode) {
    if (mode == CardLanguageMode.spanish) {
      return _spanishAnswerFor(canonicalAnswer);
    }
    return canonicalAnswer;
  }

  String? getSecondaryAnswer(String canonicalAnswer, CardLanguageMode mode) {
    if (mode != CardLanguageMode.bilingual) {
      return null;
    }
    final spanishAnswer = _spanishAnswerFor(canonicalAnswer);
    return spanishAnswer == canonicalAnswer ? null : spanishAnswer;
  }

  String _spanishAnswerFor(String canonicalAnswer) {
    final index = answersEn.indexOf(canonicalAnswer);
    if (index < 0 || answersEs == null || index >= answersEs!.length) {
      return canonicalAnswer;
    }
    return answersEs![index];
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
    return answers.fold(0, (total, answer) => total + pointsForAnswer(answer));
  }

  @override
  List<Object?> get props => [
    id,
    promptEn,
    promptEs,
    answersEn,
    answersEs,
    difficulty,
    answerPoints,
    source,
    languageScope,
  ];

  @override
  String toString() =>
      'CardItem(id: $id, prompt: $promptEn, difficulty: $difficulty, answers: ${answersEn.length})';
}
