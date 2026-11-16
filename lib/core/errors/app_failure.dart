import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

/// Errors the UI knows how to show. User-facing text lives in the ARB files,
/// not here.
@freezed
sealed class AppFailure with _$AppFailure implements Exception {
  const factory AppFailure.network() = NetworkFailure;
  const factory AppFailure.timeout() = TimeoutFailure;
  const factory AppFailure.unauthorized() = UnauthorizedFailure;

  // TODO(backend): parse field errors once the error response format is known.
  const factory AppFailure.validation() = ValidationFailure;
  const factory AppFailure.server({int? statusCode}) = ServerFailure;
  const factory AppFailure.unknown() = UnknownFailure;
}
