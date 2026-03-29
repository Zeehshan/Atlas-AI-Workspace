import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';

class AppLogger {
  AppLogger({required bool verbose, String name = 'atlas-ai-backend'})
    : _logger = Logger(name) {
    _configure(verbose);
  }

  static bool _configured = false;
  final Logger _logger;

  void info(String message, {Map<String, Object?> fields = const {}}) {
    _logger.info(_buildMessage(message, fields));
  }

  void warning(String message, {Map<String, Object?> fields = const {}}) {
    _logger.warning(_buildMessage(message, fields));
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> fields = const {},
  }) {
    _logger.severe(_buildMessage(message, fields), error, stackTrace);
  }

  static void _configure(bool verbose) {
    if (_configured) {
      return;
    }

    hierarchicalLoggingEnabled = true;
    Logger.root.level = verbose ? Level.ALL : Level.INFO;
    Logger.root.onRecord.listen((record) {
      final payload = <String, Object?>{
        'level': record.level.name,
        'logger': record.loggerName,
        'timestamp': record.time.toUtc().toIso8601String(),
        'message': record.message,
        if (record.error case final value?) 'error': value.toString(),
        if (record.stackTrace case final value?) 'stackTrace': value.toString(),
      };
      stdout.writeln(jsonEncode(payload));
    });
    _configured = true;
  }

  String _buildMessage(String message, Map<String, Object?> fields) {
    if (fields.isEmpty) {
      return message;
    }

    return jsonEncode({'message': message, 'fields': fields});
  }
}
