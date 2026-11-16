import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/interceptors/error_interceptor.dart';
import '../../../core/storage/session_store.dart';

/// What the merchant enters to create an account (backend
/// `POST /api/v1/auth/partner/register`). Personal data: never log it.
class RegistrationForm {
  const RegistrationForm({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.businessName,
  });

  final String firstName;
  final String lastName;
  final String email;

  /// E.164, e.g. +15551234567.
  final String phoneNumber;
  final String password;

  /// Sent as `organizationName`.
  final String businessName;
}

/// After signing in, whether the account still needs an application.
enum SignInResult { ready, needsApplication }

/// Sign-in, registration, and the session. Errors are thrown as
/// [AppFailure].
abstract interface class AuthRepository {
  /// True if a session is saved on the device.
  Future<bool> hasSession();

  /// Also true if the saved session has no application yet.
  Future<bool> needsApplication();

  /// The signed-in application's id, or null.
  Future<String?> applicationId();

  Future<SignInResult> login({required String email, required String password});

  /// Creates the account (and its application), then signs in.
  Future<SignInResult> register(RegistrationForm form);

  /// For an account with no application yet.
  Future<void> createApplication(String businessName);

  Future<void> logout();

  /// Fires when the session expired and couldn't be refreshed.
  Stream<void> get sessionExpired;
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    required Dio dio,
    required SessionStore sessionStore,
    required this.sessionExpired,
  }) : _dio = dio,
       _session = sessionStore;

  final Dio _dio;
  final SessionStore _session;

  @override
  final Stream<void> sessionExpired;

  @override
  Future<bool> hasSession() async => await _session.read() != null;

  @override
  Future<bool> needsApplication() async =>
      (await _session.read())?.applicationId == null;

  @override
  Future<String?> applicationId() async =>
      (await _session.read())?.applicationId;

  @override
  Future<SignInResult> login({
    required String email,
    required String password,
  }) => _guard(() async {
    final response = await _dio.post<dynamic>(
      '/api/v1/auth/login',
      data: {'loginIdentifier': email.trim(), 'password': password},
    );
    final data = dataOf(response);
    await _session.writeTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    return _pickApplication();
  });

  @override
  Future<SignInResult> register(RegistrationForm form) => _guard(() async {
    final response = await _dio.post<dynamic>(
      '/api/v1/auth/partner/register',
      data: {
        'firstName': form.firstName,
        'lastName': form.lastName,
        'email': form.email.trim(),
        'phoneNumber': form.phoneNumber,
        'password': form.password,
        'confirmPassword': form.password,
        'organizationName': form.businessName,
      },
    );
    final applicationId = dataOf(response)['applicationId'] as String?;
    final result = await login(email: form.email, password: form.password);
    if (applicationId != null) {
      await _session.writeApplicationId(applicationId);
      return SignInResult.ready;
    }
    return result;
  });

  @override
  Future<void> createApplication(String businessName) => _guard(() async {
    final response = await _dio.post<dynamic>(
      '/api/v1/partner/applications',
      data: {'businessName': businessName.trim()},
    );
    await _session.writeApplicationId(dataOf(response)['id'] as String);
  });

  @override
  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('/api/v1/auth/logout');
    } catch (_) {
      // Signing out locally matters more than telling the server.
    }
    await _session.clear();
  }

  /// Uses the account's most recent application, if any.
  // TODO(product): let the merchant choose when they have several.
  Future<SignInResult> _pickApplication() async {
    final response = await _dio.get<dynamic>(
      '/api/v1/partner/applications',
      queryParameters: {'page': 0, 'size': 50},
    );
    final items = (dataOf(response)['items'] as List?) ?? const [];
    final apps = items.whereType<Map<String, dynamic>>().toList()
      ..sort(
        (a, b) =>
            '${b['createdAt'] ?? ''}'.compareTo('${a['createdAt'] ?? ''}'),
      );
    if (apps.isEmpty) return SignInResult.needsApplication;
    await _session.writeApplicationId(apps.first['id'] as String);
    return SignInResult.ready;
  }

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw failureFrom(error);
    }
  }
}

/// Always signed in, with an application. Used with the mock API.
class MockAuthRepository implements AuthRepository {
  bool _signedIn = true;

  @override
  Future<bool> hasSession() async => _signedIn;

  @override
  Future<bool> needsApplication() async => false;

  @override
  Future<String?> applicationId() async => mockApplicationId;

  static const mockApplicationId = 'mock-application';

  @override
  Future<SignInResult> login({
    required String email,
    required String password,
  }) async {
    _signedIn = true;
    return SignInResult.ready;
  }

  @override
  Future<SignInResult> register(RegistrationForm form) async {
    _signedIn = true;
    return SignInResult.ready;
  }

  @override
  Future<void> createApplication(String businessName) async {}

  @override
  Future<void> logout() async => _signedIn = false;

  @override
  Stream<void> get sessionExpired => const Stream.empty();
}
