import 'dart:convert';
import 'dart:io';

import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:shared_contracts/shared_contracts.dart';
import 'package:shelf/shelf.dart';

Response jsonSuccess<T>({
  required T data,
  required Object? Function(T value) encode,
  required String requestId,
  required String apiVersion,
  int statusCode = 200,
  Map<String, String> headers = const {},
}) {
  final payload = ApiEnvelope<T>(
    data: data,
    meta: ApiMeta(
      requestId: requestId,
      timestamp: DateTime.now().toUtc(),
      apiVersion: apiVersion,
    ),
  );

  return Response(
    statusCode,
    body: jsonEncode(payload.toJson(encode)),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      'x-request-id': requestId,
      ...headers,
    },
  );
}

Response jsonError({
  required ApiException exception,
  required String requestId,
  required String apiVersion,
  Map<String, String> headers = const {},
}) {
  final payload = ApiEnvelope<void>(
    error: ApiErrorResponse(
      code: exception.code,
      message: exception.message,
      details: exception.details is Map<String, dynamic>
          ? exception.details as Map<String, dynamic>
          : exception.details == null
          ? null
          : {'raw': exception.details.toString()},
    ),
    meta: ApiMeta(
      requestId: requestId,
      timestamp: DateTime.now().toUtc(),
      apiVersion: apiVersion,
    ),
  );

  return Response(
    exception.statusCode,
    body: jsonEncode(payload.toJson((_) => null)),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      'x-request-id': requestId,
      ...headers,
    },
  );
}
