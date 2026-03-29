import 'package:atlas_ai_backend/src/common/context/request_context.dart';
import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:atlas_ai_backend/src/common/http/json_response.dart';
import 'package:atlas_ai_backend/src/common/logging/app_logger.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

Middleware errorHandlingMiddleware({
  required AppLogger logger,
  required String apiVersion,
}) {
  return (innerHandler) {
    return (request) async {
      try {
        return await innerHandler(request);
      } on ApiException catch (exception) {
        logger.warning(
          'Handled API exception',
          fields: {
            'requestId': request.requestId,
            'code': exception.code,
            'statusCode': exception.statusCode,
          },
        );
        return jsonError(
          exception: exception,
          requestId: request.requestId,
          apiVersion: apiVersion,
        );
      } on JWTExpiredException catch (exception) {
        logger.warning(
          'Expired JWT received',
          fields: {
            'requestId': request.requestId,
            'error': exception.toString(),
          },
        );
        return jsonError(
          exception: ApiException.unauthorized(
            'Your session has expired. Please sign in again.',
          ),
          requestId: request.requestId,
          apiVersion: apiVersion,
        );
      } on JWTException catch (exception) {
        logger.warning(
          'Invalid JWT received',
          fields: {
            'requestId': request.requestId,
            'error': exception.toString(),
          },
        );
        return jsonError(
          exception: ApiException.unauthorized('Invalid authentication token.'),
          requestId: request.requestId,
          apiVersion: apiVersion,
        );
      } on FormatException catch (exception) {
        logger.warning(
          'Request parsing failed',
          fields: {
            'requestId': request.requestId,
            'error': exception.toString(),
          },
        );
        return jsonError(
          exception: ApiException.badRequest(exception.message),
          requestId: request.requestId,
          apiVersion: apiVersion,
        );
      } catch (error, stackTrace) {
        logger.error(
          'Unhandled server error',
          error: error,
          stackTrace: stackTrace,
          fields: {'requestId': request.requestId},
        );
        return jsonError(
          exception: ApiException.internal(
            'An unexpected server error occurred.',
          ),
          requestId: request.requestId,
          apiVersion: apiVersion,
        );
      }
    };
  };
}
