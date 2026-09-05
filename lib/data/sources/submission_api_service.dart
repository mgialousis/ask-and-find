import 'dart:convert';
import 'dart:developer' show log;

import 'package:http/http.dart' as http;
import 'package:pes_vres/core/config/submission_endpoint_config.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';

abstract interface class SubmissionTransport {
  bool get isConfigured;

  Future<bool> submit(CardSubmission submission);
}

/// Sends community submissions to a separately deployed HTTPS backend.
///
/// No privileged credential or shared secret belongs in this client. The
/// backend is responsible for validation, abuse protection, and persistence.
class SubmissionApiService implements SubmissionTransport {
  SubmissionApiService({http.Client? client, Uri? endpoint})
    : _client = client ?? http.Client(),
      _endpoint = endpoint ?? SubmissionEndpointConfig.endpoint;

  final http.Client _client;
  final Uri? _endpoint;

  @override
  bool get isConfigured => _endpoint != null;

  @override
  Future<bool> submit(CardSubmission submission) async {
    final endpoint = _endpoint;
    if (endpoint == null) {
      log(
        'Submission API is not configured; saving locally.',
        name: 'SubmissionApiService',
      );
      return false;
    }

    try {
      final response = await _client.post(
        endpoint,
        headers: const {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'schemaVersion': 1,
          'submission': submission.toJson(),
        }),
      );
      final succeeded = response.statusCode >= 200 && response.statusCode < 300;
      if (!succeeded) {
        log(
          'Submission API returned HTTP ${response.statusCode}.',
          name: 'SubmissionApiService',
        );
      }
      return succeeded;
    } catch (error, stackTrace) {
      log(
        'Submission API request failed.',
        name: 'SubmissionApiService',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
