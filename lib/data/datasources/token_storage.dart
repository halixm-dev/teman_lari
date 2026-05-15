import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/strava_tokens.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(StravaTokens tokens) async {
    await _storage.write(key: 'access_token', value: tokens.accessToken);
    await _storage.write(key: 'refresh_token', value: tokens.refreshToken);
    await _storage.write(
        key: 'expires_at', value: tokens.expiresAt.toString());
  }

  Future<StravaTokens?> getTokens() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    final expiresAt = await _storage.read(key: 'expires_at');
    if (accessToken == null) return null;
    return StravaTokens(
      accessToken: accessToken,
      refreshToken: refreshToken!,
      expiresAt: int.parse(expiresAt!),
    );
  }

  Future<void> clearTokens() async => _storage.deleteAll();
}
