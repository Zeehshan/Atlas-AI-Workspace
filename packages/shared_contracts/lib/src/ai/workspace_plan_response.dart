import 'package:shared_contracts/src/ai/ai_provider_option.dart';

class WorkspacePlanMilestone {
  const WorkspacePlanMilestone({
    required this.title,
    required this.owner,
    required this.timeframe,
    required this.outcome,
  });

  final String title;
  final String owner;
  final String timeframe;
  final String outcome;

  factory WorkspacePlanMilestone.fromJson(Map<String, dynamic> json) {
    return WorkspacePlanMilestone(
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      timeframe: json['timeframe'] as String? ?? '',
      outcome: json['outcome'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'owner': owner,
      'timeframe': timeframe,
      'outcome': outcome,
    };
  }
}

class WorkspacePlanRisk {
  const WorkspacePlanRisk({
    required this.title,
    required this.severity,
    required this.mitigation,
  });

  final String title;
  final String severity;
  final String mitigation;

  factory WorkspacePlanRisk.fromJson(Map<String, dynamic> json) {
    return WorkspacePlanRisk(
      title: json['title'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
      mitigation: json['mitigation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'severity': severity, 'mitigation': mitigation};
  }
}

class WorkspacePlanToolInsight {
  const WorkspacePlanToolInsight({required this.name, required this.reason});

  final String name;
  final String reason;

  factory WorkspacePlanToolInsight.fromJson(Map<String, dynamic> json) {
    return WorkspacePlanToolInsight(
      name: json['name'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'reason': reason};
  }
}

class AiDebugInfo {
  const AiDebugInfo({
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

  factory AiDebugInfo.fromJson(Map<String, dynamic> json) {
    return AiDebugInfo(
      promptVersion: json['promptVersion'] as String? ?? 'unknown',
      correlationId: json['correlationId'] as String? ?? '',
      provider:
          AiProviderOption.tryParse(json['provider'] as String?) ??
          AiProviderOption.google,
      model: json['model'] as String? ?? '',
      latencyMs: json['latencyMs'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promptVersion': promptVersion,
      'correlationId': correlationId,
      'provider': provider.wireValue,
      'model': model,
      'latencyMs': latencyMs,
    };
  }
}

class WorkspacePlanResponse {
  const WorkspacePlanResponse({
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
  final List<WorkspacePlanMilestone> milestones;
  final List<WorkspacePlanRisk> risks;
  final List<String> followUpQuestions;
  final List<WorkspacePlanToolInsight> toolInsights;
  final AiDebugInfo? debugInfo;

  factory WorkspacePlanResponse.fromJson(Map<String, dynamic> json) {
    return WorkspacePlanResponse(
      planId: json['planId'] as String? ?? '',
      provider:
          AiProviderOption.tryParse(json['provider'] as String?) ??
          AiProviderOption.google,
      model: json['model'] as String? ?? '',
      generatedAt:
          DateTime.tryParse(json['generatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      executiveSummary: json['executiveSummary'] as String? ?? '',
      problemStatement: json['problemStatement'] as String? ?? '',
      recommendedApproach: json['recommendedApproach'] as String? ?? '',
      milestones: (json['milestones'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                WorkspacePlanMilestone.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      risks: (json['risks'] as List<dynamic>? ?? const [])
          .map(
            (item) => WorkspacePlanRisk.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      followUpQuestions:
          (json['followUpQuestions'] as List<dynamic>? ?? const [])
              .map((item) => item as String)
              .toList(growable: false),
      toolInsights: (json['toolInsights'] as List<dynamic>? ?? const [])
          .map(
            (item) =>
                WorkspacePlanToolInsight.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      debugInfo: json['debugInfo'] is Map<String, dynamic>
          ? AiDebugInfo.fromJson(json['debugInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'provider': provider.wireValue,
      'model': model,
      'generatedAt': generatedAt.toUtc().toIso8601String(),
      'executiveSummary': executiveSummary,
      'problemStatement': problemStatement,
      'recommendedApproach': recommendedApproach,
      'milestones': milestones.map((item) => item.toJson()).toList(),
      'risks': risks.map((item) => item.toJson()).toList(),
      'followUpQuestions': followUpQuestions,
      'toolInsights': toolInsights.map((item) => item.toJson()).toList(),
      if (debugInfo case final value?) 'debugInfo': value.toJson(),
    };
  }
}
