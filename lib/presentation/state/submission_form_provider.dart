import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/domain/entities/card_item.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

/// State for the new card submission form
class NewCardFormState {
  final String promptEn;
  final List<String> answersEn;
  final Difficulty? difficulty;
  final String source;
  final String submitterName;
  final String submitterEmail;

  const NewCardFormState({
    this.promptEn = '',
    this.answersEn = const [],
    this.difficulty,
    this.source = '',
    this.submitterName = '',
    this.submitterEmail = '',
  });

  NewCardFormState copyWith({
    String? promptEn,
    List<String>? answersEn,
    Difficulty? difficulty,
    String? source,
    String? submitterName,
    String? submitterEmail,
  }) {
    return NewCardFormState(
      promptEn: promptEn ?? this.promptEn,
      answersEn: answersEn ?? this.answersEn,
      difficulty: difficulty ?? this.difficulty,
      source: source ?? this.source,
      submitterName: submitterName ?? this.submitterName,
      submitterEmail: submitterEmail ?? this.submitterEmail,
    );
  }

  /// Validate the form
  Map<String, String?> validate() {
    final errors = <String, String?>{};

    // Validate prompt
    if (promptEn.isEmpty) {
      errors['promptEn'] = 'Question is required';
    } else if (promptEn.length < 10) {
      errors['promptEn'] = 'Question must be at least 10 characters';
    } else if (promptEn.length > 200) {
      errors['promptEn'] = 'Question must be at most 200 characters';
    }

    // Validate answers
    final nonEmptyAnswers = answersEn.where((a) => a.isNotEmpty).toList();
    if (nonEmptyAnswers.length != 10) {
      errors['answersEn'] = 'Exactly 10 answers required';
    } else {
      // Check for duplicates
      final uniqueAnswers = nonEmptyAnswers.toSet();
      if (uniqueAnswers.length != nonEmptyAnswers.length) {
        errors['answersEn'] = 'Answers must be unique';
      }
      // Check individual answer length
      for (final answer in nonEmptyAnswers) {
        if (answer.length > 100) {
          errors['answersEn'] = 'Each answer must be at most 100 characters';
          break;
        }
      }
    }

    // Validate difficulty
    if (difficulty == null) {
      errors['difficulty'] = 'Difficulty is required';
    }

    // Validate source (optional but limited)
    if (source.length > 200) {
      errors['source'] = 'Source must be at most 200 characters';
    }

    // Validate email (optional but must be valid format if provided)
    if (submitterEmail.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
      if (!emailRegex.hasMatch(submitterEmail)) {
        errors['submitterEmail'] = 'Invalid email format';
      }
    }

    return errors;
  }

  /// Check if the form is valid
  bool get isValid => validate().isEmpty;
}

/// State for the correction submission form
class CorrectionFormState {
  final CardItem? selectedCard;
  final IssueType? issueType;
  final String issueDescription;
  final String submitterEmail;

  const CorrectionFormState({
    this.selectedCard,
    this.issueType,
    this.issueDescription = '',
    this.submitterEmail = '',
  });

  CorrectionFormState copyWith({
    CardItem? selectedCard,
    IssueType? issueType,
    String? issueDescription,
    String? submitterEmail,
  }) {
    return CorrectionFormState(
      selectedCard: selectedCard ?? this.selectedCard,
      issueType: issueType ?? this.issueType,
      issueDescription: issueDescription ?? this.issueDescription,
      submitterEmail: submitterEmail ?? this.submitterEmail,
    );
  }

  /// Validate the form
  Map<String, String?> validate() {
    final errors = <String, String?>{};

    // Validate card selection
    if (selectedCard == null) {
      errors['selectedCard'] = 'Card is required';
    }

    // Validate issue type
    if (issueType == null) {
      errors['issueType'] = 'Issue type is required';
    }

    // Validate description
    if (issueDescription.isEmpty) {
      errors['issueDescription'] = 'Description is required';
    } else if (issueDescription.length < 20) {
      errors['issueDescription'] = 'Description must be at least 20 characters';
    } else if (issueDescription.length > 1000) {
      errors['issueDescription'] = 'Description must be at most 1000 characters';
    }

    // Validate email (optional but must be valid format if provided)
    if (submitterEmail.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
      if (!emailRegex.hasMatch(submitterEmail)) {
        errors['submitterEmail'] = 'Invalid email format';
      }
    }

    return errors;
  }

  /// Check if the form is valid
  bool get isValid => validate().isEmpty;
}

/// Provider for new card form state
final newCardFormProvider =
    StateNotifierProvider<NewCardFormNotifier, NewCardFormState>((ref) {
  return NewCardFormNotifier();
});

/// Notifier for new card form
class NewCardFormNotifier extends StateNotifier<NewCardFormState> {
  NewCardFormNotifier() : super(const NewCardFormState());

  void setPrompt(String value) {
    state = state.copyWith(promptEn: value);
  }

  void setAnswers(List<String> answers) {
    state = state.copyWith(answersEn: answers);
  }

  void addAnswer(String answer) {
    final answers = List<String>.from(state.answersEn)..add(answer);
    state = state.copyWith(answersEn: answers);
  }

  void updateAnswer(int index, String answer) {
    final answers = List<String>.from(state.answersEn);
    if (index < answers.length) {
      answers[index] = answer;
      state = state.copyWith(answersEn: answers);
    }
  }

  void removeAnswer(int index) {
    final answers = List<String>.from(state.answersEn);
    if (index < answers.length) {
      answers.removeAt(index);
      state = state.copyWith(answersEn: answers);
    }
  }

  void setDifficulty(Difficulty? difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  void setSource(String value) {
    state = state.copyWith(source: value);
  }

  void setSubmitterName(String value) {
    state = state.copyWith(submitterName: value);
  }

  void setSubmitterEmail(String value) {
    state = state.copyWith(submitterEmail: value);
  }

  void reset() {
    state = const NewCardFormState();
  }

  /// Initialize with default empty answers
  void initializeAnswers([int count = 10]) {
    if (state.answersEn.isEmpty) {
      state = state.copyWith(
        answersEn: List.generate(count, (_) => ''),
      );
    }
  }
}

/// Provider for correction form state
final correctionFormProvider =
    StateNotifierProvider<CorrectionFormNotifier, CorrectionFormState>((ref) {
  return CorrectionFormNotifier();
});

/// Notifier for correction form
class CorrectionFormNotifier extends StateNotifier<CorrectionFormState> {
  CorrectionFormNotifier() : super(const CorrectionFormState());

  void setSelectedCard(CardItem? card) {
    state = state.copyWith(selectedCard: card);
  }

  void setIssueType(IssueType? type) {
    state = state.copyWith(issueType: type);
  }

  void setIssueDescription(String value) {
    state = state.copyWith(issueDescription: value);
  }

  void setSubmitterEmail(String value) {
    state = state.copyWith(submitterEmail: value);
  }

  void reset() {
    state = const CorrectionFormState();
  }
}
