import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/utils/safe_log.dart';
import '../../data/application_repository.dart';
import '../../data/models/application_status.dart';

part 'status_cubit.freezed.dart';

@freezed
sealed class StatusState with _$StatusState {
  const factory StatusState.loading() = StatusLoading;

  /// [reuploaded] holds the ids of document corrections the user has
  /// uploaded a new file for. [isResubmitting] / [resubmitFailure] track the
  /// resubmit button.
  const factory StatusState.loaded({
    required ApplicationSnapshot snapshot,
    @Default(<String>{}) Set<String> reuploaded,
    @Default(false) bool isResubmitting,
    AppFailure? resubmitFailure,
  }) = StatusLoaded;

  const factory StatusState.failed(AppFailure failure) = StatusFailed;
}

extension StatusLoadedX on StatusLoaded {
  List<CorrectionItem> get documentCorrections => [
    for (final c in snapshot.corrections)
      if (c.isDocument) c,
  ];

  List<CorrectionItem> get fieldCorrections => [
    for (final c in snapshot.corrections)
      if (!c.isDocument) c,
  ];

  /// Every rejected document has a new file. Field corrections are fixed in
  /// the wizard and resubmitted from Review.
  bool get canResubmit =>
      fieldCorrections.isEmpty &&
      documentCorrections.isNotEmpty &&
      documentCorrections.every((c) => reuploaded.contains(c.id));
}

/// Loads the application status and resubmits after rejected documents
/// were uploaded again.
class StatusCubit extends Cubit<StatusState> {
  StatusCubit({required ApplicationRepository repository, this.initial})
    : _repository = repository,
      super(
        initial == null
            ? const StatusState.loading()
            : StatusState.loaded(snapshot: initial),
      );

  final ApplicationRepository _repository;

  /// Shown straight away when coming from a submit, so there is no reload.
  final ApplicationSnapshot? initial;

  Future<void> load() async {
    emit(const StatusState.loading());
    try {
      emit(StatusState.loaded(snapshot: await _repository.fetch()));
    } on AppFailure catch (failure) {
      safeLog('Status load failed');
      emit(StatusState.failed(failure));
    } catch (_) {
      safeLog('Status load failed');
      emit(const StatusState.failed(AppFailure.unknown()));
    }
  }

  /// A new file was uploaded (or removed) for a rejected document.
  void markReuploaded(String correctionId, {required bool uploaded}) {
    final current = state;
    if (current is! StatusLoaded) return;
    final ids = {...current.reuploaded};
    uploaded ? ids.add(correctionId) : ids.remove(correctionId);
    emit(current.copyWith(reuploaded: ids, resubmitFailure: null));
  }

  Future<void> resubmit() async {
    final current = state;
    if (current is! StatusLoaded || current.isResubmitting) return;
    if (!current.canResubmit) return;
    emit(current.copyWith(isResubmitting: true, resubmitFailure: null));
    try {
      final snapshot = await _repository.resubmit([
        for (final c in current.snapshot.corrections) c.id,
      ]);
      emit(StatusState.loaded(snapshot: snapshot));
    } on AppFailure catch (failure) {
      safeLog('Resubmit failed');
      emit(current.copyWith(isResubmitting: false, resubmitFailure: failure));
    } catch (_) {
      safeLog('Resubmit failed');
      emit(
        current.copyWith(
          isResubmitting: false,
          resubmitFailure: const AppFailure.unknown(),
        ),
      );
    }
  }
}
