import 'package:atlas_ai_backend/src/auth/domain/authenticated_user.dart';
import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:atlas_ai_backend/src/config/environment.dart';

class BootstrapAuthService {
  const BootstrapAuthService(this._environment);

  final Environment _environment;

  AuthenticatedUser authenticate({
    required String email,
    required String password,
  }) {
    if (email.trim().toLowerCase() !=
            _environment.bootstrapAdminEmail.toLowerCase() ||
        password != _environment.bootstrapAdminPassword) {
      throw ApiException.unauthorized('Invalid email or password.');
    }

    return AuthenticatedUser(
      id: _environment.bootstrapUserId,
      email: _environment.bootstrapAdminEmail,
      displayName: _environment.bootstrapDisplayName,
      roles: _environment.bootstrapRoles,
      sessionId:
          'sess-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}',
    );
  }
}
