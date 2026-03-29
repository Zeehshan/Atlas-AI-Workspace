import 'dart:async';

import 'package:atlas_ai_backend/src/ai/config/ai_provider_registry.dart';
import 'package:atlas_ai_backend/src/ai/prompts/workspace_prompt_template.dart';
import 'package:atlas_ai_backend/src/ai/tools/framework_catalog_tool.dart';
import 'package:atlas_ai_backend/src/ai/tools/risk_pattern_tool.dart';
import 'package:atlas_ai_backend/src/common/logging/app_logger.dart';
import 'package:atlas_ai_backend/src/config/environment.dart';
import 'package:genkit/genkit.dart' as gk;
import 'package:schemantic/schemantic.dart';
import 'package:shared_contracts/shared_contracts.dart';

part 'workspace_plan_flow.g.dart';

@Schema()
abstract class $WorkspaceFlowInput {
  String get userId;
  String get goal;
  String get targetAudience;
  String get successDefinition;
  List<String> get constraints;
  String get notes;
  String get preferredProvider;
}

@Schema()
abstract class $PlanningIntent {
  String get initiativeType;
  String get deliveryStage;
  String get primaryRiskTheme;
  List<String> get frameworkKeywords;
}

@Schema()
abstract class $FrameworkToolInput {
  String get initiativeType;
  String get deliveryStage;
  List<String> get frameworkKeywords;
}

@Schema()
abstract class $RiskToolInput {
  String get primaryRiskTheme;
  List<String> get constraints;
  String get goal;
}

@Schema()
abstract class $WorkspaceMilestoneOutput {
  String get title;
  String get owner;
  String get timeframe;
  String get outcome;
}

@Schema()
abstract class $WorkspaceRiskOutput {
  String get title;
  String get severity;
  String get mitigation;
}

@Schema()
abstract class $WorkspaceToolInsightOutput {
  String get name;
  String get reason;
}

@Schema()
abstract class $WorkspaceFlowOutput {
  String get promptVersion;
  String get executiveSummary;
  String get problemStatement;
  String get recommendedApproach;
  List<$WorkspaceMilestoneOutput> get milestones;
  List<$WorkspaceRiskOutput> get risks;
  List<String> get followUpQuestions;
  List<$WorkspaceToolInsightOutput> get toolInsights;
}

class WorkspacePlanFlowFactory {
  WorkspacePlanFlowFactory({
    required gk.Genkit ai,
    required AiProviderRegistry providerRegistry,
    required FrameworkCatalogService frameworkCatalogService,
    required RiskPatternService riskPatternService,
    required WorkspacePromptTemplate promptTemplate,
    required Environment environment,
    required AppLogger logger,
  }) : _ai = ai,
       _providerRegistry = providerRegistry,
       _frameworkCatalogService = frameworkCatalogService,
       _riskPatternService = riskPatternService,
       _promptTemplate = promptTemplate,
       _environment = environment,
       _logger = logger {
    _defineTools();
    flow = _ai.defineFlow(
      name: 'workspacePlanFlow',
      inputSchema: WorkspaceFlowInput.$schema,
      outputSchema: WorkspaceFlowOutput.$schema,
      fn: _run,
    );
  }

  final gk.Genkit _ai;
  final AiProviderRegistry _providerRegistry;
  final FrameworkCatalogService _frameworkCatalogService;
  final RiskPatternService _riskPatternService;
  final WorkspacePromptTemplate _promptTemplate;
  final Environment _environment;
  final AppLogger _logger;

  late final dynamic flow;

  void _defineTools() {
    _ai.defineTool(
      name: 'frameworkCatalogLookup',
      description:
          'Look up internal planning frameworks relevant to the initiative.',
      inputSchema: FrameworkToolInput.$schema,
      fn: (FrameworkToolInput input, _) async {
        return _frameworkCatalogService.lookupSummary(
          initiativeType: input.initiativeType,
          deliveryStage: input.deliveryStage,
          frameworkKeywords: input.frameworkKeywords,
        );
      },
    );

    _ai.defineTool(
      name: 'riskPatternLookup',
      description: 'Look up common delivery and launch risks with mitigations.',
      inputSchema: RiskToolInput.$schema,
      fn: (RiskToolInput input, _) async {
        return _riskPatternService.lookupSummary(
          primaryRiskTheme: input.primaryRiskTheme,
          constraints: input.constraints,
          goal: input.goal,
        );
      },
    );
  }

