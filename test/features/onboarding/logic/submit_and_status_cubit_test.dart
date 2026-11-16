import 'package:bloc_test/bloc_test.dart';
import 'package:business_onboarding/core/errors/app_failure.dart';
import 'package:business_onboarding/features/onboarding/data/models/application_status.dart';
import 'package:business_onboarding/features/onboarding/data/models/onboarding_draft.dart';
import 'package:business_onboarding/features/onboarding/review/logic/submit_cubit.dart';
import 'package:business_onboarding/features/onboarding/status/logic/status_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/application_fakes.dart';

void main() {
  group('SubmitCubit', () {
    blocTest<SubmitCubit, SubmitState>(
      'emits submitting then the server snapshot',
      build: () =>
          SubmitCubit(repository: FakeApplicationRepository(actionRequired)),
      act: (cubit) => cubit.submit(const OnboardingDraft()),
      expect: () => [
        const SubmitState.submitting(),
        const SubmitState.succeeded(actionRequired),
      ],
    );

    blocTest<SubmitCubit, SubmitState>(
      'emits the failure so the UI can explain it',
      build: () => SubmitCubit(
        repository: FakeApplicationRepository(actionRequired)
          ..failure = const AppFailure.network(),
      ),
      act: (cubit) => cubit.submit(const OnboardingDraft()),
      expect: () => [
        const SubmitState.submitting(),
        const SubmitState.failed(AppFailure.network()),
      ],
    );
  });

  group('StatusCubit', () {
    blocTest<StatusCubit, StatusState>(
      'loads the status',
      build: () => StatusCubit(repository: FakeApplicationRepository(inReview)),
      act: (cubit) => cubit.load(),
      expect: () => [
        const StatusState.loading(),
        const StatusState.loaded(snapshot: inReview),
      ],
    );

    blocTest<StatusCubit, StatusState>(
      'shows a load failure',
      build: () => StatusCubit(
        repository: FakeApplicationRepository(inReview)
          ..failure = const AppFailure.server(),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const StatusState.loading(),
        const StatusState.failed(AppFailure.server()),
      ],
    );

    test('resubmit is only possible once every rejected document has a '
        'new file', () {
      final cubit = StatusCubit(
        repository: FakeApplicationRepository(actionRequired),
        initial: actionRequired,
      );
      StatusLoaded loaded() => cubit.state as StatusLoaded;

      expect(loaded().canResubmit, isFalse);
      cubit.markReuploaded(photoCorrection.id, uploaded: true);
      expect(loaded().canResubmit, isTrue);
      cubit.markReuploaded(photoCorrection.id, uploaded: false);
      expect(loaded().canResubmit, isFalse);
    });

    test('a field correction blocks resubmitting from the status screen', () {
      const withField = ApplicationSnapshot(
        status: ApplicationStatus.actionRequired,
        corrections: [
          photoCorrection,
          CorrectionItem(id: 'c-bank', label: 'Bank', reason: 'Full name'),
        ],
      );
      final cubit = StatusCubit(
        repository: FakeApplicationRepository(withField),
        initial: withField,
      )..markReuploaded(photoCorrection.id, uploaded: true);

      expect((cubit.state as StatusLoaded).canResubmit, isFalse);
    });

    blocTest<StatusCubit, StatusState>(
      'resubmits every open correction id',
      build: () => StatusCubit(
        repository: FakeApplicationRepository(actionRequired)
          ..afterResubmit = inReview,
        initial: actionRequired,
      ),
      act: (cubit) async {
        cubit.markReuploaded(photoCorrection.id, uploaded: true);
        await cubit.resubmit();
      },
      skip: 1,
      expect: () => [
        StatusState.loaded(
          snapshot: actionRequired,
          reuploaded: {photoCorrection.id},
          isResubmitting: true,
        ),
        const StatusState.loaded(snapshot: inReview),
      ],
    );

    blocTest<StatusCubit, StatusState>(
      'keeps the uploads and shows the error when resubmit fails',
      build: () => StatusCubit(
        repository: FakeApplicationRepository(actionRequired)
          ..failure = const AppFailure.timeout(),
        initial: actionRequired,
      ),
      act: (cubit) async {
        cubit.markReuploaded(photoCorrection.id, uploaded: true);
        await cubit.resubmit();
      },
      skip: 2,
      expect: () => [
        StatusState.loaded(
          snapshot: actionRequired,
          reuploaded: {photoCorrection.id},
          resubmitFailure: const AppFailure.timeout(),
        ),
      ],
    );
  });
}
