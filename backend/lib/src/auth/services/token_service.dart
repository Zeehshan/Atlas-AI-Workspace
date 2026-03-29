import 'dart:convert';

import 'package:atlas_ai_backend/src/auth/domain/authenticated_user.dart';
import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:atlas_ai_backend/src/config/environment.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_contracts/shared_contracts.dart';

class TokenService {
  const TokenService(this._environment);

  final Environment _environment;

  AuthTokensResponse issueTokens(AuthenticatedUser user) {
    final now = DateTime.now().toUtc();
    final accessExpiresAt = now.add(const Duration(minutes: 15));
    final refreshExpiresAt = now.add(const Duration(days: 7));

    final accessToken = _signToken(
      user: user,
      type: 'access',
      expiresAt: accessExpiresAt,
      secret: _environment.jwtSecret,
    );

    final refreshToken = _signToken(
      user: user,
      type: 'refresh',
      expiresAt: refreshExpiresAt,
      secret: _environment.jwtRefreshSecret,
    );

    return AuthTokensResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresAt: accessExpiresAt,
      refreshTokenExpiresAt: refreshExpiresAt,
      user: user.toUserProfile(),
    );
  }

  AuthenticatedUser verifyAccessToken(String token) {
    return _verifyToken(
      token: token,
      expectedType: 'access',
      secret: _environment.jwtSecret,
    );
  }

  AuthenticatedUser verifyRefreshToken(String token) {
    return _verifyToken(
      token: token,
      expectedType: 'refresh',
      secret: _environment.jwtRefreshSecret,
    );
  }

  String _signToken({
    required AuthenticatedUser user,
    required String type,
    required DateTime expiresAt,
    required String secret,
  }) {
    final token = JWT({
      'sub': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'roles': user.roles,
      'sessionId': user.sessionId,
      'type': type,
      'iss': _environment.jwtIssuer,
      'aud': _environment.jwtAudience,
    });

    return token.sign(
      SecretKey(secret),
      expiresIn: expiresAt.difference(DateTime.now().toUtc()),
    );
  }

  AuthenticatedUser _verifyToken({
    required String token,
    required String expectedType,
    required String secret,
  }) {
    final verified = JWT.verify(token, SecretKey(secret));
    final payload = Map<String, dynamic>.from(verified.payload as Map);

    if (payload['type'] != expectedType) {
      throw ApiException.unauthorized('Unexpected token type.');
    }
    if (payload['iss'] != _environment.jwtIssuer) {
      throw ApiException.unauthorized('Token issuer mismatch.');
    }
    if (payload['aud'] != _environment.jwtAudience) {
      throw ApiException.unauthorized('Token audience mismatch.');
    }

    return AuthenticatedUser(
      id: payload['sub'] as String? ?? '',
      email: payload['email'] as String? ?? '',
      displayName: payload['displayName'] as String? ?? '',
      roles: (payload['roles'] as List<dynamic>? ?? const [])
          .map((item) => item as String)
          .toList(growable: false),
      sessionId: payload['sessionId'] as String? ?? _sessionIdFallback(token),
    );
  }

  String _sessionIdFallback(String token) {
    final digest = sha256.convert(utf8.encode(token));
    return 'sess-${digest.toString().substring(0, 16)}';
  }
}
