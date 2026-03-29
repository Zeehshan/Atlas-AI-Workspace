class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details,
  });

  final int statusCode;
  final String code;
  final String message;
  final Object? details;

  factory ApiException.badRequest(String message, {Object? details}) {
    return ApiException(
      statusCode: 400,
      code: 'bad_request',
      message: message,
      details: details,
    );
  }

  factory ApiException.unauthorized(String message, {Object? details}) {
    return ApiException(
      statusCode: 401,
      code: 'unauthorized',
      message: message,
      details: details,
    );
  }

  factory ApiException.forbidden(String message, {Object? details}) {
    return ApiException(
      statusCode: 403,
      code: 'forbidden',
      message: message,
      details: details,
    );
  }

  factory ApiException.notFound(String message, {Object? details}) {
    return ApiException(
      statusCode: 404,
      code: 'not_found',
      message: message,
      details: details,
    );
  }

  factory ApiException.gatewayTimeout(String message, {Object? details}) {
    return ApiException(
      statusCode: 504,
      code: 'gateway_timeout',
      message: message,
      details: details,
    );
  }

  factory ApiException.serviceUnavailable(String message, {Object? details}) {
    return ApiException(
      statusCode: 503,
      code: 'service_unavailable',
      message: message,
      details: details,
    );
  }

  factory ApiException.internal(String message, {Object? details}) {
    return ApiException(
      statusCode: 500,
      code: 'internal_error',
      message: message,
      details: details,
    );
  }
}
