import 'package:shared_contracts/src/ai/ai_provider_option.dart';

class BackendPublicConfig {
  const BackendPublicConfig({
    required this.environment,
    required this.supportedProviders,
    required this.defaultProvider,
    required this.authMode,
    required this.debugAiTracesEnabled,
  });

  final String environment;
  final List<AiProviderOption> supportedProviders;
  final AiProviderOption defaultProvider;
  final String authMode;
  final bool debugAiTracesEnabled;

  factory BackendPublicConfig.fromJson(Map<String, dynamic> json) {
    return BackendPublicConfig(
      environment: json['environment'] as String? ?? 'unknown',
      supportedProviders:
          (json['supportedProviders'] as List<dynamic>? ?? const [])
              .map((item) => AiProviderOption.tryParse(item as String))
              .whereType<AiProviderOption>()
              .toList(growable: false),
      defaultProvider:
          AiProviderOption.tryParse(json['defaultProvider'] as String?) ??
          AiProviderOption.google,
      authMode: json['authMode'] as String? ?? 'jwt',
      debugAiTracesEnabled: json['debugAiTracesEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environment': environment,
      'supportedProviders': supportedProviders
          .map((item) => item.wireValue)
          .toList(),
      'defaultProvider': defaultProvider.wireValue,
      'authMode': authMode,
      'debugAiTracesEnabled': debugAiTracesEnabled,
    };
  }
}
