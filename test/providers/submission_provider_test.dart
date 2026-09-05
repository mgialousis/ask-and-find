import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/data/repositories/submissions_repository.dart';
import 'package:pes_vres/domain/entities/card_submission.dart';
import 'package:pes_vres/presentation/state/submission_provider.dart';

class FakeSubmissionsRepository extends SubmissionsRepository {
  FakeSubmissionsRepository({
    this.submitResult = SubmissionResult.success,
    this.pendingCount = 0,
  });

  final SubmissionResult submitResult;
  final int pendingCount;
  CardSubmission? lastSubmission;

  @override
  Stream<List<ConnectivityResult>> get connectivityStream =>
      const Stream<List<ConnectivityResult>>.empty();

  @override
  Future<SubmissionResult> submit(CardSubmission submission) async {
    lastSubmission = submission;
    return submitResult;
  }

  @override
  Future<int> getPendingCount() async => pendingCount;
}

void main() {
  test('submitNewCard passes app version and locale', () async {
    final repo = FakeSubmissionsRepository(
      submitResult: SubmissionResult.success,
    );
    final container = ProviderContainer(
      overrides: [submissionsRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(submissionProvider.notifier);
    final result = await notifier.submitNewCard(
      promptEn: 'Name 10 European capitals',
      answersEn: List.generate(10, (index) => 'Answer $index'),
      difficulty: Difficulty.medium,
      appVersion: '1.2.3+4',
      locale: 'en',
    );

    expect(result, SubmissionResult.success);
    final state = container.read(submissionProvider);
    expect(state.lastResult, SubmissionResult.success);
    expect(repo.lastSubmission?.appVersion, '1.2.3+4');
    expect(repo.lastSubmission?.locale, 'en');
  });

  test('submitCorrection stores issue details', () async {
    final repo = FakeSubmissionsRepository(
      submitResult: SubmissionResult.savedLocally,
    );
    final container = ProviderContainer(
      overrides: [submissionsRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(submissionProvider.notifier);
    final result = await notifier.submitCorrection(
      existingCardId: 'card-1',
      existingCardPrompt: 'Name 10 countries in Africa',
      issueType: IssueType.wrongAnswer,
      issueDescription: 'One of the answers listed is not in Africa.',
      submitterEmail: 'test@example.com',
      appVersion: '2.0.0+1',
      locale: 'es',
    );

    expect(result, SubmissionResult.savedLocally);
    expect(repo.lastSubmission?.existingCardId, 'card-1');
    expect(repo.lastSubmission?.issueType, IssueType.wrongAnswer);
    expect(repo.lastSubmission?.submitterEmail, 'test@example.com');
    expect(repo.lastSubmission?.appVersion, '2.0.0+1');
    expect(repo.lastSubmission?.locale, 'es');
  });
}
