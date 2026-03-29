import 'package:dio/dio.dart';
import 'package:faiapp/core/config/app_config.dart';
import 'package:faiapp/core/errors/app_exception.dart';
import 'package:faiapp/core/logging/app_logger.dart';
import 'package:faiapp/core/storage/session_storage.dart';

class ApiClient {
  ApiClient({
    required Dio dio,
    required AppConfig config,
    required AppLogger logger,
    required SessionStorage sessionStorage,
  }) : _dio = dio,
       _config = config,
       _logger = logger,
       _sessionStorage = sessionStorage {
    _dio.options = BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: Duration(seconds: config.requestTimeoutSeconds),
      receiveTimeout: Duration(seconds: config.requestTimeoutSeconds),
      sendTimeout: Duration(seconds: config.requestTimeoutSeconds),
      responseType: ResponseType.json,
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _handleRequest,
        onResponse: _handleResponse,
        onError: _handleError,
      ),
    );
  }

  final Dio _dio;
  final AppConfig _config;
  final AppLogger _logger;
  final SessionStorage _sessionStorage;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    return Map<String, dynamic>.from(response.data ?? const {});
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(path, data: data);
    return Map<String, dynamic>.from(response.data ?? const {});
  }

  Future<void> _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = await _sessionStorage.readSession();
    options.headers['X-Client-Environment'] = _config.environment;
    options.headers['X-Request-Id'] =
        'app-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

    if (session != null && session.accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }

    _logger.debug('${options.method} ${options.uri}');
    handler.next(options);
  }

  void _handleResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.info(
      '${response.requestOptions.method} ${response.requestOptions.path} ${response.statusCode}',
    );
    handler.next(response);
  }

  void _handleError(DioException error, ErrorInterceptorHandler handler) {
    final mapped = _mapException(error);
    _logger.error(
      'HTTP ${error.requestOptions.method} ${error.requestOptions.path} failed',
      error: mapped,
      stackTrace: error.stackTrace,
    );
    handler.reject(
      DioException(
        requestOptions: error.requestOptions,
        response: error.response,
        error: mapped,
        type: error.type,
        stackTrace: error.stackTrace,
      ),
    );
  }

  AppException _mapException(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout ||
        exception.type == DioExceptionType.sendTimeout) {
      return const AppException(
        code: 'connection_timeout',
        message: 'The request timed out before the server responded.',
      );
    }

    if (exception.type == DioExceptionType.connectionError) {
      return const AppException(
        code: 'network_error',
        message: 'Unable to reach the backend service.',
      );
    }

    final payload = exception.response?.data;
    if (payload is Map<String, dynamic>) {
      final error = payload['error'];
      if (error is Map<String, dynamic>) {
        return AppException(
          code: error['code'] as String? ?? 'request_failed',
          message: error['message'] as String? ?? 'The request failed.',
          statusCode: exception.response?.statusCode,
          details: error['details'],
        );
      }
    }

    return AppException(
      code: 'request_failed',
      message:
          'The request failed with status ${exception.response?.statusCode ?? 'unknown'}.',
      statusCode: exception.response?.statusCode,
      details: exception.response?.data,
    );
  }
}
