import 'dart:io';

import 'package:atlas_ai_backend/src/ai/config/ai_provider_registry.dart';
import 'package:atlas_ai_backend/src/ai/flows/workspace_plan_flow.dart';
import 'package:atlas_ai_backend/src/ai/handlers/ai_handler.dart';
import 'package:atlas_ai_backend/src/ai/prompts/workspace_prompt_template.dart';
import 'package:atlas_ai_backend/src/ai/services/workspace_ai_service.dart';
import 'package:atlas_ai_backend/src/ai/tools/framework_catalog_tool.dart';
import 'package:atlas_ai_backend/src/ai/tools/risk_pattern_tool.dart';
import 'package:atlas_ai_backend/src/auth/handlers/auth_handler.dart';
import 'package:atlas_ai_backend/src/auth/services/bootstrap_auth_service.dart';
import 'package:atlas_ai_backend/src/auth/services/token_service.dart';
import 'package:atlas_ai_backend/src/common/http/middleware/correlation_id_middleware.dart';
import 'package:atlas_ai_backend/src/common/http/middleware/cors_middleware.dart';
import 'package:atlas_ai_backend/src/common/http/middleware/error_handling_middleware.dart';
import 'package:atlas_ai_backend/src/common/http/middleware/logging_middleware.dart';
import 'package:atlas_ai_backend/src/common/logging/app_logger.dart';
import 'package:atlas_ai_backend/src/config/environment.dart';
import 'package:atlas_ai_backend/src/config/server_config.dart';
import 'package:atlas_ai_backend/src/health/handlers/health_handler.dart';
import 'package:atlas_ai_backend/src/routing/app_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<void> main() async {
  final environment = await Environment.load();
  final serverConfig = ServerConfig.fromEnvironment(environment);
  final logger = AppLogger(verbose: serverConfig.enableVerboseLogs);

  final providerRegistry = AiProviderRegistry(
    environment: environment,
    logger: logger,
  );
  final authService = BootstrapAuthService(environment);
  final tokenService = TokenService(environment);
  final workspaceFlowFactory = WorkspacePlanFlowFactory(
    ai: providerRegistry.ai,
    providerRegistry: providerRegistry,
    frameworkCatalogService: const FrameworkCatalogService(),
    riskPatternService: const RiskPatternService(),
    promptTemplate: WorkspacePromptTemplate(),
    environment: environment,
    logger: logger,
  );
  final workspaceAiService = WorkspaceAiService(
    providerRegistry: providerRegistry,
    flowFactory: workspaceFlowFactory,
    enableGenkitDebug: environment.enableGenkitDebug,
    logger: logger,
  );

  final router = AppRouter(
    authHandler: AuthHandler(
      bootstrapAuthService: authService,
      tokenService: tokenService,
      apiVersion: serverConfig.apiVersion,
    ),
    aiHandler: AiHandler(
      workspaceAiService: workspaceAiService,
      apiVersion: serverConfig.apiVersion,
    ),
    healthHandler: HealthHandler(
      providerRegistry: providerRegistry,
      apiVersion: serverConfig.apiVersion,
    ),
    tokenService: tokenService,
  );

  final handler = const Pipeline()
      .addMiddleware(correlationIdMiddleware())
      .addMiddleware(
        errorHandlingMiddleware(
          logger: logger,
          apiVersion: serverConfig.apiVersion,
        ),
      )
      .addMiddleware(requestLoggingMiddleware(logger))
      .addMiddleware(corsMiddleware(serverConfig))
      .addHandler(router.handler);

  final server = await io.serve(handler, serverConfig.host, serverConfig.port);
  logger.info(
    'Atlas AI backend started',
    fields: {
      'address': 'http://${server.address.host}:${server.port}',
      'environment': serverConfig.appEnvironment,
      'apiVersion': serverConfig.apiVersion,
    },
  );

  ProcessSignal.sigint.watch().listen((_) async {
    logger.info('Received SIGINT, shutting down server');
    await server.close(force: true);
    exit(0);
  });
}
