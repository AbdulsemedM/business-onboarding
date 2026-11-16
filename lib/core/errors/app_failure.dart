import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

/// Errors the UI knows how to show. User-facing text lives in the ARB files,
/// not here.
@freezed
sealed class AppFailure with _$AppFailure implements Exception {
  const factory AppFailure.network() = NetworkFailure;
  const factory AppFailure.timeout() = TimeoutFailure;
  const factory AppFailure.unauthorized() = UnauthorizedFailure;

  /// The server rejected the input. [messages] are readable explanations
  /// from the server when it gives them (e.g. what is still missing before
  /// submit); field-level `validationErrors` are not shown as-is because
  /// they are technical.
  const factory AppFailure.validation({
    @Default(<String>[]) List<String> messages,
  }) = ValidationFailure;
  const factory AppFailure.server({int? statusCode}) = ServerFailure;
  const factory AppFailure.unknown() = UnknownFailure;
}
