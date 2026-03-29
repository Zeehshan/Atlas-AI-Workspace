import 'package:atlas_ai_backend/src/common/context/request_context.dart';
import 'package:shelf/shelf.dart';

Middleware correlationIdMiddleware() {
  return (innerHandler) {
    return (request) {
      final requestId =
          request.headers['x-request-id'] ??
          'req-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

      return innerHandler(
        request.change(
          context: {
            ...request.context,
            RequestContextKeys.requestId: requestId,
          },
        ),
      );
    };
  };
}
