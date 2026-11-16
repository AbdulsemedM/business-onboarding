/// App-wide configuration.
///
/// The API base URL can be overridden at build time:
/// `flutter run --dart-define=API_BASE_URL=https://...`
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  static const _unset = 'https://api.fastpay.invalid';

  /// Test: `https://gateway.fastpayet.com/bo`. Prod: TBD.
  static const AppConfig current = AppConfig(
    apiBaseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: _unset),
  );

  final String apiBaseUrl;

  /// Without an API_BASE_URL the app runs on mock repositories, so the UI
  /// can be worked on offline.
  bool get usesRealApi => apiBaseUrl != _unset;
}
