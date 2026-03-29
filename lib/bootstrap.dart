import 'dart:async';

import 'package:faiapp/app/app.dart';
import 'package:faiapp/core/logging/app_logger.dart';
import 'package:faiapp/core/observability/crash_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = AppLogger();
  final crashReporter = NoopCrashReporter(logger);

  FlutterError.onError = (details) {
    logger.error(
      'Uncaught Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
    );
    crashReporter.recordFlutterError(details);
  };

  runZonedGuarded(
    () {
      runApp(
        ProviderScope(
          observers: [AppProviderObserver(logger)],
          child: const AtlasAiApp(),
        ),
      );
    },
    (error, stackTrace) {
      logger.error('Uncaught zone error', error: error, stackTrace: stackTrace);
      crashReporter.recordError(error, stackTrace);
    },
  );
}

class AppProviderObserver extends ProviderObserver {
  AppProviderObserver(this._logger);

  final AppLogger _logger;

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _logger.error(
      'Provider failure: ${provider.name ?? provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (!kDebugMode) {
      return;
    }

    _logger.debug('Provider updated: ${provider.name ?? provider.runtimeType}');
  }
}
