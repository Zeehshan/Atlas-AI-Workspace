import 'package:shared_contracts/shared_contracts.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.roles,
  });

  final String id;
  final String email;
  final String displayName;
  final List<String> roles;

  factory AuthUser.fromDto(UserProfile dto) {
    return AuthUser(
      id: dto.id,
      email: dto.email,
      displayName: dto.displayName,
      roles: dto.roles,
    );
  }
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresAt,
    required this.refreshTokenExpiresAt,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpiresAt;
  final DateTime refreshTokenExpiresAt;
  final AuthUser user;

  bool get isAccessTokenExpired =>
      accessTokenExpiresAt.isBefore(DateTime.now().toUtc());

  bool get canRefresh => refreshTokenExpiresAt.isAfter(DateTime.now().toUtc());

  factory AuthSession.fromDto(AuthTokensResponse dto) {
    return AuthSession(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      accessTokenExpiresAt: dto.accessTokenExpiresAt,
      refreshTokenExpiresAt: dto.refreshTokenExpiresAt,
      user: AuthUser.fromDto(dto.user),
    );
  }
}
