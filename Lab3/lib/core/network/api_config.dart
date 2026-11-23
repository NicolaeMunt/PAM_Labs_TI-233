/// Where the REST API lives.
class ApiConfig {
  ApiConfig._();

  /// Variant v2 of the lab API (the health appointment app).
  /// Can be changed at build time:
  /// `flutter run --dart-define=API_BASE_URL=https://.../lab2026/v2`
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://test-api-jlbn.onrender.com/lab2026/v2',
  );

  static const feedPath = '/feed';
  static const feedDetailsPath = '/feed/details';

  /// The free Render server can take ~30 s to wake up after being idle.
  static const timeout = Duration(seconds: 45);
}
