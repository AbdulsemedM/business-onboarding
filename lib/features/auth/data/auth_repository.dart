import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/interceptors/error_interceptor.dart';
import '../../../core/storage/session_store.dart';
import '../../applications/data/application_summary.dart';
import '../../onboarding/data/models/application_status.dart';

/// What the agent enters to create an account (backend
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

/// After signing in: an application is open ([ready]), or the agent picks
/// one from their list first ([needsApplication]).
enum SignInResult { ready, needsApplication }

/// Sign-in, registration, and the session. Errors are thrown as
/// [AppFailure].
abstract interface class AuthRepository {
  /// True if a session is saved on the device.
  Future<bool> hasSession();

  /// The open application's id, or null when none is open.
  Future<String?> applicationId();

  /// Signs in. No application is open afterwards: the agent picks one from
  /// their list.
  Future<SignInResult> login({required String email, required String password});

  /// Creates the account (and its first application), then signs in with
  /// that application open.
  Future<SignInResult> register(RegistrationForm form);

  /// Every application on the account, newest first.
  Future<List<ApplicationSummary>> listApplications();

  /// Opens one of the account's applications.
  Future<void> selectApplication(String applicationId);

  /// Starts a new application (business names are unique per account) and
  /// opens it.
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
    await _session.clearApplicationId();
    return SignInResult.needsApplication;
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

  @override
  Future<List<ApplicationSummary>> listApplications() => _guard(() async {
    final apps = <ApplicationSummary>[];
    for (var page = 0; ; page++) {
      final response = await _dio.get<dynamic>(
        '/api/v1/partner/applications',
        queryParameters: {'page': page, 'size': 50},
      );
      final data = dataOf(response);
      final items = (data['items'] as List?) ?? const [];
      apps.addAll(
        items.whereType<Map<String, dynamic>>().map(
          ApplicationSummary.fromJson,
        ),
      );
      final pagination = data['pagination'];
      if (pagination is! Map || pagination['hasNext'] != true) break;
    }
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    return apps
      ..sort((a, b) => (b.createdAt ?? epoch).compareTo(a.createdAt ?? epoch));
  });

  @override
  Future<void> selectApplication(String applicationId) =>
      _session.writeApplicationId(applicationId);

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (error) {
      throw failureFrom(error);
    }
  }
}

/// Always signed in, with one application open. Used with the mock API.
/// New applications are kept in memory.
class MockAuthRepository implements AuthRepository {
  bool _signedIn = true;
  String? _open = mockApplicationId;
  final _apps = [
    const ApplicationSummary(
      id: mockApplicationId,
      businessName: 'My business',
      status: ApplicationStatus.draft,
    ),
  ];

  static const mockApplicationId = 'mock-application';

  @override
  Future<bool> hasSession() async => _signedIn;

  @override
  Future<String?> applicationId() async => _open;

  @override
  Future<SignInResult> login({
    required String email,
    required String password,
  }) async {
    _signedIn = true;
    _open = null;
    return SignInResult.needsApplication;
  }

  @override
  Future<SignInResult> register(RegistrationForm form) async {
    _signedIn = true;
    await createApplication(form.businessName);
    return SignInResult.ready;
  }

  @override
  Future<List<ApplicationSummary>> listApplications() async =>
      List.unmodifiable(_apps.reversed);

  @override
  Future<void> selectApplication(String applicationId) async =>
      _open = applicationId;

  @override
  Future<void> createApplication(String businessName) async {
    final id = 'mock-application-${_apps.length + 1}';
    _apps.add(
      ApplicationSummary(
        id: id,
        businessName: businessName.trim(),
        status: ApplicationStatus.draft,
      ),
    );
    _open = id;
  }

  @override
  Future<void> logout() async {
    _signedIn = false;
    _open = null;
  }

  @override
  Stream<void> get sessionExpired => const Stream.empty();
}
