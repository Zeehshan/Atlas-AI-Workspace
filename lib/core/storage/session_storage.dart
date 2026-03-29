import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_contracts/shared_contracts.dart';

abstract class SessionStorage {
  Future<AuthTokensResponse?> readSession();

  Future<void> writeSession(AuthTokensResponse session);

  Future<void> clearSession();
}

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage(this._storage);

  static const _sessionKey = 'auth_session';

  final FlutterSecureStorage _storage;

  @override
  Future<AuthTokensResponse?> readSession() async {
    final rawJson = await _storage.read(key: _sessionKey);
    if (rawJson == null || rawJson.isEmpty) {
      return null;
    }

    return AuthTokensResponse.fromJson(
      jsonDecode(rawJson) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> writeSession(AuthTokensResponse session) {
    return _storage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  @override
  Future<void> clearSession() => _storage.delete(key: _sessionKey);
}
