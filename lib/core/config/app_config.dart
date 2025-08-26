// lib/core/config/app_config.dart
class AppConfig {
  static const String _localServerUrl = "http://localhost:5000";
  
  static String get serverUrl {
    return const String.fromEnvironment(
      'SERVER_URL',
      defaultValue: _localServerUrl,
    );
  }
  
  static String get fileServiceUrl => "$serverUrl/uploads";
  static String get baseUrl => "$serverUrl/api";
  static String get notificationHubUrl => "$serverUrl/notificationHub";
}
