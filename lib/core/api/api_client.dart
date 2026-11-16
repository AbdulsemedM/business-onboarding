import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_store.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Builds the shared [Dio] instance. Only HTTPS base URLs are allowed.
///
/// No logging interceptor is added on purpose: requests contain personal data.
Dio createApiClient({
  required AppConfig config,
  required TokenStore tokenStore,
}) {
  final uri = Uri.parse(config.apiBaseUrl);
  if (uri.scheme != 'https') {
    throw ArgumentError.value(
      config.apiBaseUrl,
      'apiBaseUrl',
      'must use https',
    );
  }

  return Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.addAll([AuthInterceptor(tokenStore), ErrorInterceptor()]);
}
