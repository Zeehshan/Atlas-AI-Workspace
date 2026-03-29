import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:faiapp/core/config/app_config.dart';
import 'package:faiapp/core/logging/app_logger.dart';
import 'package:faiapp/core/network/api_client.dart';
import 'package:faiapp/core/network/network_info.dart';
import 'package:faiapp/core/storage/cache_store.dart';
import 'package:faiapp/core/storage/session_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger());

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final sessionStorageProvider = Provider<SessionStorage>(
  (ref) => SecureSessionStorage(ref.watch(flutterSecureStorageProvider)),
);

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

final cacheStoreProvider = FutureProvider<CacheStore>((ref) async {
  final preferences = await ref.watch(sharedPreferencesProvider.future);
  return SharedPrefsCacheStore(preferences);
});

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfo(Connectivity()),
);

final connectionStatusProvider = StreamProvider<bool>(
  (ref) => ref.watch(networkInfoProvider).watchConnection(),
);

final dioProvider = Provider<Dio>((ref) => Dio());

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    dio: ref.watch(dioProvider),
    config: ref.watch(appConfigProvider),
    logger: ref.watch(appLoggerProvider),
    sessionStorage: ref.watch(sessionStorageProvider),
  ),
);
