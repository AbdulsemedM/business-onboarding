import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Signed-in session: tokens and the onboarding application being filled in.
class Session {
  const Session({
    required this.accessToken,
    required this.refreshToken,
    this.applicationId,
  });

  final String accessToken;
  final String refreshToken;

  /// Null until the account has an application (register creates one; an
  /// account without one is asked for a business name).
  final String? applicationId;
}

/// Where the session is kept. Values are secrets: never log them.
abstract interface class SessionStore {
  Future<Session?> read();
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> writeApplicationId(String applicationId);

  /// Call on logout or when the session can't be refreshed.
  Future<void> clear();
}

/// Keeps the session in the platform keystore / keychain.
class SecureSessionStore implements SessionStore {
  SecureSessionStore(this._storage);

  static const _access = 'access_token';
  static const _refresh = 'refresh_token';
  static const _application = 'application_id';

  final FlutterSecureStorage _storage;

  // Reads are frequent (every request), so the values are cached.
  Session? _cache;
  bool _loaded = false;

  @override
  Future<Session?> read() async {
    if (_loaded) return _cache;
    final access = await _storage.read(key: _access);
    final refresh = await _storage.read(key: _refresh);
    final application = await _storage.read(key: _application);
    _cache = access == null || refresh == null
        ? null
        : Session(
            accessToken: access,
            refreshToken: refresh,
            applicationId: application,
          );
    _loaded = true;
    return _cache;
  }

  @override
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _access, value: accessToken);
    await _storage.write(key: _refresh, value: refreshToken);
    final previous = await read();
    _cache = Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      applicationId: previous?.applicationId,
    );
  }

  @override
  Future<void> writeApplicationId(String applicationId) async {
    await _storage.write(key: _application, value: applicationId);
    final current = await read();
    if (current != null) {
      _cache = Session(
        accessToken: current.accessToken,
        refreshToken: current.refreshToken,
        applicationId: applicationId,
      );
    }
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _access);
    await _storage.delete(key: _refresh);
    await _storage.delete(key: _application);
    _cache = null;
    _loaded = true;
  }
}

/// For tests and the offline mock mode.
class InMemorySessionStore implements SessionStore {
  InMemorySessionStore([this.session]);

  Session? session;

  @override
  Future<Session?> read() async => session;

  @override
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async => session = Session(
    accessToken: accessToken,
    refreshToken: refreshToken,
    applicationId: session?.applicationId,
  );

  @override
  Future<void> writeApplicationId(String applicationId) async {
    final current = session;
    if (current == null) return;
    session = Session(
      accessToken: current.accessToken,
      refreshToken: current.refreshToken,
      applicationId: applicationId,
    );
  }

  @override
  Future<void> clear() async => session = null;
}
