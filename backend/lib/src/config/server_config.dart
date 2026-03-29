import 'package:atlas_ai_backend/src/config/environment.dart';
import 'package:shared_contracts/shared_contracts.dart';

class ServerConfig {
  const ServerConfig({
    required this.host,
    required this.port,
    required this.apiVersion,
    required this.corsAllowedOrigins,
    required this.enableVerboseLogs,
    required this.enableGenkitDebug,
    required this.appEnvironment,
    required this.defaultProvider,
  });

  final String host;
  final int port;
  final String apiVersion;
  final List<String> corsAllowedOrigins;
  final bool enableVerboseLogs;
  final bool enableGenkitDebug;
  final String appEnvironment;
  final AiProviderOption defaultProvider;

  factory ServerConfig.fromEnvironment(Environment environment) {
    return ServerConfig(
      host: environment.host,
      port: environment.port,
      apiVersion: environment.apiVersion,
      corsAllowedOrigins: environment.corsAllowedOrigins,
      enableVerboseLogs: environment.enableVerboseLogs,
      enableGenkitDebug: environment.enableGenkitDebug,
      appEnvironment: environment.appEnvironment,
      defaultProvider: environment.defaultProvider,
    );
  }
}
