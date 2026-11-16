import 'package:dio/dio.dart';

import '../../errors/app_failure.dart';

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
      if (status == 400 || status == 422) {
        return const AppFailure.validation();
      }
      return AppFailure.server(statusCode: status);
    case DioExceptionType.badCertificate:
    case DioExceptionType.cancel:
    case DioExceptionType.unknown:
      return const AppFailure.unknown();
  }
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
