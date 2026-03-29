import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.environment,
    required this.apiBaseUrl,
    required this.requestTimeoutSeconds,
    required this.enableVerboseLogs,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      appName: String.fromEnvironment(
        'APP_NAME',
        defaultValue: 'Atlas AI Workspace',
      ),
      environment: String.fromEnvironment(
        'APP_ENV',
        defaultValue: 'development',
      ),
      apiBaseUrl: String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080',
      ),
      requestTimeoutSeconds: int.fromEnvironment(
        'REQUEST_TIMEOUT_SECONDS',
        defaultValue: 30,
      ),
      enableVerboseLogs: bool.fromEnvironment(
        'ENABLE_VERBOSE_LOGS',
        defaultValue: true,
      ),
    );
  }

  final String appName;
  final String environment;
  final String apiBaseUrl;
  final int requestTimeoutSeconds;
  final bool enableVerboseLogs;

  bool get isProduction => environment == 'production';
}

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);
