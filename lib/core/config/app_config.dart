/// App-wide configuration.
///
/// The API base URL can be overridden at build time:
/// `flutter run --dart-define=API_BASE_URL=https://...`
class AppConfig {
  const AppConfig({required this.apiBaseUrl});

  // TODO(backend): set the real default once the backend contract is filled in.
  static const AppConfig current = AppConfig(
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.fastpay.invalid',
    ),
  );

  final String apiBaseUrl;
}
