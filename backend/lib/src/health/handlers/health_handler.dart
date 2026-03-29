import 'package:atlas_ai_backend/src/ai/config/ai_provider_registry.dart';
import 'package:atlas_ai_backend/src/common/context/request_context.dart';
import 'package:atlas_ai_backend/src/common/http/json_response.dart';
import 'package:shelf/shelf.dart';

class HealthHandler {
  HealthHandler({
    required AiProviderRegistry providerRegistry,
    required String apiVersion,
  }) : _providerRegistry = providerRegistry,
       _apiVersion = apiVersion,
       _startedAt = DateTime.now().toUtc();

  final AiProviderRegistry _providerRegistry;
  final String _apiVersion;
  final DateTime _startedAt;

  Response healthz(Request request) {
    return jsonSuccess(
      data: {
        'status': 'ok',
        'uptimeSeconds': DateTime.now()
            .toUtc()
            .difference(_startedAt)
            .inSeconds,
      },
      encode: (value) => value,
      requestId: request.requestId,
      apiVersion: _apiVersion,
    );
  }

  Response publicConfig(Request request) {
    final publicConfig = _providerRegistry.toPublicConfig();
    return jsonSuccess(
      data: publicConfig,
      encode: (value) => value.toJson(),
      requestId: request.requestId,
      apiVersion: _apiVersion,
    );
  }
}
