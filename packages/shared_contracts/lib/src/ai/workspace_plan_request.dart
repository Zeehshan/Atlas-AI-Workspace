import 'package:shared_contracts/src/ai/ai_provider_option.dart';

class WorkspacePlanRequest {
  const WorkspacePlanRequest({
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

  factory WorkspacePlanRequest.fromJson(Map<String, dynamic> json) {
    return WorkspacePlanRequest(
      goal: json['goal'] as String? ?? '',
      targetAudience: json['targetAudience'] as String? ?? '',
      successDefinition: json['successDefinition'] as String? ?? '',
      constraints: (json['constraints'] as List<dynamic>? ?? const [])
          .map((item) => item as String)
          .toList(growable: false),
      notes: json['notes'] as String? ?? '',
      preferredProvider:
          AiProviderOption.tryParse(json['preferredProvider'] as String?) ??
          AiProviderOption.google,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'targetAudience': targetAudience,
      'successDefinition': successDefinition,
      'constraints': constraints,
      'notes': notes,
      'preferredProvider': preferredProvider.wireValue,
    };
  }
}
