import 'package:faiapp/core/errors/app_exception.dart';
import 'package:faiapp/core/errors/failure.dart';
import 'package:faiapp/core/logging/app_logger.dart';
import 'package:faiapp/core/providers/core_providers.dart';
import 'package:faiapp/features/workspace/data/datasources/workspace_remote_data_source.dart';
import 'package:faiapp/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:faiapp/features/workspace/domain/entities/workspace_plan.dart';
import 'package:faiapp/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkspaceState {
  const WorkspaceState({
    required this.isSubmitting,
    this.latestPlan,
    this.errorMessage,
    this.isShowingCachedPlan = false,
  });

  const WorkspaceState.initial()
    : isSubmitting = false,
      latestPlan = null,
      errorMessage = null,
      isShowingCachedPlan = false;

  final bool isSubmitting;
  final WorkspacePlan? latestPlan;
  final String? errorMessage;
  final bool isShowingCachedPlan;

  WorkspaceState copyWith({
    bool? isSubmitting,
    WorkspacePlan? latestPlan,
    bool clearPlan = false,
    String? errorMessage,
    bool clearError = false,
    bool? isShowingCachedPlan,
  }) {
    return WorkspaceState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      latestPlan: clearPlan ? null : (latestPlan ?? this.latestPlan),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isShowingCachedPlan: isShowingCachedPlan ?? this.isShowingCachedPlan,
    );
  }
}

class WorkspaceController extends StateNotifier<WorkspaceState> {
  WorkspaceController({
    required WorkspaceRepository repository,
    required AppLogger logger,
  }) : _repository = repository,
       _logger = logger,
       super(const WorkspaceState.initial()) {
    _loadCachedPlan();
  }

  final WorkspaceRepository _repository;
  final AppLogger _logger;

  Future<void> _loadCachedPlan() async {
    final cachedPlan = await _repository.readCachedPlan();
    if (cachedPlan == null) {
      return;
    }

    state = state.copyWith(
      latestPlan: cachedPlan,
      isShowingCachedPlan: true,
      clearError: true,
    );
  }

  Future<void> generatePlan(WorkspaceDraft draft) async {
    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
      isShowingCachedPlan: false,
    );

    try {
      final plan = await _repository.generatePlan(draft);
      state = state.copyWith(
        isSubmitting: false,
        latestPlan: plan,
        clearError: true,
        isShowingCachedPlan: false,
      );
    } on AppException catch (exception, stackTrace) {
      _logger.error(
        'Workspace generation failed',
        error: exception,
        stackTrace: stackTrace,
      );
      final cachedPlan = await _repository.readCachedPlan();
      state = state.copyWith(
        isSubmitting: false,
        latestPlan: cachedPlan,
        errorMessage: cachedPlan == null
            ? Failure.fromException(exception).message
            : 'The backend request failed, so the last saved plan is shown instead.',
        isShowingCachedPlan: cachedPlan != null,
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Unexpected workspace generation failure',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Unable to generate a workspace plan right now.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final workspaceRemoteDataSourceProvider = Provider<WorkspaceRemoteDataSource>(
  (ref) => WorkspaceRemoteDataSource(ref.watch(apiClientProvider)),
);

final workspaceRepositoryProvider = Provider<WorkspaceRepository>(
  (ref) => WorkspaceRepositoryImpl(
    remoteDataSource: ref.watch(workspaceRemoteDataSourceProvider),
    cacheStoreLoader: () => ref.read(cacheStoreProvider.future),
  ),
);

final workspaceControllerProvider =
    StateNotifierProvider<WorkspaceController, WorkspaceState>(
      (ref) => WorkspaceController(
        repository: ref.watch(workspaceRepositoryProvider),
        logger: ref.watch(appLoggerProvider),
      ),
    );
