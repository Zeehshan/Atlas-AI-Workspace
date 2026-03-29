import 'package:atlas_ai_backend/src/auth/domain/authenticated_user.dart';
import 'package:shelf/shelf.dart';

abstract final class RequestContextKeys {
  static const requestId = 'requestId';
  static const authenticatedUser = 'authenticatedUser';
}

extension RequestContextX on Request {
  String get requestId =>
      context[RequestContextKeys.requestId] as String? ?? 'request-unknown';

  AuthenticatedUser? get authenticatedUser =>
      context[RequestContextKeys.authenticatedUser] as AuthenticatedUser?;
}
