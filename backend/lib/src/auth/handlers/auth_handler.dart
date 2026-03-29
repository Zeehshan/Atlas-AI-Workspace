import 'package:atlas_ai_backend/src/auth/services/bootstrap_auth_service.dart';
import 'package:atlas_ai_backend/src/auth/services/token_service.dart';
import 'package:atlas_ai_backend/src/common/context/request_context.dart';
import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:atlas_ai_backend/src/common/http/json_response.dart';
import 'package:atlas_ai_backend/src/common/http/request_body.dart';
import 'package:shared_contracts/shared_contracts.dart';
import 'package:shelf/shelf.dart';

class AuthHandler {
  const AuthHandler({
    required BootstrapAuthService bootstrapAuthService,
    required TokenService tokenService,
    required String apiVersion,
  }) : _bootstrapAuthService = bootstrapAuthService,
       _tokenService = tokenService,
       _apiVersion = apiVersion;

  final BootstrapAuthService _bootstrapAuthService;
  final TokenService _tokenService;
  final String _apiVersion;

  Future<Response> login(Request request) async {
    final body = await readJsonBody(request);
    final loginRequest = LoginRequest.fromJson(body);
    if (loginRequest.email.trim().isEmpty || loginRequest.password.isEmpty) {
      throw ApiException.badRequest('Email and password are required.');
    }

    final user = _bootstrapAuthService.authenticate(
      email: loginRequest.email,
      password: loginRequest.password,
    );
    final response = _tokenService.issueTokens(user);

    return jsonSuccess(
      data: response,
      encode: (value) => value.toJson(),
      requestId: request.requestId,
      apiVersion: _apiVersion,
    );
  }

  Future<Response> refresh(Request request) async {
    final body = await readJsonBody(request);
    final refreshRequest = RefreshSessionRequest.fromJson(body);
    if (refreshRequest.refreshToken.trim().isEmpty) {
      throw ApiException.badRequest('Refresh token is required.');
    }

    final user = _tokenService.verifyRefreshToken(refreshRequest.refreshToken);
    final response = _tokenService.issueTokens(user);

    return jsonSuccess(
      data: response,
      encode: (value) => value.toJson(),
      requestId: request.requestId,
      apiVersion: _apiVersion,
    );
  }
}
