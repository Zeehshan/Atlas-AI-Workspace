class AppException implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Object? details;

  bool get isUnauthorized =>
      statusCode == 401 || code == 'unauthorized' || code == 'unauthenticated';

  bool get isNetworkError =>
      code == 'network_error' ||
      code == 'connection_timeout' ||
      code == 'no_connection';

  @override
  String toString() => 'AppException($code, $message, $statusCode)';
}
