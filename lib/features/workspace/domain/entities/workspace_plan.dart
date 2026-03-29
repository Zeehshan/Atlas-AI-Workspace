import 'package:shared_contracts/shared_contracts.dart';

class WorkspaceDraft {
  const WorkspaceDraft({
    required this.goal,
    required this.targetAudience,
    required this.successDefinition,
    required this.constraints,
    required this.notes,
    required this.preferredProvider,
  });

  final String goal;
  final String targetAudience;
  final String successDefinition;
  final List<String> constraints;
  final String notes;
  final AiProviderOption preferredProvider;

  bool get isValid =>
      goal.trim().isNotEmpty &&
      targetAudience.trim().isNotEmpty &&
      successDefinition.trim().isNotEmpty;

  WorkspacePlanRequest toRequest() {
    return WorkspacePlanRequest(
      goal: goal.trim(),
      targetAudience: targetAudience.trim(),
      successDefinition: successDefinition.trim(),
      constraints: constraints,
      notes: notes.trim(),
      preferredProvider: preferredProvider,
    );
  }
}

class WorkspaceMilestone {
  const WorkspaceMilestone({
    required this.title,
    required this.owner,
    required this.timeframe,
    required this.outcome,
  });

  final String title;
  final String owner;
  final String timeframe;
  final String outcome;

  factory WorkspaceMilestone.fromDto(WorkspacePlanMilestone dto) {
    return WorkspaceMilestone(
      title: dto.title,
      owner: dto.owner,
      timeframe: dto.timeframe,
      outcome: dto.outcome,
    );
  }
}

class WorkspaceRisk {
  const WorkspaceRisk({
    required this.title,
    required this.severity,
    required this.mitigation,
  });

  final String title;
  final String severity;
  final String mitigation;

  factory WorkspaceRisk.fromDto(WorkspacePlanRisk dto) {
    return WorkspaceRisk(
      title: dto.title,
      severity: dto.severity,
      mitigation: dto.mitigation,
    );
  }
}

class WorkspaceToolInsight {
  const WorkspaceToolInsight({required this.name, required this.reason});

  final String name;
  final String reason;

  factory WorkspaceToolInsight.fromDto(WorkspacePlanToolInsight dto) {
    return WorkspaceToolInsight(name: dto.name, reason: dto.reason);
  }
}

class WorkspaceDebugInfo {
  const WorkspaceDebugInfo({
    required this.promptVersion,
    required this.correlationId,
    required this.provider,
    required this.model,
    required this.latencyMs,
  });

  final String promptVersion;
  final String correlationId;
  final AiProviderOption provider;
  final String model;
  final int latencyMs;

  factory WorkspaceDebugInfo.fromDto(AiDebugInfo dto) {
    return WorkspaceDebugInfo(
      promptVersion: dto.promptVersion,
      correlationId: dto.correlationId,
      provider: dto.provider,
      model: dto.model,
      latencyMs: dto.latencyMs,
    );
  }
}

class WorkspacePlan {
  const WorkspacePlan({
    required this.planId,
    required this.provider,
    required this.model,
    required this.generatedAt,
    required this.executiveSummary,
    required this.problemStatement,
    required this.recommendedApproach,
    required this.milestones,
    required this.risks,
    required this.followUpQuestions,
    required this.toolInsights,
    this.debugInfo,
  });

  final String planId;
  final AiProviderOption provider;
  final String model;
  final DateTime generatedAt;
  final String executiveSummary;
  final String problemStatement;
  final String recommendedApproach;
  final List<WorkspaceMilestone> milestones;
  final List<WorkspaceRisk> risks;
  final List<String> followUpQuestions;
  final List<WorkspaceToolInsight> toolInsights;
  final WorkspaceDebugInfo? debugInfo;

  factory WorkspacePlan.fromDto(WorkspacePlanResponse dto) {
    return WorkspacePlan(
      planId: dto.planId,
      provider: dto.provider,
      model: dto.model,
      generatedAt: dto.generatedAt,
      executiveSummary: dto.executiveSummary,
      problemStatement: dto.problemStatement,
      recommendedApproach: dto.recommendedApproach,
      milestones: dto.milestones
          .map(WorkspaceMilestone.fromDto)
          .toList(growable: false),
      risks: dto.risks.map(WorkspaceRisk.fromDto).toList(growable: false),
      followUpQuestions: dto.followUpQuestions,
      toolInsights: dto.toolInsights
          .map(WorkspaceToolInsight.fromDto)
          .toList(growable: false),
      debugInfo: dto.debugInfo == null
          ? null
          : WorkspaceDebugInfo.fromDto(dto.debugInfo!),
    );
  }
}
