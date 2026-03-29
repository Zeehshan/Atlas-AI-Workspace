import 'package:faiapp/core/errors/app_exception.dart';
import 'package:faiapp/core/network/api_client.dart';
import 'package:shared_contracts/shared_contracts.dart';

class SettingsRemoteDataSource {
  SettingsRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<BackendPublicConfig> fetchBackendPublicConfig() async {
    final json = await _apiClient.getJson('/v1/config');
    final envelope = ApiEnvelope<BackendPublicConfig>.fromJson(
      json,
      (value) => BackendPublicConfig.fromJson(value as Map<String, dynamic>),
    );

    if (!envelope.isSuccess || envelope.data == null) {
      throw AppException(
        code: envelope.error?.code ?? 'config_fetch_failed',
        message:
            envelope.error?.message ?? 'Unable to fetch backend configuration.',
      );
    }

    return envelope.data!;
  }
}
