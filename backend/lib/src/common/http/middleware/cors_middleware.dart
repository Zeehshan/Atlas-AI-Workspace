import 'package:atlas_ai_backend/src/config/server_config.dart';
import 'package:shelf/shelf.dart';

Middleware corsMiddleware(ServerConfig config) {
  return (innerHandler) {
    return (request) async {
      final origin = request.headers['origin'] ?? '*';
      final allowOrigin =
          config.corsAllowedOrigins.contains('*') ||
              config.corsAllowedOrigins.contains(origin)
          ? origin
          : config.corsAllowedOrigins.first;

      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders(allowOrigin));
      }

      final response = await innerHandler(request);
      return response.change(
        headers: {...response.headers, ..._corsHeaders(allowOrigin)},
      );
    };
  };
}

Map<String, String> _corsHeaders(String allowOrigin) {
  return {
    'access-control-allow-origin': allowOrigin,
    'access-control-allow-methods': 'GET,POST,OPTIONS',
    'access-control-allow-headers':
        'Content-Type, Authorization, X-Request-Id, X-Client-Environment',
  };
}
