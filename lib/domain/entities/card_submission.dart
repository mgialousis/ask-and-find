import 'package:equatable/equatable.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// Type of card submission
enum SubmissionType {
  newCard,
  correction;

  String get displayName {
    switch (this) {
      case SubmissionType.newCard:
        return 'New Card';
      case SubmissionType.correction:
        return 'Correction';
    }
  }
}

/// Issue types for card corrections
enum IssueType {
  wrongAnswer,
  outdatedInfo,
  spellingGrammar,
  unclearQuestion,
  other;

  String get displayName {
    switch (this) {
      case IssueType.wrongAnswer:
        return 'Wrong Answer';
      case IssueType.outdatedInfo:
        return 'Outdated Information';
      case IssueType.spellingGrammar:
        return 'Spelling/Grammar';
      case IssueType.unclearQuestion:
        return 'Unclear Question';
      case IssueType.other:
        return 'Other';
    }
  }
}

/// Represents a user's card submission (new card or correction)
class CardSubmission extends Equatable {
  final String id;
  final SubmissionType type;
  final DateTime submittedAt;

  // For new cards
  final String? promptEn;
  final List<String>? answersEn;
  final Difficulty? difficulty;
  final String? source;

  // For corrections
  final String? existingCardId;
  final String? existingCardPrompt;
  final IssueType? issueType;
  final String? issueDescription;

  // Submitter info (optional)
  final String? submitterName;
  final String? submitterEmail;

  // Metadata
  final String? appVersion;
  final String? locale;

  const CardSubmission({
    required this.id,
    required this.type,
    required this.submittedAt,
    this.promptEn,
    this.answersEn,
    this.difficulty,
    this.source,
    this.existingCardId,
    this.existingCardPrompt,
    this.issueType,
    this.issueDescription,
    this.submitterName,
    this.submitterEmail,
    this.appVersion,
    this.locale,
  });

  /// Create a new card submission
  factory CardSubmission.newCard({
    required String id,
    required String promptEn,
    required List<String> answersEn,
    required Difficulty difficulty,
    String? source,
    String? submitterName,
    String? submitterEmail,
    String? appVersion,
    String? locale,
  }) {
    return CardSubmission(
      id: id,
      type: SubmissionType.newCard,
      submittedAt: DateTime.now(),
      promptEn: promptEn,
      answersEn: answersEn,
      difficulty: difficulty,
      source: source,
      submitterName: submitterName,
      submitterEmail: submitterEmail,
      appVersion: appVersion,
      locale: locale,
    );
  }

  /// Create a correction submission
  factory CardSubmission.correction({
    required String id,
    required String existingCardId,
    required String existingCardPrompt,
    required IssueType issueType,
    required String issueDescription,
    String? submitterEmail,
    String? appVersion,
    String? locale,
  }) {
    return CardSubmission(
      id: id,
      type: SubmissionType.correction,
      submittedAt: DateTime.now(),
      existingCardId: existingCardId,
      existingCardPrompt: existingCardPrompt,
      issueType: issueType,
      issueDescription: issueDescription,
      submitterEmail: submitterEmail,
      appVersion: appVersion,
      locale: locale,
    );
  }

  /// Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'submittedAt': submittedAt.toIso8601String(),
      if (promptEn != null) 'promptEn': promptEn,
      if (answersEn != null) 'answersEn': answersEn,
      if (difficulty != null) 'difficulty': difficulty!.name,
      if (source != null) 'source': source,
      if (existingCardId != null) 'existingCardId': existingCardId,
      if (existingCardPrompt != null) 'existingCardPrompt': existingCardPrompt,
      if (issueType != null) 'issueType': issueType!.name,
      if (issueDescription != null) 'issueDescription': issueDescription,
      if (submitterName != null) 'submitterName': submitterName,
      if (submitterEmail != null) 'submitterEmail': submitterEmail,
      if (appVersion != null) 'appVersion': appVersion,
      if (locale != null) 'locale': locale,
    };
  }

  /// Create from JSON
  factory CardSubmission.fromJson(Map<String, dynamic> json) {
    return CardSubmission(
      id: json['id'] as String,
      type: SubmissionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SubmissionType.newCard,
      ),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      promptEn: json['promptEn'] as String?,
      answersEn: (json['answersEn'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      difficulty: json['difficulty'] != null
          ? Difficulty.values.firstWhere(
              (e) => e.name == json['difficulty'],
              orElse: () => Difficulty.medium,
            )
          : null,
      source: json['source'] as String?,
      existingCardId: json['existingCardId'] as String?,
      existingCardPrompt: json['existingCardPrompt'] as String?,
      issueType: json['issueType'] != null
          ? IssueType.values.firstWhere(
              (e) => e.name == json['issueType'],
              orElse: () => IssueType.other,
            )
          : null,
      issueDescription: json['issueDescription'] as String?,
      submitterName: json['submitterName'] as String?,
      submitterEmail: json['submitterEmail'] as String?,
      appVersion: json['appVersion'] as String?,
      locale: json['locale'] as String?,
    );
  }

  /// Validate new card submission
  bool get isValidNewCard {
    if (type != SubmissionType.newCard) return false;
    if (promptEn == null || promptEn!.isEmpty) return false;
    if (promptEn!.length < 10 || promptEn!.length > 200) return false;
    if (answersEn == null) return false;
    if (answersEn!.length != 10) return false;
    if (difficulty == null) return false;
    // Check for unique, non-empty answers
    final uniqueAnswers = answersEn!.where((a) => a.isNotEmpty).toSet();
    if (uniqueAnswers.length != answersEn!.length) return false;
    return true;
  }

  /// Validate correction submission
  bool get isValidCorrection {
    if (type != SubmissionType.correction) return false;
    if (existingCardId == null || existingCardId!.isEmpty) return false;
    if (issueType == null) return false;
    if (issueDescription == null || issueDescription!.isEmpty) return false;
    if (issueDescription!.length < 20 || issueDescription!.length > 1000) {
      return false;
    }
    return true;
  }

  @override
  List<Object?> get props => [
    id,
    type,
    submittedAt,
    promptEn,
    answersEn,
    difficulty,
    source,
    existingCardId,
    existingCardPrompt,
    issueType,
    issueDescription,
    submitterName,
    submitterEmail,
    appVersion,
    locale,
  ];

  @override
  String toString() =>
      'CardSubmission(id: $id, type: ${type.name}, submittedAt: $submittedAt)';
}
