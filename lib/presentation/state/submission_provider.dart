import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/data/repositories/submissions_repository.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';
import 'package:uuid/uuid.dart';

export 'package:pes_vres/data/repositories/submissions_repository.dart'
    show SubmissionResult;
export 'package:pes_vres/domain/entities/card_submission.dart'
    show IssueType, SubmissionType;
export 'package:pes_vres/domain/entities/difficulty.dart' show Difficulty;

/// State for submission operations
class SubmissionState {
  final bool isSubmitting;
  final SubmissionResult? lastResult;
  final String? errorMessage;
  final int pendingCount;

  const SubmissionState({
    this.isSubmitting = false,
    this.lastResult,
    this.errorMessage,
    this.pendingCount = 0,
  });

  SubmissionState copyWith({
    bool? isSubmitting,
    SubmissionResult? lastResult,
    String? errorMessage,
    int? pendingCount,
  }) {
    return SubmissionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastResult: lastResult ?? this.lastResult,
      errorMessage: errorMessage ?? this.errorMessage,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }
}

/// Provider for the submissions repository
final submissionsRepositoryProvider = Provider<SubmissionsRepository>((ref) {
  return SubmissionsRepository();
});

/// Provider for submission state and operations
final submissionProvider =
    StateNotifierProvider<SubmissionNotifier, SubmissionState>((ref) {
  return SubmissionNotifier(ref.watch(submissionsRepositoryProvider));
});

/// Notifier for managing submission state
class SubmissionNotifier extends StateNotifier<SubmissionState> {
  final SubmissionsRepository _repository;
  final Uuid _uuid = const Uuid();
  StreamSubscription? _connectivitySubscription;

  SubmissionNotifier(this._repository) : super(const SubmissionState()) {
    _init();
  }

  Future<void> _init() async {
    await _updatePendingCount();
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _connectivitySubscription = _repository.connectivityStream.listen((_) {
      // When connectivity changes, try to sync pending submissions
      syncPendingSubmissions();
    });
  }

  Future<void> _updatePendingCount() async {
    final count = await _repository.getPendingCount();
    state = state.copyWith(pendingCount: count);
  }

  /// Submit a new card
  Future<SubmissionResult> submitNewCard({
    required String promptEn,
    required List<String> answersEn,
    required Difficulty difficulty,
    String? source,
    String? submitterName,
    String? submitterEmail,
    String? appVersion,
    String? locale,
  }) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final submission = CardSubmission.newCard(
      id: _uuid.v4(),
      promptEn: promptEn,
      answersEn: answersEn,
      difficulty: difficulty,
      source: source,
      submitterName: submitterName,
      submitterEmail: submitterEmail,
      appVersion: appVersion,
      locale: locale,
    );

    if (!submission.isValidNewCard) {
      state = state.copyWith(
        isSubmitting: false,
        lastResult: SubmissionResult.failed,
        errorMessage: 'Invalid submission data',
      );
      return SubmissionResult.failed;
    }

    final result = await _repository.submit(submission);
    await _updatePendingCount();

    state = state.copyWith(
      isSubmitting: false,
      lastResult: result,
      errorMessage: result == SubmissionResult.failed
          ? 'Failed to submit card'
          : null,
    );

    return result;
  }

  /// Submit a correction
  Future<SubmissionResult> submitCorrection({
    required String existingCardId,
    required String existingCardPrompt,
    required IssueType issueType,
    required String issueDescription,
    String? submitterEmail,
    String? appVersion,
    String? locale,
  }) async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    final submission = CardSubmission.correction(
      id: _uuid.v4(),
      existingCardId: existingCardId,
      existingCardPrompt: existingCardPrompt,
      issueType: issueType,
      issueDescription: issueDescription,
      submitterEmail: submitterEmail,
      appVersion: appVersion,
      locale: locale,
    );

    if (!submission.isValidCorrection) {
      state = state.copyWith(
        isSubmitting: false,
        lastResult: SubmissionResult.failed,
        errorMessage: 'Invalid correction data',
      );
      return SubmissionResult.failed;
    }

    final result = await _repository.submit(submission);
    await _updatePendingCount();

    state = state.copyWith(
      isSubmitting: false,
      lastResult: result,
      errorMessage: result == SubmissionResult.failed
          ? 'Failed to submit correction'
          : null,
    );

    return result;
  }

  /// Sync pending submissions
  Future<int> syncPendingSubmissions() async {
    final synced = await _repository.syncPendingSubmissions();
    await _updatePendingCount();
    return synced;
  }

  /// Get pending submissions
  Future<List<CardSubmission>> getPendingSubmissions() async {
    return _repository.getPendingSubmissions();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
