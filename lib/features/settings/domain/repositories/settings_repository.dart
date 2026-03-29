import 'package:shared_contracts/shared_contracts.dart';

abstract class SettingsRepository {
  Future<BackendPublicConfig> fetchBackendPublicConfig();
}
