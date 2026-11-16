import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/safe_log.dart';
import '../../data/application_repository.dart';
import '../../data/models/application_status.dart';
import '../../data/models/onboarding_draft.dart';

part 'submit_cubit.freezed.dart';

@freezed
sealed class SubmitState with _$SubmitState {
  const factory SubmitState.idle() = SubmitIdle;
  const factory SubmitState.submitting() = SubmitInProgress;
  const factory SubmitState.succeeded(ApplicationSnapshot snapshot) =
      SubmitSucceeded;
  const factory SubmitState.failed(AppFailure failure) = SubmitFailed;
}

/// Sends the finished application from the Review step.
class SubmitCubit extends Cubit<SubmitState> {
  SubmitCubit({required ApplicationRepository repository})
    : _repository = repository,
      super(const SubmitState.idle());

  final ApplicationRepository _repository;

  Future<void> submit(OnboardingDraft draft) async {
    if (state is SubmitInProgress) return;
    emit(const SubmitState.submitting());
    try {
      emit(SubmitState.succeeded(await _repository.submit(draft)));
    } on AppFailure catch (failure) {
      safeLog('Submit failed');
      emit(SubmitState.failed(failure));
    } catch (_) {
      safeLog('Submit failed');
      emit(const SubmitState.failed(AppFailure.unknown()));
    }
  }
}
