import 'package:faiapp/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

abstract class CrashReporter {
  Future<void> recordError(Object error, StackTrace stackTrace);

  Future<void> recordFlutterError(FlutterErrorDetails details);
}

class NoopCrashReporter implements CrashReporter {
  NoopCrashReporter(this._logger);

  final AppLogger _logger;

  @override
  Future<void> recordError(Object error, StackTrace stackTrace) async {
    _logger.warning('CrashReporter noop captured error: $error');
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    _logger.warning(
      'CrashReporter noop captured FlutterError: ${details.exception}',
    );
  }
}
