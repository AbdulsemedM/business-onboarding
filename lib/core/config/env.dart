import 'package:envied/envied.dart';

part 'env.g.dart';

/// Values read from `.env` by build_runner (see `.env.example`).
///
/// The generated `env.g.dart` is git-ignored and obfuscated, so the values
/// are not committed and do not show up as plain text in the binary.
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  /// Unset means the app runs on mock repositories.
  @EnviedField(varName: 'API_BASE_URL', optional: true)
  static final String? apiBaseUrl = _Env.apiBaseUrl;
}
