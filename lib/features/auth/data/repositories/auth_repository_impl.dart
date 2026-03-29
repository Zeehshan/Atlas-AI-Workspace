import 'package:faiapp/core/storage/session_storage.dart';
import 'package:faiapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faiapp/features/auth/domain/entities/auth_session.dart';
import 'package:faiapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SessionStorage sessionStorage,
  }) : _remoteDataSource = remoteDataSource,
       _sessionStorage = sessionStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SessionStorage _sessionStorage;

  @override
  Future<AuthSession?> restoreSession() async {
    final stored = await _sessionStorage.readSession();
    return stored == null ? null : AuthSession.fromDto(stored);
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.signIn(
      email: email,
      password: password,
    );
    await _sessionStorage.writeSession(response);
    return AuthSession.fromDto(response);
  }

  @override
  Future<AuthSession> refreshSession(String refreshToken) async {
    final response = await _remoteDataSource.refresh(refreshToken);
    await _sessionStorage.writeSession(response);
    return AuthSession.fromDto(response);
  }

  @override
  Future<void> signOut() => _sessionStorage.clearSession();
}
