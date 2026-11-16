import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/session_store.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Builds the shared [Dio] instance. Only HTTPS base URLs are allowed.
///
/// No logging interceptor is added on purpose: requests contain personal data.
Dio createApiClient({
  required AppConfig config,
  required SessionStore sessionStore,
  required void Function() onSessionExpired,
}) {
  final uri = Uri.parse(config.apiBaseUrl);
  if (uri.scheme != 'https') {
    throw ArgumentError.value(
      config.apiBaseUrl,
      'apiBaseUrl',
      'must use https',
    );
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(
      sessionStore: sessionStore,
      dio: dio,
      onSessionExpired: onSessionExpired,
    ),
    ErrorInterceptor(),
  ]);
  return dio;
}

/// Client for pre-signed storage URLs: no base URL, no auth header (the
/// URL itself is the credential), and long timeouts for large files.
Dio createUploadClient() => Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(minutes: 3),
    receiveTimeout: const Duration(seconds: 60),
  ),
);

/// The `data` object of the backend's `{ status, message, data }` envelope.
Map<String, dynamic> dataOf(Response<dynamic> response) {
  final body = response.data;
  if (body is Map<String, dynamic>) {
    final data = body['data'];
    if (data is Map<String, dynamic>) return data;
  }
  return const {};
}
