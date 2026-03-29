import 'package:atlas_ai_backend/src/ai/config/ai_provider_registry.dart';
import 'package:atlas_ai_backend/src/ai/flows/workspace_plan_flow.dart';
import 'package:atlas_ai_backend/src/auth/domain/authenticated_user.dart';
import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:atlas_ai_backend/src/common/logging/app_logger.dart';
import 'package:shared_contracts/shared_contracts.dart';

class WorkspaceAiService {
  const WorkspaceAiService({
    required AiProviderRegistry providerRegistry,
    required WorkspacePlanFlowFactory flowFactory,
    required bool enableGenkitDebug,
    required AppLogger logger,
  }) : _providerRegistry = providerRegistry,
       _flowFactory = flowFactory,
       _enableGenkitDebug = enableGenkitDebug,
       _logger = logger;

  final AiProviderRegistry _providerRegistry;
  final WorkspacePlanFlowFactory _flowFactory;
  final bool _enableGenkitDebug;
  final AppLogger _logger;

  Future<WorkspacePlanResponse> generatePlan({
    required WorkspacePlanRequest request,
    required AuthenticatedUser authenticatedUser,
    required String requestId,
  }) async {
    final resolvedModel = _providerRegistry.resolve(request.preferredProvider);
    final startedAt = DateTime.now().toUtc();

    try {
      final flowInput = WorkspaceFlowInput(
        userId: authenticatedUser.id,
        goal: request.goal,
        targetAudience: request.targetAudience,
        successDefinition: request.successDefinition,
        constraints: request.constraints,
        notes: request.notes,
        preferredProvider: resolvedModel.provider.wireValue,
      );

      final flowOutput =
          await _flowFactory.flow(
                flowInput,
                context: {
                  'auth': authenticatedUser.toContextMap(),
                  'requestId': requestId,
                },
              )
              as WorkspaceFlowOutput;

      final generatedAt = DateTime.now().toUtc();
      final latencyMs = generatedAt.difference(startedAt).inMilliseconds;

      return WorkspacePlanResponse(
        planId: 'plan-${generatedAt.microsecondsSinceEpoch.toRadixString(36)}',
        provider: resolvedModel.provider,
        model: resolvedModel.modelName,
        generatedAt: generatedAt,
        executiveSummary: flowOutput.executiveSummary,
        problemStatement: flowOutput.problemStatement,
        recommendedApproach: flowOutput.recommendedApproach,
        milestones: flowOutput.milestones
            .map(
              (item) => WorkspacePlanMilestone(
                title: item.title,
                owner: item.owner,
                timeframe: item.timeframe,
                outcome: item.outcome,
              ),
            )
            .toList(growable: false),
        risks: flowOutput.risks
            .map(
              (item) => WorkspacePlanRisk(
                title: item.title,
                severity: item.severity,
                mitigation: item.mitigation,
              ),
            )
            .toList(growable: false),
        followUpQuestions: flowOutput.followUpQuestions,
        toolInsights: flowOutput.toolInsights
            .map(
              (item) => WorkspacePlanToolInsight(
                name: item.name,
                reason: item.reason,
              ),
            )
            .toList(growable: false),
        debugInfo: _enableGenkitDebug
            ? AiDebugInfo(
                promptVersion: flowOutput.promptVersion,
                correlationId: requestId,
                provider: resolvedModel.provider,
                model: resolvedModel.modelName,
                latencyMs: latencyMs,
              )
            : null,
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Workspace flow execution failed',
        error: error,
        stackTrace: stackTrace,
        fields: {
          'requestId': requestId,
          'userId': authenticatedUser.id,
          'provider': resolvedModel.provider.wireValue,
        },
      );
      throw ApiException.serviceUnavailable(
        'The AI workflow is temporarily unavailable. Please try again.',
      );
    }
  }
}
