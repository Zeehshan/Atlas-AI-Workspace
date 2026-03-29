import 'package:faiapp/core/errors/app_exception.dart';
import 'package:faiapp/core/errors/failure.dart';
import 'package:faiapp/core/logging/app_logger.dart';
import 'package:faiapp/core/providers/core_providers.dart';
import 'package:faiapp/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:faiapp/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:faiapp/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_contracts/shared_contracts.dart';

class SettingsState {
  const SettingsState({
    required this.isLoading,
    this.publicConfig,
    this.errorMessage,
  });

  const SettingsState.initial()
    : isLoading = true,
      publicConfig = null,
      errorMessage = null;

  final bool isLoading;
  final BackendPublicConfig? publicConfig;
  final String? errorMessage;

  SettingsState copyWith({
    bool? isLoading,
    BackendPublicConfig? publicConfig,
    bool clearConfig = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      publicConfig: clearConfig ? null : (publicConfig ?? this.publicConfig),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController({
    required SettingsRepository repository,
    required AppLogger logger,
  }) : _repository = repository,
       _logger = logger,
       super(const SettingsState.initial()) {
    load();
  }

  final SettingsRepository _repository;
  final AppLogger _logger;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final publicConfig = await _repository.fetchBackendPublicConfig();
      state = state.copyWith(
        isLoading: false,
        publicConfig: publicConfig,
        clearError: true,
      );
    } on AppException catch (exception, stackTrace) {
      _logger.error(
        'Failed to fetch backend config',
        error: exception,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: Failure.fromException(exception).message,
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Unexpected backend config failure',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load backend configuration.',
      );
    }
  }
}

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>(
  (ref) => SettingsRemoteDataSource(ref.watch(apiClientProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.watch(settingsRemoteDataSourceProvider)),
);

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
      (ref) => SettingsController(
        repository: ref.watch(settingsRepositoryProvider),
        logger: ref.watch(appLoggerProvider),
      ),
    );
