import 'package:atlas_ai_backend/src/common/context/request_context.dart';
import 'package:atlas_ai_backend/src/common/logging/app_logger.dart';
import 'package:shelf/shelf.dart';

Middleware requestLoggingMiddleware(AppLogger logger) {
  return (innerHandler) {
    return (request) async {
      final stopwatch = Stopwatch()..start();
      final response = await innerHandler(request);
      stopwatch.stop();

      logger.info(
        'Request completed',
        fields: {
          'requestId': request.requestId,
          'method': request.method,
          'path': request.requestedUri.path,
          'statusCode': response.statusCode,
          'latencyMs': stopwatch.elapsedMilliseconds,
          if (request.authenticatedUser case final user?) 'userId': user.id,
        },
      );

      return response;
    };
  };
}
