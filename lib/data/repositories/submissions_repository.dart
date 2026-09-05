import 'dart:developer' show log;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pes_vres/data/sources/offline_submissions_storage.dart';
import 'package:pes_vres/data/sources/submission_api_service.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';

/// Result of a submission attempt
enum SubmissionResult {
  /// Successfully accepted by the submission API
  success,

  /// Saved locally for later submission (offline)
  savedLocally,

  /// Failed to submit and failed to save locally
  failed,
}

/// Repository for managing card submissions
///
/// Handles online submission to the configured API and offline storage
/// with automatic sync when connectivity is restored.
class SubmissionsRepository {
  final SubmissionTransport _submissionTransport;
  final OfflineSubmissionsStorage _offlineStorage;
  final Connectivity _connectivity;

  SubmissionsRepository({
    SubmissionTransport? submissionTransport,
    OfflineSubmissionsStorage? offlineStorage,
    Connectivity? connectivity,
  }) : _submissionTransport = submissionTransport ?? SubmissionApiService(),
       _offlineStorage = offlineStorage ?? OfflineSubmissionsStorage(),
       _connectivity = connectivity ?? Connectivity();

  /// Check if the device is connected to the internet
  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  /// Submit a card submission
  ///
  /// If online, submits to the configured HTTPS backend.
  /// If offline, saves locally for later submission.
  Future<SubmissionResult> submit(CardSubmission submission) async {
    final online = await isOnline();

    if (online && _submissionTransport.isConfigured) {
      try {
        final success = await _submissionTransport.submit(submission);
        if (success) {
          log(
            'Submission successful: ${submission.id}',
            name: 'SubmissionsRepository',
          );
          return SubmissionResult.success;
        }
      } catch (e, stackTrace) {
        log(
          'Online submission failed, saving locally: $e',
          name: 'SubmissionsRepository',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    // Either offline or submission failed, save locally
    final saved = await _offlineStorage.addPendingSubmission(submission);
    if (saved) {
      log(
        'Submission saved locally: ${submission.id}',
        name: 'SubmissionsRepository',
      );
      return SubmissionResult.savedLocally;
    }

    log(
      'Failed to save submission: ${submission.id}',
      name: 'SubmissionsRepository',
    );
    return SubmissionResult.failed;
  }

  /// Sync all pending submissions to the configured backend
  ///
  /// Call this when the device comes back online.
  /// Returns the number of successfully synced submissions.
  Future<int> syncPendingSubmissions() async {
    if (!await isOnline()) {
      log('Cannot sync: device is offline', name: 'SubmissionsRepository');
      return 0;
    }

    if (!_submissionTransport.isConfigured) {
      log(
        'Cannot sync: submission API not configured',
        name: 'SubmissionsRepository',
      );
      return 0;
    }

    final pending = await _offlineStorage.getPendingSubmissions();
    if (pending.isEmpty) {
      log('No pending submissions to sync', name: 'SubmissionsRepository');
      return 0;
    }

    int syncedCount = 0;

    for (final submission in pending) {
      try {
        final success = await _submissionTransport.submit(submission);
        if (success) {
          await _offlineStorage.removePendingSubmission(submission.id);
          syncedCount++;
          log(
            'Synced pending submission: ${submission.id}',
            name: 'SubmissionsRepository',
          );
        }
      } catch (e, stackTrace) {
        log(
          'Failed to sync submission ${submission.id}: $e',
          name: 'SubmissionsRepository',
          error: e,
          stackTrace: stackTrace,
        );
      }
    }

    log(
      'Sync complete: $syncedCount of ${pending.length} submissions synced',
      name: 'SubmissionsRepository',
    );
    return syncedCount;
  }

  /// Get all pending (offline) submissions
  Future<List<CardSubmission>> getPendingSubmissions() async {
    return _offlineStorage.getPendingSubmissions();
  }

  /// Get the count of pending submissions
  Future<int> getPendingCount() async {
    return _offlineStorage.getPendingCount();
  }

  /// Check if there are pending submissions
  Future<bool> hasPendingSubmissions() async {
    return _offlineStorage.hasPendingSubmissions();
  }

  /// Clear all pending submissions
  Future<bool> clearPendingSubmissions() async {
    return _offlineStorage.clearPendingSubmissions();
  }

  /// Listen to connectivity changes
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}
