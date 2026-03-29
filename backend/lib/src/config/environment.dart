import 'dart:io';

import 'package:shared_contracts/shared_contracts.dart';

class Environment {
  const Environment({
    required this.appEnvironment,
    required this.host,
    required this.port,
    required this.apiVersion,
    required this.corsAllowedOrigins,
    required this.enableVerboseLogs,
    required this.enableGenkitDebug,
    required this.aiStepTimeoutSeconds,
    required this.bootstrapUserId,
    required this.bootstrapDisplayName,
    required this.bootstrapAdminEmail,
    required this.bootstrapAdminPassword,
    required this.bootstrapRoles,
    required this.jwtSecret,
    required this.jwtRefreshSecret,
    required this.jwtIssuer,
    required this.jwtAudience,
    required this.defaultProvider,
    required this.googleApiKey,
    required this.googleModel,
    required this.openAiApiKey,
    required this.openAiBaseUrl,
    required this.openAiModel,
    required this.anthropicApiKey,
    required this.anthropicModel,
  });

  final String appEnvironment;
  final String host;
  final int port;
  final String apiVersion;
  final List<String> corsAllowedOrigins;
  final bool enableVerboseLogs;
  final bool enableGenkitDebug;
  final int aiStepTimeoutSeconds;
  final String bootstrapUserId;
  final String bootstrapDisplayName;
  final String bootstrapAdminEmail;
  final String bootstrapAdminPassword;
  final List<String> bootstrapRoles;
  final String jwtSecret;
  final String jwtRefreshSecret;
  final String jwtIssuer;
  final String jwtAudience;
  final AiProviderOption defaultProvider;
  final String? googleApiKey;
  final String googleModel;
  final String? openAiApiKey;
  final String? openAiBaseUrl;
  final String openAiModel;
  final String? anthropicApiKey;
  final String anthropicModel;

  static Future<Environment> load({String envFilePath = '.env'}) async {
    final fileValues = await _readEnvFile(envFilePath);
    final values = <String, String>{...fileValues, ...Platform.environment};

    return Environment(
      appEnvironment: values['APP_ENV'] ?? 'development',
      host: values['SERVER_HOST'] ?? '0.0.0.0',
      port: int.tryParse(values['SERVER_PORT'] ?? '') ?? 8080,
      apiVersion: values['API_VERSION'] ?? 'v1',
      corsAllowedOrigins: (values['CORS_ALLOWED_ORIGINS'] ?? '*')
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      enableVerboseLogs: _parseBool(
        values['ENABLE_VERBOSE_LOGS'],
        defaultValue: true,
      ),
      enableGenkitDebug: _parseBool(
        values['ENABLE_GENKIT_DEBUG'],
        defaultValue: true,
      ),
      aiStepTimeoutSeconds:
          int.tryParse(values['AI_STEP_TIMEOUT_SECONDS'] ?? '') ?? 20,
      bootstrapUserId: values['BOOTSTRAP_USER_ID'] ?? 'bootstrap-admin',
      bootstrapDisplayName:
          values['BOOTSTRAP_DISPLAY_NAME'] ?? 'Atlas Administrator',
      bootstrapAdminEmail: _require(values, 'BOOTSTRAP_ADMIN_EMAIL'),
      bootstrapAdminPassword: _require(values, 'BOOTSTRAP_ADMIN_PASSWORD'),
      bootstrapRoles: (values['BOOTSTRAP_ROLES'] ?? 'admin')
          .split(',')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false),
      jwtSecret: _require(values, 'JWT_SECRET'),
      jwtRefreshSecret: _require(values, 'JWT_REFRESH_SECRET'),
      jwtIssuer: values['JWT_ISSUER'] ?? 'atlas-ai-backend',
      jwtAudience: values['JWT_AUDIENCE'] ?? 'atlas-ai-clients',
      defaultProvider:
          AiProviderOption.tryParse(values['DEFAULT_AI_PROVIDER']) ??
          AiProviderOption.google,
      googleApiKey: _optional(values['GEMINI_API_KEY']),
      googleModel: values['GEMINI_MODEL'] ?? 'gemini-2.5-flash',
      openAiApiKey: _optional(values['OPENAI_API_KEY']),
      openAiBaseUrl: _optional(values['OPENAI_BASE_URL']),
      openAiModel: values['OPENAI_MODEL'] ?? 'gpt-4o-mini',
      anthropicApiKey: _optional(values['ANTHROPIC_API_KEY']),
      anthropicModel: values['ANTHROPIC_MODEL'] ?? 'claude-sonnet-4-5',
    );
  }

  static String _require(Map<String, String> values, String key) {
    final value = values[key];
    if (value == null || value.trim().isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value.trim();
  }

  static bool _parseBool(String? value, {required bool defaultValue}) {
    if (value == null) {
      return defaultValue;
    }

    return switch (value.trim().toLowerCase()) {
      '1' || 'true' || 'yes' || 'y' || 'on' => true,
      '0' || 'false' || 'no' || 'n' || 'off' => false,
      _ => defaultValue,
    };
  }

  static String? _optional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }

  static Future<Map<String, String>> _readEnvFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      return const {};
    }

    final lines = await file.readAsLines();
    final output = <String, String>{};

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) {
        continue;
      }

      final separatorIndex = trimmed.indexOf('=');
      if (separatorIndex <= 0) {
        continue;
      }

      final key = trimmed.substring(0, separatorIndex).trim();
      final value = trimmed.substring(separatorIndex + 1).trim();
      output[key] = value;
    }

    return output;
  }
}
