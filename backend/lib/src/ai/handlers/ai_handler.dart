import 'package:atlas_ai_backend/src/ai/services/workspace_ai_service.dart';
import 'package:atlas_ai_backend/src/common/context/request_context.dart';
import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:atlas_ai_backend/src/common/http/json_response.dart';
import 'package:atlas_ai_backend/src/common/http/request_body.dart';
import 'package:shared_contracts/shared_contracts.dart';
import 'package:shelf/shelf.dart';

class AiHandler {
  const AiHandler({
    required WorkspaceAiService workspaceAiService,
    required String apiVersion,
  }) : _workspaceAiService = workspaceAiService,
       _apiVersion = apiVersion;

  final WorkspaceAiService _workspaceAiService;
  final String _apiVersion;

  Future<Response> generateWorkspacePlan(Request request) async {
    final authenticatedUser = request.authenticatedUser;
    if (authenticatedUser == null) {
      throw ApiException.unauthorized('Authentication is required.');
    }

    final body = await readJsonBody(request);
    final workspaceRequest = WorkspacePlanRequest.fromJson(body);
    if (!workspaceRequest.isValid) {
      throw ApiException.badRequest(
        'Goal, target audience, and success definition are required.',
      );
    }

    final response = await _workspaceAiService.generatePlan(
      request: workspaceRequest,
      authenticatedUser: authenticatedUser,
      requestId: request.requestId,
    );

    return jsonSuccess(
      data: response,
      encode: (value) => value.toJson(),
      requestId: request.requestId,
      apiVersion: _apiVersion,
    );
  }
}
