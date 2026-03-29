import 'package:atlas_ai_backend/src/auth/services/token_service.dart';
import 'package:atlas_ai_backend/src/common/context/request_context.dart';
import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:shelf/shelf.dart';

Middleware bearerAuthMiddleware(TokenService tokenService) {
  return (innerHandler) {
    return (request) {
      final header = request.headers['authorization'];
      if (header == null || !header.startsWith('Bearer ')) {
        throw ApiException.unauthorized('Missing bearer token.');
      }

      final token = header.substring(7).trim();
      if (token.isEmpty) {
        throw ApiException.unauthorized('Missing bearer token.');
      }

      final user = tokenService.verifyAccessToken(token);
      return innerHandler(
        request.change(
          context: {
            ...request.context,
            RequestContextKeys.authenticatedUser: user,
          },
        ),
      );
    };
  };
}
