import 'package:dio/dio.dart';

import '../../storage/session_store.dart';
import '../../utils/safe_log.dart';

/// Adds the access token and the onboarding application header, and
/// refreshes the token once when a request comes back 401.
///
/// Queued, so parallel 401s trigger a single refresh.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required SessionStore sessionStore,
    required Dio dio,
    required this.onSessionExpired,
  }) : _session = sessionStore,
       _dio = dio;

  final SessionStore _session;

  /// The client this interceptor belongs to.
  final Dio _dio;

  /// Refresh and retry go through a plain client: going back through this
  /// queued interceptor while it waits would deadlock.
  Dio get _plain =>
      Dio(_dio.options)..httpClientAdapter = _dio.httpClientAdapter;

  /// Called when the session can't be refreshed. The user must sign in.
  final void Function() onSessionExpired;

  static const _retried = 'auth_retried';
  static final _applicationPath = RegExp(r'/partner/applications/([^/?]+)');

  static bool _isAuthCall(RequestOptions o) => o.path.contains('/auth/');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthCall(options)) {
      final session = await _session.read();
      if (session != null) {
        options.headers['Authorization'] = 'Bearer ${session.accessToken}';
      }
    }
    // Every application-scoped call must name the application in a header
    // too (backend rule), and it must match the one in the path.
    final match = _applicationPath.firstMatch(options.path);
    if (match != null) {
      options.headers['X-Onboarding-Application-Id'] = match.group(1);
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final unauthorized = err.response?.statusCode == 401;
    if (!unauthorized ||
        _isAuthCall(request) ||
        request.extra[_retried] == true) {
      handler.next(err);
      return;
    }

    final session = await _session.read();
    if (session == null) {
      onSessionExpired();
      handler.next(err);
      return;
    }

    final plain = _plain;
    try {
      final refreshed = await plain.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refreshToken': session.refreshToken},
      );
      final data = refreshed.data?['data'] as Map<String, dynamic>?;
      final access = data?['accessToken'] as String?;
      if (access == null) throw StateError('No access token');
      await _session.writeTokens(
        accessToken: access,
        refreshToken: data?['refreshToken'] as String? ?? session.refreshToken,
      );
      request.extra[_retried] = true;
      request.headers['Authorization'] = 'Bearer $access';
      handler.resolve(await plain.fetch<dynamic>(request));
    } on DioException catch (retryError) {
      final refreshFailed = retryError.requestOptions.path.contains(
        '/auth/refresh',
      );
      if (!refreshFailed) {
        // Refreshed fine, but the retry itself failed: report that error.
        handler.next(retryError);
        return;
      }
      safeLog('Session refresh failed');
      await _session.clear();
      onSessionExpired();
      handler.next(err);
    } catch (_) {
      safeLog('Session refresh failed');
      await _session.clear();
      onSessionExpired();
      handler.next(err);
    }
  }
}
