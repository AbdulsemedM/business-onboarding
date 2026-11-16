import 'env.dart';

/// App-wide configuration.
///
/// The API base URL comes from `.env` (see `.env.example`) and is compiled in
/// by `dart run build_runner build`. A `--dart-define=API_BASE_URL=...`
/// overrides it.
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  static const _unset = 'https://api.fastpay.invalid';
  static const _override = String.fromEnvironment('API_BASE_URL');

  /// Test: `https://gateway.fastpayet.com/bo`. Prod: TBD.
  static final AppConfig current = AppConfig(
    apiBaseUrl: _override.isNotEmpty
        ? _override
        : (Env.apiBaseUrl?.isNotEmpty ?? false)
        ? Env.apiBaseUrl!
        : _unset,
  );

  final String apiBaseUrl;

  /// Without an API base URL the app runs on mock repositories, so the UI
  /// can be worked on offline.
  bool get usesRealApi => apiBaseUrl != _unset;
}
