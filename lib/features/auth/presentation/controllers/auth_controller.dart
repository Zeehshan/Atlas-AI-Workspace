import 'package:faiapp/core/errors/app_exception.dart';
import 'package:faiapp/core/errors/failure.dart';
import 'package:faiapp/core/logging/app_logger.dart';
import 'package:faiapp/core/providers/core_providers.dart';
import 'package:faiapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faiapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:faiapp/features/auth/domain/entities/auth_session.dart';
import 'package:faiapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({
    required this.isBootstrapping,
    required this.isAuthenticating,
    this.session,
    this.errorMessage,
  });

  const AuthState.initial()
    : isBootstrapping = true,
      isAuthenticating = false,
      session = null,
      errorMessage = null;

  final bool isBootstrapping;
  final bool isAuthenticating;
  final AuthSession? session;
  final String? errorMessage;

  bool get isAuthenticated => session != null;

  AuthState copyWith({
    bool? isBootstrapping,
    bool? isAuthenticating,
    AuthSession? session,
    bool clearSession = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isBootstrapping: isBootstrapping ?? this.isBootstrapping,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      session: clearSession ? null : (session ?? this.session),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository repository,
    required AppLogger logger,
  }) : _repository = repository,
       _logger = logger,
       super(const AuthState.initial()) {
    _bootstrap();
  }

  final AuthRepository _repository;
  final AppLogger _logger;

  Future<void> _bootstrap() async {
    try {
      final session = await _repository.restoreSession();
      if (session != null &&
          session.isAccessTokenExpired &&
          session.canRefresh) {
        final refreshed = await _repository.refreshSession(
          session.refreshToken,
        );
        state = state.copyWith(
          isBootstrapping: false,
          session: refreshed,
          clearError: true,
        );
        return;
      }

      state = state.copyWith(
        isBootstrapping: false,
        session: session?.isAccessTokenExpired == true ? null : session,
        clearError: true,
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to bootstrap auth session',
        error: error,
        stackTrace: stackTrace,
      );
      await _repository.signOut();
      state = state.copyWith(
        isBootstrapping: false,
        clearSession: true,
        errorMessage: 'Please sign in to continue.',
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isAuthenticating: true, clearError: true);

    try {
      final session = await _repository.signIn(
        email: email,
        password: password,
      );
      state = state.copyWith(
        isAuthenticating: false,
        session: session,
        clearError: true,
      );
    } on AppException catch (exception, stackTrace) {
      _logger.error('Sign in failed', error: exception, stackTrace: stackTrace);
      state = state.copyWith(
        isAuthenticating: false,
        errorMessage: Failure.fromException(exception).message,
      );
    } catch (error, stackTrace) {
      _logger.error(
        'Unexpected sign in failure',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isAuthenticating: false,
        errorMessage: 'Unable to sign in right now.',
      );
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = state.copyWith(clearSession: true, clearError: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    sessionStorage: ref.watch(sessionStorageProvider),
  ),
);

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(
    repository: ref.watch(authRepositoryProvider),
    logger: ref.watch(appLoggerProvider),
  ),
);
