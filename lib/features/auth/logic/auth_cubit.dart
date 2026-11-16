import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/utils/safe_log.dart';
import '../data/auth_repository.dart';

part 'auth_cubit.freezed.dart';

enum AuthStatus {
  /// Still reading the saved session.
  unknown,
  signedOut,

  /// Signed in, but no application is open: the agent picks one from their
  /// list (or starts one).
  needsApplication,

  /// Signed in with an application open.
  signedIn,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.unknown) AuthStatus status,

    /// A sign-in, register or create-application call is running.
    @Default(false) bool busy,

    /// Why the last call failed.
    AppFailure? failure,

    /// Signed out because the session expired (not by the user).
    @Default(false) bool sessionExpired,

    /// The open application, when [status] is [AuthStatus.signedIn].
    String? applicationId,
  }) = _AuthState;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthRepository repository})
    : _repository = repository,
      super(const AuthState()) {
    _expired = repository.sessionExpired.listen((_) => _onExpired());
  }

  final AuthRepository _repository;
  late final StreamSubscription<void> _expired;

  Future<void> check() async {
    final signedIn = await _repository.hasSession();
    if (!signedIn) {
      emit(const AuthState(status: AuthStatus.signedOut));
      return;
    }
    emit(await _signedInState());
  }

  Future<void> login({required String email, required String password}) =>
      _run(() => _repository.login(email: email, password: password));

  Future<void> register(RegistrationForm form) =>
      _run(() => _repository.register(form));

  Future<void> createApplication(String businessName) => _run(() async {
    await _repository.createApplication(businessName);
    return SignInResult.ready;
  });

  /// Opens one of the account's applications.
  Future<void> selectApplication(String applicationId) async {
    await _repository.selectApplication(applicationId);
    emit(AuthState(status: AuthStatus.signedIn, applicationId: applicationId));
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState(status: AuthStatus.signedOut));
  }

  void clearFailure() => emit(state.copyWith(failure: null));

  Future<void> _run(Future<SignInResult> Function() call) async {
    if (state.busy) return;
    emit(state.copyWith(busy: true, failure: null, sessionExpired: false));
    try {
      await call();
      emit(await _signedInState());
    } on AppFailure catch (failure) {
      safeLog('Auth call failed: ${failure.runtimeType}');
      emit(state.copyWith(busy: false, failure: failure));
    } catch (_) {
      safeLog('Auth call failed');
      emit(state.copyWith(busy: false, failure: const AppFailure.unknown()));
    }
  }

  /// Signed in, with the open application if there is one.
  Future<AuthState> _signedInState() async {
    final applicationId = await _repository.applicationId();
    return applicationId == null
        ? const AuthState(status: AuthStatus.needsApplication)
        : AuthState(status: AuthStatus.signedIn, applicationId: applicationId);
  }

  void _onExpired() {
    if (state.status == AuthStatus.signedOut) return;
    emit(const AuthState(status: AuthStatus.signedOut, sessionExpired: true));
  }

  @override
  Future<void> close() async {
    await _expired.cancel();
    return super.close();
  }
}
