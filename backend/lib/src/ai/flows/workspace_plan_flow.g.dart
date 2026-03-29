// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_plan_flow.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class WorkspaceFlowInput {
  factory WorkspaceFlowInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  WorkspaceFlowInput._(this._json);

  WorkspaceFlowInput({
    required String userId,
    required String goal,
    required String targetAudience,
    required String successDefinition,
    required List<String> constraints,
    required String notes,
    required String preferredProvider,
  }) {
    _json = {
      'userId': userId,
      'goal': goal,
      'targetAudience': targetAudience,
      'successDefinition': successDefinition,
      'constraints': constraints,
      'notes': notes,
      'preferredProvider': preferredProvider,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<WorkspaceFlowInput> $schema =
      _WorkspaceFlowInputTypeFactory();

  String get userId {
    return _json['userId'] as String;
  }

  set userId(String value) {
    _json['userId'] = value;
  }

  String get goal {
    return _json['goal'] as String;
  }

  set goal(String value) {
    _json['goal'] = value;
  }

  String get targetAudience {
    return _json['targetAudience'] as String;
  }

  set targetAudience(String value) {
    _json['targetAudience'] = value;
  }

  String get successDefinition {
    return _json['successDefinition'] as String;
  }

  set successDefinition(String value) {
    _json['successDefinition'] = value;
  }

  List<String> get constraints {
    return (_json['constraints'] as List).cast<String>();
  }

  set constraints(List<String> value) {
    _json['constraints'] = value;
  }

  String get notes {
    return _json['notes'] as String;
  }

  set notes(String value) {
    _json['notes'] = value;
  }

  String get preferredProvider {
    return _json['preferredProvider'] as String;
  }

  set preferredProvider(String value) {
    _json['preferredProvider'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _WorkspaceFlowInputTypeFactory
    extends SchemanticType<WorkspaceFlowInput> {
  const _WorkspaceFlowInputTypeFactory();

  @override
  WorkspaceFlowInput parse(Object? json) {
    return WorkspaceFlowInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'WorkspaceFlowInput',
    definition: $Schema
        .object(
          properties: {
            'userId': $Schema.string(),
            'goal': $Schema.string(),
            'targetAudience': $Schema.string(),
            'successDefinition': $Schema.string(),
            'constraints': $Schema.list(items: $Schema.string()),
            'notes': $Schema.string(),
            'preferredProvider': $Schema.string(),
          },
          required: [
            'userId',
            'goal',
            'targetAudience',
            'successDefinition',
            'constraints',
            'notes',
            'preferredProvider',
          ],
        )
        .value,
    dependencies: [],
  );
}

base class PlanningIntent {
  factory PlanningIntent.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  PlanningIntent._(this._json);

  PlanningIntent({
    required String initiativeType,
    required String deliveryStage,
    required String primaryRiskTheme,
    required List<String> frameworkKeywords,
  }) {
    _json = {
      'initiativeType': initiativeType,
      'deliveryStage': deliveryStage,
      'primaryRiskTheme': primaryRiskTheme,
      'frameworkKeywords': frameworkKeywords,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<PlanningIntent> $schema =
      _PlanningIntentTypeFactory();

  String get initiativeType {
    return _json['initiativeType'] as String;
  }

  set initiativeType(String value) {
    _json['initiativeType'] = value;
  }

  String get deliveryStage {
    return _json['deliveryStage'] as String;
  }

  set deliveryStage(String value) {
    _json['deliveryStage'] = value;
  }

  String get primaryRiskTheme {
    return _json['primaryRiskTheme'] as String;
  }

  set primaryRiskTheme(String value) {
    _json['primaryRiskTheme'] = value;
  }

  List<String> get frameworkKeywords {
    return (_json['frameworkKeywords'] as List).cast<String>();
  }

  set frameworkKeywords(List<String> value) {
    _json['frameworkKeywords'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _PlanningIntentTypeFactory extends SchemanticType<PlanningIntent> {
  const _PlanningIntentTypeFactory();

  @override
  PlanningIntent parse(Object? json) {
    return PlanningIntent._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'PlanningIntent',
    definition: $Schema
        .object(
          properties: {
            'initiativeType': $Schema.string(),
            'deliveryStage': $Schema.string(),
            'primaryRiskTheme': $Schema.string(),
            'frameworkKeywords': $Schema.list(items: $Schema.string()),
          },
          required: [
            'initiativeType',
            'deliveryStage',
            'primaryRiskTheme',
            'frameworkKeywords',
          ],
        )
        .value,
    dependencies: [],
  );
}

base class FrameworkToolInput {
  factory FrameworkToolInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  FrameworkToolInput._(this._json);

  FrameworkToolInput({
    required String initiativeType,
    required String deliveryStage,
    required List<String> frameworkKeywords,
  }) {
    _json = {
      'initiativeType': initiativeType,
      'deliveryStage': deliveryStage,
      'frameworkKeywords': frameworkKeywords,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<FrameworkToolInput> $schema =
      _FrameworkToolInputTypeFactory();

  String get initiativeType {
    return _json['initiativeType'] as String;
  }

  set initiativeType(String value) {
    _json['initiativeType'] = value;
  }

  String get deliveryStage {
    return _json['deliveryStage'] as String;
  }

  set deliveryStage(String value) {
    _json['deliveryStage'] = value;
  }

  List<String> get frameworkKeywords {
    return (_json['frameworkKeywords'] as List).cast<String>();
  }

  set frameworkKeywords(List<String> value) {
    _json['frameworkKeywords'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _FrameworkToolInputTypeFactory
    extends SchemanticType<FrameworkToolInput> {
  const _FrameworkToolInputTypeFactory();

  @override
  FrameworkToolInput parse(Object? json) {
    return FrameworkToolInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'FrameworkToolInput',
    definition: $Schema
        .object(
          properties: {
            'initiativeType': $Schema.string(),
            'deliveryStage': $Schema.string(),
            'frameworkKeywords': $Schema.list(items: $Schema.string()),
          },
          required: ['initiativeType', 'deliveryStage', 'frameworkKeywords'],
        )
        .value,
    dependencies: [],
  );
}

base class RiskToolInput {
  factory RiskToolInput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  RiskToolInput._(this._json);

  RiskToolInput({
    required String primaryRiskTheme,
    required List<String> constraints,
    required String goal,
  }) {
    _json = {
      'primaryRiskTheme': primaryRiskTheme,
      'constraints': constraints,
      'goal': goal,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<RiskToolInput> $schema =
      _RiskToolInputTypeFactory();

  String get primaryRiskTheme {
    return _json['primaryRiskTheme'] as String;
  }

  set primaryRiskTheme(String value) {
    _json['primaryRiskTheme'] = value;
  }

  List<String> get constraints {
    return (_json['constraints'] as List).cast<String>();
  }

  set constraints(List<String> value) {
    _json['constraints'] = value;
  }

  String get goal {
    return _json['goal'] as String;
  }

  set goal(String value) {
    _json['goal'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _RiskToolInputTypeFactory extends SchemanticType<RiskToolInput> {
  const _RiskToolInputTypeFactory();

  @override
  RiskToolInput parse(Object? json) {
    return RiskToolInput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'RiskToolInput',
    definition: $Schema
        .object(
          properties: {
            'primaryRiskTheme': $Schema.string(),
            'constraints': $Schema.list(items: $Schema.string()),
            'goal': $Schema.string(),
          },
          required: ['primaryRiskTheme', 'constraints', 'goal'],
        )
        .value,
    dependencies: [],
  );
}

base class WorkspaceMilestoneOutput {
  factory WorkspaceMilestoneOutput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  WorkspaceMilestoneOutput._(this._json);

  WorkspaceMilestoneOutput({
    required String title,
    required String owner,
    required String timeframe,
    required String outcome,
  }) {
    _json = {
      'title': title,
      'owner': owner,
      'timeframe': timeframe,
      'outcome': outcome,
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<WorkspaceMilestoneOutput> $schema =
      _WorkspaceMilestoneOutputTypeFactory();

  String get title {
    return _json['title'] as String;
  }

  set title(String value) {
    _json['title'] = value;
  }

  String get owner {
    return _json['owner'] as String;
  }

  set owner(String value) {
    _json['owner'] = value;
  }

  String get timeframe {
    return _json['timeframe'] as String;
  }

  set timeframe(String value) {
    _json['timeframe'] = value;
  }

  String get outcome {
    return _json['outcome'] as String;
  }

  set outcome(String value) {
    _json['outcome'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _WorkspaceMilestoneOutputTypeFactory
    extends SchemanticType<WorkspaceMilestoneOutput> {
  const _WorkspaceMilestoneOutputTypeFactory();

  @override
  WorkspaceMilestoneOutput parse(Object? json) {
    return WorkspaceMilestoneOutput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'WorkspaceMilestoneOutput',
    definition: $Schema
        .object(
          properties: {
            'title': $Schema.string(),
            'owner': $Schema.string(),
            'timeframe': $Schema.string(),
            'outcome': $Schema.string(),
          },
          required: ['title', 'owner', 'timeframe', 'outcome'],
        )
        .value,
    dependencies: [],
  );
}

base class WorkspaceRiskOutput {
  factory WorkspaceRiskOutput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  WorkspaceRiskOutput._(this._json);

  WorkspaceRiskOutput({
    required String title,
    required String severity,
    required String mitigation,
  }) {
    _json = {'title': title, 'severity': severity, 'mitigation': mitigation};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<WorkspaceRiskOutput> $schema =
      _WorkspaceRiskOutputTypeFactory();

  String get title {
    return _json['title'] as String;
  }

  set title(String value) {
    _json['title'] = value;
  }

  String get severity {
    return _json['severity'] as String;
  }

  set severity(String value) {
    _json['severity'] = value;
  }

  String get mitigation {
    return _json['mitigation'] as String;
  }

  set mitigation(String value) {
    _json['mitigation'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _WorkspaceRiskOutputTypeFactory
    extends SchemanticType<WorkspaceRiskOutput> {
  const _WorkspaceRiskOutputTypeFactory();

  @override
  WorkspaceRiskOutput parse(Object? json) {
    return WorkspaceRiskOutput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'WorkspaceRiskOutput',
    definition: $Schema
        .object(
          properties: {
            'title': $Schema.string(),
            'severity': $Schema.string(),
            'mitigation': $Schema.string(),
          },
          required: ['title', 'severity', 'mitigation'],
        )
        .value,
    dependencies: [],
  );
}

base class WorkspaceToolInsightOutput {
  factory WorkspaceToolInsightOutput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  WorkspaceToolInsightOutput._(this._json);

  WorkspaceToolInsightOutput({required String name, required String reason}) {
    _json = {'name': name, 'reason': reason};
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<WorkspaceToolInsightOutput> $schema =
      _WorkspaceToolInsightOutputTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String get reason {
    return _json['reason'] as String;
  }

  set reason(String value) {
    _json['reason'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _WorkspaceToolInsightOutputTypeFactory
    extends SchemanticType<WorkspaceToolInsightOutput> {
  const _WorkspaceToolInsightOutputTypeFactory();

  @override
  WorkspaceToolInsightOutput parse(Object? json) {
    return WorkspaceToolInsightOutput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'WorkspaceToolInsightOutput',
    definition: $Schema
        .object(
          properties: {'name': $Schema.string(), 'reason': $Schema.string()},
          required: ['name', 'reason'],
        )
        .value,
    dependencies: [],
  );
}

base class WorkspaceFlowOutput {
  factory WorkspaceFlowOutput.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  WorkspaceFlowOutput._(this._json);

  WorkspaceFlowOutput({
    required String promptVersion,
    required String executiveSummary,
    required String problemStatement,
    required String recommendedApproach,
    required List<WorkspaceMilestoneOutput> milestones,
    required List<WorkspaceRiskOutput> risks,
    required List<String> followUpQuestions,
    required List<WorkspaceToolInsightOutput> toolInsights,
  }) {
    _json = {
      'promptVersion': promptVersion,
      'executiveSummary': executiveSummary,
      'problemStatement': problemStatement,
      'recommendedApproach': recommendedApproach,
      'milestones': milestones.map((e) => e.toJson()).toList(),
      'risks': risks.map((e) => e.toJson()).toList(),
      'followUpQuestions': followUpQuestions,
      'toolInsights': toolInsights.map((e) => e.toJson()).toList(),
    };
  }

  late final Map<String, dynamic> _json;

  static const SchemanticType<WorkspaceFlowOutput> $schema =
      _WorkspaceFlowOutputTypeFactory();

  String get promptVersion {
    return _json['promptVersion'] as String;
  }

  set promptVersion(String value) {
    _json['promptVersion'] = value;
  }

  String get executiveSummary {
    return _json['executiveSummary'] as String;
  }

  set executiveSummary(String value) {
    _json['executiveSummary'] = value;
  }

  String get problemStatement {
    return _json['problemStatement'] as String;
  }

  set problemStatement(String value) {
    _json['problemStatement'] = value;
  }

  String get recommendedApproach {
    return _json['recommendedApproach'] as String;
  }

  set recommendedApproach(String value) {
    _json['recommendedApproach'] = value;
  }

  List<WorkspaceMilestoneOutput> get milestones {
    return (_json['milestones'] as List)
        .map(
          (e) => WorkspaceMilestoneOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  set milestones(List<WorkspaceMilestoneOutput> value) {
    _json['milestones'] = value.toList();
  }

  List<WorkspaceRiskOutput> get risks {
    return (_json['risks'] as List)
        .map((e) => WorkspaceRiskOutput.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  set risks(List<WorkspaceRiskOutput> value) {
    _json['risks'] = value.toList();
  }

  List<String> get followUpQuestions {
    return (_json['followUpQuestions'] as List).cast<String>();
  }

  set followUpQuestions(List<String> value) {
    _json['followUpQuestions'] = value;
  }

  List<WorkspaceToolInsightOutput> get toolInsights {
    return (_json['toolInsights'] as List)
        .map(
          (e) => WorkspaceToolInsightOutput.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  set toolInsights(List<WorkspaceToolInsightOutput> value) {
    _json['toolInsights'] = value.toList();
  }

  @override
  String toString() {
    return _json.toString();
  }

  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _WorkspaceFlowOutputTypeFactory
    extends SchemanticType<WorkspaceFlowOutput> {
  const _WorkspaceFlowOutputTypeFactory();

  @override
  WorkspaceFlowOutput parse(Object? json) {
    return WorkspaceFlowOutput._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'WorkspaceFlowOutput',
    definition: $Schema
        .object(
          properties: {
            'promptVersion': $Schema.string(),
            'executiveSummary': $Schema.string(),
            'problemStatement': $Schema.string(),
            'recommendedApproach': $Schema.string(),
            'milestones': $Schema.list(
              items: $Schema.fromMap({
                '\$ref': r'#/$defs/WorkspaceMilestoneOutput',
              }),
            ),
            'risks': $Schema.list(
              items: $Schema.fromMap({'\$ref': r'#/$defs/WorkspaceRiskOutput'}),
            ),
            'followUpQuestions': $Schema.list(items: $Schema.string()),
            'toolInsights': $Schema.list(
              items: $Schema.fromMap({
                '\$ref': r'#/$defs/WorkspaceToolInsightOutput',
              }),
            ),
          },
          required: [
            'promptVersion',
            'executiveSummary',
            'problemStatement',
            'recommendedApproach',
            'milestones',
            'risks',
            'followUpQuestions',
            'toolInsights',
          ],
        )
        .value,
    dependencies: [
      WorkspaceMilestoneOutput.$schema,
      WorkspaceRiskOutput.$schema,
      WorkspaceToolInsightOutput.$schema,
    ],
  );
}
