import 'package:faiapp/core/errors/app_exception.dart';
import 'package:faiapp/core/network/api_client.dart';
import 'package:shared_contracts/shared_contracts.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthTokensResponse> signIn({
    required String email,
    required String password,
  }) async {
    final json = await _apiClient.postJson(
      '/v1/auth/login',
      data: LoginRequest(email: email, password: password).toJson(),
    );

    final envelope = ApiEnvelope<AuthTokensResponse>.fromJson(
      json,
      (value) => AuthTokensResponse.fromJson(value as Map<String, dynamic>),
    );

    if (!envelope.isSuccess || envelope.data == null) {
      throw AppException(
        code: envelope.error?.code ?? 'login_failed',
        message: envelope.error?.message ?? 'Unable to sign in.',
      );
    }

    return envelope.data!;
  }

  Future<AuthTokensResponse> refresh(String refreshToken) async {
    final json = await _apiClient.postJson(
      '/v1/auth/refresh',
      data: RefreshSessionRequest(refreshToken: refreshToken).toJson(),
    );

    final envelope = ApiEnvelope<AuthTokensResponse>.fromJson(
      json,
      (value) => AuthTokensResponse.fromJson(value as Map<String, dynamic>),
    );

    if (!envelope.isSuccess || envelope.data == null) {
      throw AppException(
        code: envelope.error?.code ?? 'refresh_failed',
        message: envelope.error?.message ?? 'Unable to refresh the session.',
      );
    }

    return envelope.data!;
  }
}
