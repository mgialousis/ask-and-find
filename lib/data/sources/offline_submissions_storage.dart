import 'dart:convert';
import 'dart:developer' show log;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';

/// Local storage for pending submissions when offline
///
/// Stores submissions in SharedPreferences as a JSON list.
/// These can be synced to Google Sheets when the device comes back online.
class OfflineSubmissionsStorage {
  static const String _pendingSubmissionsKey = 'pending_submissions';

  SharedPreferences? _prefs;

  /// Initialize shared preferences
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get all pending submissions
  Future<List<CardSubmission>> getPendingSubmissions() async {
    await initialize();

    final jsonString = _prefs!.getString(_pendingSubmissionsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => CardSubmission.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      log(
        'Failed to parse pending submissions: $e',
        name: 'OfflineSubmissionsStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Add a submission to the pending queue
  Future<bool> addPendingSubmission(CardSubmission submission) async {
    await initialize();

    try {
      final submissions = await getPendingSubmissions();
      submissions.add(submission);

      final jsonList = submissions.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      final result = await _prefs!.setString(_pendingSubmissionsKey, jsonString);

      if (result) {
        log(
          'Submission added to offline queue: ${submission.id}',
          name: 'OfflineSubmissionsStorage',
        );
      }
      return result;
    } catch (e, stackTrace) {
      log(
        'Failed to save pending submission: $e',
        name: 'OfflineSubmissionsStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Remove a submission from the pending queue
  Future<bool> removePendingSubmission(String submissionId) async {
    await initialize();

    try {
      final submissions = await getPendingSubmissions();
      submissions.removeWhere((s) => s.id == submissionId);

      final jsonList = submissions.map((s) => s.toJson()).toList();
      final jsonString = jsonEncode(jsonList);

      final result = await _prefs!.setString(_pendingSubmissionsKey, jsonString);

      if (result) {
        log(
          'Submission removed from offline queue: $submissionId',
          name: 'OfflineSubmissionsStorage',
        );
      }
      return result;
    } catch (e, stackTrace) {
      log(
        'Failed to remove pending submission: $e',
        name: 'OfflineSubmissionsStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clear all pending submissions
  Future<bool> clearPendingSubmissions() async {
    await initialize();

    try {
      final result = await _prefs!.remove(_pendingSubmissionsKey);
      log(
        'Pending submissions cleared',
        name: 'OfflineSubmissionsStorage',
      );
      return result;
    } catch (e, stackTrace) {
      log(
        'Failed to clear pending submissions: $e',
        name: 'OfflineSubmissionsStorage',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get the count of pending submissions
  Future<int> getPendingCount() async {
    final submissions = await getPendingSubmissions();
    return submissions.length;
  }

  /// Check if there are any pending submissions
  Future<bool> hasPendingSubmissions() async {
    final count = await getPendingCount();
    return count > 0;
  }
}
