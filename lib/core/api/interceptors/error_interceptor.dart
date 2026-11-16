import 'package:dio/dio.dart';

import '../../errors/app_failure.dart';
import '../../utils/safe_log.dart';

/// Converts Dio errors into an [AppFailure], stored in [DioException.error].
/// Repositories read it with [failureFrom].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err.copyWith(error: mapDioException(err)));
  }
}

AppFailure mapDioException(DioException err) {
  switch (err.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return const AppFailure.timeout();
    case DioExceptionType.connectionError:
      return const AppFailure.network();
    case DioExceptionType.badResponse:
      final status = err.response?.statusCode;
      if (status == 401 || status == 403) {
        return const AppFailure.unauthorized();
      }
      if (status == 400 || status == 409 || status == 422) {
        return AppFailure.validation(messages: _readableReasons(err.response));
      }
      return AppFailure.server(statusCode: status);
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return const AppFailure.unknown();
  }
}

/// Reasons from the error body that are safe and useful to show:
/// `validationErrors` as "field: reason", or the message of a business-rule
/// error. `BAD_REQUEST` messages describe Java internals and are skipped.
List<String> _readableReasons(Response<dynamic>? response) {
  final body = response?.data;
  if (body is! Map<String, dynamic>) return const [];
  final fields = body['validationErrors'];
  if (fields is Map && fields.isNotEmpty) {
    // Field names only, never values: they can be personal data.
    safeLog('Validation errors on: ${fields.keys.join(', ')}');
    return [
      for (final entry in fields.entries)
        '${_fieldLabel('${entry.key}')}: ${entry.value}',
    ];
  }
  final code = body['errorCode'];
  final message = body['message'];
  if (code == 'BAD_REQUEST' || code == 'VALIDATION_ERROR') return const [];
  return message is String && message.isNotEmpty ? [message] : const [];
}

/// "businessLocationAddress.city" -> "Business location address city".
String _fieldLabel(String path) {
  final words = path
      .replaceAll(RegExp(r'\[\d+\]'), '')
      .split('.')
      .expand((part) => part.split(RegExp(r'(?=[A-Z])')))
      .where((w) => w.isNotEmpty)
      .map((w) => w.toLowerCase())
      .join(' ');
  return words.isEmpty ? path : words[0].toUpperCase() + words.substring(1);
}

/// Gets the [AppFailure] from any error thrown by the API client.
AppFailure failureFrom(Object error) {
  if (error is AppFailure) return error;
  if (error is DioException) {
    final mapped = error.error;
    return mapped is AppFailure ? mapped : mapDioException(error);
  }
  return const AppFailure.unknown();
}
