import 'package:faiapp/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:faiapp/features/settings/domain/repositories/settings_repository.dart';
import 'package:shared_contracts/shared_contracts.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._remoteDataSource);

  final SettingsRemoteDataSource _remoteDataSource;

  @override
  Future<BackendPublicConfig> fetchBackendPublicConfig() {
    return _remoteDataSource.fetchBackendPublicConfig();
  }
}
