import 'dart:convert';

import 'package:atlas_ai_backend/src/common/errors/api_exception.dart';
import 'package:shelf/shelf.dart';

Future<Map<String, dynamic>> readJsonBody(Request request) async {
  final rawBody = await request.readAsString();
  if (rawBody.trim().isEmpty) {
    return <String, dynamic>{};
  }

  final decoded = jsonDecode(rawBody);
  if (decoded is! Map<String, dynamic>) {
    throw ApiException.badRequest('Request body must be a JSON object.');
  }

  return decoded;
}
