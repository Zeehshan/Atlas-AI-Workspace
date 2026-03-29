import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:atlas_ai_backend/src/common/logging/app_logger.dart';
import 'package:atlas_ai_backend/src/config/environment.dart';
import 'package:genkit/genkit.dart';
// ignore: implementation_imports
import 'package:genkit/src/core/plugin.dart' show GenkitPlugin;
import 'package:genkit_anthropic/genkit_anthropic.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:shared_contracts/shared_contracts.dart';

class ResolvedModel {
  const ResolvedModel({
    required this.provider,
    required this.modelName,
    required this.model,
  });

  final AiProviderOption provider;
  final String modelName;
  final dynamic model;
}

class AiProviderRegistry {
  AiProviderRegistry({
    required Environment environment,
    required AppLogger logger,
  }) : _environment = environment,
       ai = Genkit(plugins: _buildPlugins(environment, logger));

  final Environment _environment;
  final Genkit ai;

  List<AiProviderOption> get supportedProviders {
    return [
      if (_environment.googleApiKey case final _) AiProviderOption.google,
      if (_environment.anthropicApiKey case final _) AiProviderOption.anthropic,
    ];
  }

  ResolvedModel resolve(AiProviderOption? preferredProvider) {
    final supported = supportedProviders;
    if (supported.isEmpty) {
      throw ApiException.serviceUnavailable(
        'No AI providers are configured on the backend.',
      );
    }

    final selectedProvider = supported.contains(preferredProvider)
        ? preferredProvider!
        : supported.contains(_environment.defaultProvider)
        ? _environment.defaultProvider
        : supported.first;

    return switch (selectedProvider) {
      AiProviderOption.google => ResolvedModel(
        provider: AiProviderOption.google,
        modelName: _environment.googleModel,
        model: googleAI.gemini(_environment.googleModel),
      ),
      AiProviderOption.anthropic => ResolvedModel(
        provider: AiProviderOption.anthropic,
        modelName: _environment.anthropicModel,
        model: anthropic.model(_environment.anthropicModel),
      ),
      AiProviderOption.openai => throw ApiException.serviceUnavailable(
        'OpenAI-compatible runtime support is not enabled in this backend build.',
      ),
    };
  }

  BackendPublicConfig toPublicConfig() {
    final supported = supportedProviders;
    return BackendPublicConfig(
      environment: _environment.appEnvironment,
      supportedProviders: supported,
      defaultProvider: supported.contains(_environment.defaultProvider)
          ? _environment.defaultProvider
          : supported.isNotEmpty
          ? supported.first
          : _environment.defaultProvider,
      authMode: 'jwt',
      debugAiTracesEnabled: _environment.enableGenkitDebug,
    );
  }

  static List<GenkitPlugin> _buildPlugins(
    Environment environment,
    AppLogger logger,
  ) {
    final plugins = <GenkitPlugin>[];

    if (environment.googleApiKey case final apiKey?) {
      plugins.add(googleAI(apiKey: apiKey));
    }

    if (environment.anthropicApiKey case final apiKey?) {
      plugins.add(anthropic(apiKey: apiKey));
    }

    logger.info(
      'Configured Genkit providers',
      fields: {
        'providers': [
          if (environment.googleApiKey case final _) 'google',
          if (environment.anthropicApiKey case final _) 'anthropic',
        ],
      },
    );

    return plugins;
  }
}
