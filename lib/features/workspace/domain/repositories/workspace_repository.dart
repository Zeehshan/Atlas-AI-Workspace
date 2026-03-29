import 'package:faiapp/features/workspace/domain/entities/workspace_plan.dart';

abstract class WorkspaceRepository {
  Future<WorkspacePlan> generatePlan(WorkspaceDraft draft);

  Future<WorkspacePlan?> readCachedPlan();
}