  Future<WorkspaceFlowOutput> _run(
    WorkspaceFlowInput input,
    dynamic context,
  ) async {
    final flowContext = context?.context as Map<String, dynamic>? ?? const {};
    final auth = flowContext['auth'] as Map<String, dynamic>? ?? const {};
    final authenticatedUserId = auth['uid'] as String?;
    final requestId = flowContext['requestId'] as String? ?? 'flow-unknown';

    if (authenticatedUserId == null || authenticatedUserId != input.userId) {
      throw gk.GenkitException(
        'You are not authorized to execute this plan.',
        status: gk.StatusCodes.UNAUTHENTICATED,
      );
    }

    final resolvedModel = _providerRegistry.resolve(
      AiProviderOption.tryParse(input.preferredProvider),
    );
    final intent = await _classifyIntent(input, resolvedModel, requestId);
    final frameworks = _frameworkCatalogService.lookup(
      initiativeType: intent.initiativeType,
      deliveryStage: intent.deliveryStage,
      frameworkKeywords: intent.frameworkKeywords,
    );
    final risks = _riskPatternService.lookup(
      primaryRiskTheme: intent.primaryRiskTheme,
      constraints: input.constraints,
      goal: input.goal,
    );

    try {
      final response = await _withRetry(
        requestId: requestId,
        operationName: 'workspace_plan_generate',
        operation: () => _ai.generate(
          model: resolvedModel.model,
          prompt: _promptTemplate.finalPlanPrompt(
            input: input,
            intent: intent,
            frameworks: frameworks,
            risks: risks,
          ),
          outputSchema: WorkspaceFlowOutput.$schema,
          toolNames: const ['frameworkCatalogLookup', 'riskPatternLookup'],
        ),
      );

      final output = response.output;
      if (output is WorkspaceFlowOutput) {
        return _mergeFallbacks(output, frameworks, risks);
      }
    } catch (error) {
      _logger.warning(
        'Structured generation failed, falling back to deterministic output',
        fields: {'requestId': requestId, 'error': error.toString()},
      );
    }

    return _fallbackOutput(input, intent, frameworks, risks);
  }

  Future<PlanningIntent> _classifyIntent(
    WorkspaceFlowInput input,
    ResolvedModel resolvedModel,
    String requestId,
  ) async {
    try {
      final response = await _withRetry(
        requestId: requestId,
        operationName: 'workspace_plan_classify',
        operation: () => _ai.generate(
          model: resolvedModel.model,
          prompt: _promptTemplate.classificationPrompt(input),
          outputSchema: PlanningIntent.$schema,
        ),
      );
      final output = response.output;
      if (output is PlanningIntent) {
        return output;
      }
    } catch (error) {
      _logger.warning(
        'Classification failed, using heuristic intent',
        fields: {'requestId': requestId, 'error': error.toString()},
      );
    }

    return _heuristicIntent(input);
  }

  PlanningIntent _heuristicIntent(WorkspaceFlowInput input) {
    final normalizedGoal = '${input.goal} ${input.notes}'.toLowerCase();
    final stage = normalizedGoal.contains('launch')
        ? 'launch'
        : normalizedGoal.contains('scale')
        ? 'scale'
        : normalizedGoal.contains('discover') ||
              normalizedGoal.contains('research')
        ? 'discovery'
        : normalizedGoal.contains('validate')
        ? 'validation'
        : 'build';

    final riskTheme =
        normalizedGoal.contains('security') ||
            input.constraints.join(' ').toLowerCase().contains('api key')
        ? 'security'
        : normalizedGoal.contains('adoption')
        ? 'adoption'
        : 'delivery';

    return PlanningIntent(
      initiativeType: normalizedGoal.contains('product')
          ? 'product delivery'
          : 'execution plan',
      deliveryStage: stage,
      primaryRiskTheme: riskTheme,
      frameworkKeywords: [
        if (normalizedGoal.contains('product')) 'prioritization',
        if (normalizedGoal.contains('analytics')) 'analytics',
        if (normalizedGoal.contains('rollout') ||
            normalizedGoal.contains('launch'))
          'rollout',
        if (normalizedGoal.contains('security')) 'security',
      ],
    );
  }

