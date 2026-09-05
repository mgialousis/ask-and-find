import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pes_vres/data/sources/submission_api_service.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';
import 'package:pes_vres/domain/entities/difficulty.dart';

void main() {
  CardSubmission submission() => CardSubmission.newCard(
    id: 'submission-1',
    promptEn: 'Name ten European capitals',
    answersEn: List.generate(10, (index) => 'Answer $index'),
    difficulty: Difficulty.medium,
    locale: 'en',
  );

  test('is not configured without an endpoint', () {
    final service = SubmissionApiService(endpoint: null);

    expect(service.isConfigured, isFalse);
  });

  test('posts a versioned JSON payload to the configured endpoint', () async {
    late Request captured;
    final client = MockClient((request) async {
      captured = request;
      return Response('', 202);
    });
    final endpoint = Uri.parse('https://example.com/api/submissions');
    final service = SubmissionApiService(client: client, endpoint: endpoint);

    expect(await service.submit(submission()), isTrue);
    expect(captured.url, endpoint);
    expect(captured.headers['content-type'], 'application/json');

    final payload = jsonDecode(captured.body) as Map<String, dynamic>;
    expect(payload['schemaVersion'], 1);
    final submitted = payload['submission'] as Map<String, dynamic>;
    expect(submitted['id'], 'submission-1');
    expect(submitted['type'], 'newCard');
    expect(submitted['locale'], 'en');
  });

  test('returns false for a non-success response', () async {
    final client = MockClient((_) async => Response('', 429));
    final service = SubmissionApiService(
      client: client,
      endpoint: Uri.parse('https://example.com/api/submissions'),
    );

    expect(await service.submit(submission()), isFalse);
  });

  test('returns false when the request fails', () async {
    final client = MockClient((_) => throw ClientException('offline'));
    final service = SubmissionApiService(
      client: client,
      endpoint: Uri.parse('https://example.com/api/submissions'),
    );

    expect(await service.submit(submission()), isFalse);
  });
}
