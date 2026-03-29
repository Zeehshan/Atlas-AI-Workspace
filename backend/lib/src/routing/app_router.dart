import 'package:atlas_ai_backend/src/ai/handlers/ai_handler.dart';
import 'package:atlas_ai_backend/src/auth/handlers/auth_handler.dart';
import 'package:atlas_ai_backend/src/auth/services/token_service.dart';
import 'package:atlas_ai_backend/src/common/http/middleware/bearer_auth_middleware.dart';
import 'package:atlas_ai_backend/src/health/handlers/health_handler.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRouter {
  const AppRouter({
    required AuthHandler authHandler,
    required AiHandler aiHandler,
    required HealthHandler healthHandler,
    required TokenService tokenService,
  }) : _authHandler = authHandler,
       _aiHandler = aiHandler,
       _healthHandler = healthHandler,
       _tokenService = tokenService;

  final AuthHandler _authHandler;
  final AiHandler _aiHandler;
  final HealthHandler _healthHandler;
  final TokenService _tokenService;

  Handler get handler {
    final router = Router()
      ..get('/healthz', _healthHandler.healthz)
      ..get('/v1/config', _healthHandler.publicConfig)
      ..post('/v1/auth/login', _authHandler.login)
      ..post('/v1/auth/refresh', _authHandler.refresh)
      ..post(
        '/v1/ai/workspace-plans',
        Pipeline()
            .addMiddleware(bearerAuthMiddleware(_tokenService))
            .addHandler(_aiHandler.generateWorkspacePlan),
      );

    return router.call;
  }
}
