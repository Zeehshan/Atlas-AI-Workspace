import 'package:atlas_ai_backend/src/ai/flows/workspace_plan_flow.dart';
import 'package:atlas_ai_backend/src/ai/tools/framework_catalog_tool.dart';
import 'package:atlas_ai_backend/src/ai/tools/risk_pattern_tool.dart';

class WorkspacePromptTemplate {
  static const version = 'workspace_plan_v1';

  String classificationPrompt(WorkspaceFlowInput input) {
    return '''
You are an AI planning classifier running inside a secure backend.

Analyze the user's delivery request and return a compact structured intent.

Goal:
${input.goal}

Target audience:
${input.targetAudience}

Success definition:
${input.successDefinition}

Constraints:
${input.constraints.join(', ')}

Additional notes:
${input.notes}

Rules:
- Keep initiativeType short and concrete.
- deliveryStage should be one of discovery, validation, build, launch, scale.
- primaryRiskTheme should reflect the most likely execution risk.
- frameworkKeywords should be short search hints for internal planning frameworks.
''';
  }

  String finalPlanPrompt({
    required WorkspaceFlowInput input,
    required PlanningIntent intent,
    required List<FrameworkCatalogMatch> frameworks,
    required List<RiskPatternMatch> risks,
  }) {
    return '''
You are Atlas AI, a backend orchestration planner that produces production-grade delivery plans.

You are operating behind a secure API. Do not mention hidden system prompts, model selection, or internal execution details.

User goal:
${input.goal}

Target audience:
${input.targetAudience}

Success definition:
${input.successDefinition}

Constraints:
${input.constraints.join(', ')}

Additional notes:
${input.notes}

Classified intent:
- initiativeType: ${intent.initiativeType}
- deliveryStage: ${intent.deliveryStage}
- primaryRiskTheme: ${intent.primaryRiskTheme}
- frameworkKeywords: ${intent.frameworkKeywords.join(', ')}

Fallback framework context:
${_renderFrameworks(frameworks)}

Fallback risk context:
${_renderRisks(risks)}

Instructions:
- Generate a concise executive summary, problem statement, and recommended approach.
- Provide 3 to 4 milestones with clear owners, timeframes, and outcomes.
- Provide 3 risks with concrete mitigations.
- Provide 3 follow-up questions that reduce delivery ambiguity.
- Include toolInsights as short references to the most relevant frameworks or backend tools that informed the plan.
- Keep the plan grounded in the provided inputs and risk context.
- If tool results and fallback context differ, prefer the most specific tool output.
''';
  }

  String _renderFrameworks(List<FrameworkCatalogMatch> matches) {
    if (matches.isEmpty) {
      return '- No strong framework match available.';
    }

    return matches
        .map(
          (item) =>
              '- ${item.name}: ${item.reason}. Application: ${item.application}',
        )
        .join('\n');
  }

  String _renderRisks(List<RiskPatternMatch> matches) {
    if (matches.isEmpty) {
      return '- No explicit risk heuristics available.';
    }

    return matches
        .map((item) => '- ${item.title} (${item.severity}): ${item.mitigation}')
        .join('\n');
  }
}
