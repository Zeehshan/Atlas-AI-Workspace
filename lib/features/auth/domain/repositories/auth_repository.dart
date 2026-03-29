import 'package:faiapp/features/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> restoreSession();

  Future<AuthSession> signIn({required String email, required String password});

  Future<AuthSession> refreshSession(String refreshToken);

  Future<void> signOut();
}