  WorkspaceFlowOutput _mergeFallbacks(
    WorkspaceFlowOutput output,
    List<FrameworkCatalogMatch> frameworks,
    List<RiskPatternMatch> risks,
  ) {
    return WorkspaceFlowOutput(
      promptVersion: output.promptVersion,
      executiveSummary: output.executiveSummary,
      problemStatement: output.problemStatement,
      recommendedApproach: output.recommendedApproach,
      milestones: output.milestones.isEmpty
          ? _defaultMilestones()
          : output.milestones,
      risks: output.risks.isEmpty ? _fallbackRisks(risks) : output.risks,
      followUpQuestions: output.followUpQuestions.isEmpty
          ? _defaultQuestions()
          : output.followUpQuestions,
      toolInsights: output.toolInsights.isEmpty
          ? _fallbackToolInsights(frameworks)
          : output.toolInsights,
    );
  }

  WorkspaceFlowOutput _fallbackOutput(
    WorkspaceFlowInput input,
    PlanningIntent intent,
    List<FrameworkCatalogMatch> frameworks,
    List<RiskPatternMatch> risks,
  ) {
    return WorkspaceFlowOutput(
      promptVersion: WorkspacePromptTemplate.version,
      executiveSummary:
          'Deliver a focused ${intent.deliveryStage} plan for ${input.goal.toLowerCase()} with backend-owned AI orchestration and measurable rollout checkpoints.',
      problemStatement:
          'The initiative needs a clear delivery backbone for ${input.targetAudience.toLowerCase()} while respecting constraints around ${input.constraints.join(', ').toLowerCase()}.',
      recommendedApproach:
          'Use a phased ${intent.deliveryStage} plan with typed contracts, backend-secured AI execution, and milestone-based validation before broad rollout.',
      milestones: _defaultMilestones(),
      risks: _fallbackRisks(risks),
      followUpQuestions: _defaultQuestions(),
      toolInsights: _fallbackToolInsights(frameworks),
    );
  }

  List<WorkspaceMilestoneOutput> _defaultMilestones() {
    return [
      WorkspaceMilestoneOutput(
        title: 'Lock contracts and architecture',
        owner: 'Tech lead',
        timeframe: 'Week 1',
        outcome:
            'Finalize API contracts, auth boundaries, and provider abstraction.',
      ),
      WorkspaceMilestoneOutput(
        title: 'Implement secure end-to-end flow',
        owner: 'Full-stack squad',
        timeframe: 'Weeks 2-3',
        outcome:
            'Ship the Flutter UI, backend routing, and Genkit orchestration behind authenticated APIs.',
      ),
      WorkspaceMilestoneOutput(
        title: 'Validate quality and observability',
        owner: 'QA + platform',
        timeframe: 'Week 4',
        outcome:
            'Cover core journeys with testing, request tracing, and error handling verification.',
      ),
      WorkspaceMilestoneOutput(
        title: 'Pilot and iterate',
        owner: 'Product owner',
        timeframe: 'Week 5+',
        outcome:
            'Run a beta cohort, inspect analytics, and refine prompts plus rollout guardrails.',
      ),
    ];
  }

  List<WorkspaceRiskOutput> _fallbackRisks(List<RiskPatternMatch> risks) {
    return risks
        .map(
          (item) => WorkspaceRiskOutput(
            title: item.title,
            severity: item.severity,
            mitigation: item.mitigation,
          ),
        )
        .toList(growable: false);
  }

  List<String> _defaultQuestions() {
    return [
      'Which milestone is the release gate for beta readiness?',
      'What telemetry proves the workflow is valuable to the target audience?',
      'Which operational controls must exist before broader rollout?',
    ];
  }

  List<WorkspaceToolInsightOutput> _fallbackToolInsights(
    List<FrameworkCatalogMatch> frameworks,
  ) {
    return frameworks
        .map(
          (item) =>
              WorkspaceToolInsightOutput(name: item.name, reason: item.reason),
        )
        .toList(growable: false);
  }

  Future<T> _withRetry<T>({
    required String requestId,
    required String operationName,
    required Future<T> Function() operation,
  }) async {
    Object? lastError;
    StackTrace? lastStackTrace;

    for (var attempt = 1; attempt <= 2; attempt++) {
      try {
        return await operation().timeout(
          Duration(seconds: _environment.aiStepTimeoutSeconds),
        );
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
        if (attempt == 2) {
          break;
        }
        _logger.warning(
          'Retrying AI operation',
          fields: {
            'requestId': requestId,
            'operation': operationName,
            'attempt': attempt,
            'error': error.toString(),
          },
        );
        await Future<void>.delayed(Duration(milliseconds: 350 * attempt));
      }
    }

    Error.throwWithStackTrace(lastError!, lastStackTrace!);
  }
}
