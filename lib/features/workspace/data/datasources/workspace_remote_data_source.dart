import 'package:faiapp/core/errors/app_exception.dart';
import 'package:faiapp/core/network/api_client.dart';
import 'package:shared_contracts/shared_contracts.dart';

class WorkspaceRemoteDataSource {
  WorkspaceRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<WorkspacePlanResponse> generatePlan(
    WorkspacePlanRequest request,
  ) async {
    final json = await _apiClient.postJson(
      '/v1/ai/workspace-plans',
      data: request.toJson(),
    );

    final envelope = ApiEnvelope<WorkspacePlanResponse>.fromJson(
      json,
      (value) => WorkspacePlanResponse.fromJson(value as Map<String, dynamic>),
    );

    if (!envelope.isSuccess || envelope.data == null) {
      throw AppException(
        code: envelope.error?.code ?? 'workspace_generation_failed',
        message:
            envelope.error?.message ?? 'Unable to generate a workspace plan.',
      );
    }

    return envelope.data!;
  }
}
