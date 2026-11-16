import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/utils/safe_log.dart';
import '../../auth/data/auth_repository.dart';
import '../data/application_summary.dart';

class ApplicationsState {
  const ApplicationsState({
    this.loading = true,
    this.items = const [],
    this.failure,
  });

  final bool loading;
  final List<ApplicationSummary> items;

  /// Why the last load failed. Items from an earlier load stay shown.
  final AppFailure? failure;
}

/// Loads the account's applications for the "My applications" screen.
class ApplicationsCubit extends Cubit<ApplicationsState> {
  ApplicationsCubit({
    required AuthRepository repository,
    required this.onLoaded,
  }) : _repository = repository,
       super(const ApplicationsState());

  final AuthRepository _repository;

  /// Gets the ids of every application on the account after each load,
  /// e.g. to drop drafts that belong to someone else.
  final Future<void> Function(Set<String> applicationIds) onLoaded;

  Future<void> load() async {
    emit(ApplicationsState(items: state.items));
    try {
      final items = await _repository.listApplications();
      emit(ApplicationsState(loading: false, items: items));
      await onLoaded({for (final app in items) app.id});
    } on AppFailure catch (failure) {
      safeLog('Applications load failed: ${failure.runtimeType}');
      emit(
        ApplicationsState(loading: false, items: state.items, failure: failure),
      );
    } catch (_) {
      safeLog('Applications load failed');
      emit(
        ApplicationsState(
          loading: false,
          items: state.items,
          failure: const AppFailure.unknown(),
        ),
      );
    }
  }
}
