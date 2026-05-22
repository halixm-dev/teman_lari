import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/strava_tokens.dart';

class TokenStorage {
  Future<void> saveTokens(StravaTokens tokens) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', tokens.accessToken);
      await prefs.setString('refresh_token', tokens.refreshToken);
      await prefs.setString('expires_at', tokens.expiresAt.toString());
    } else {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'access_token', value: tokens.accessToken);
      await storage.write(key: 'refresh_token', value: tokens.refreshToken);
      await storage.write(key: 'expires_at', value: tokens.expiresAt.toString());
    }
  }

  Future<StravaTokens?> getTokens() async {
    String? accessToken;
    String? refreshToken;
    String? expiresAt;

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('access_token');
      refreshToken = prefs.getString('refresh_token');
      expiresAt = prefs.getString('expires_at');
    } else {
      const storage = FlutterSecureStorage();
      accessToken = await storage.read(key: 'access_token');
      refreshToken = await storage.read(key: 'refresh_token');
      expiresAt = await storage.read(key: 'expires_at');
    }

    if (accessToken == null || refreshToken == null || expiresAt == null) return null;
    return StravaTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: int.parse(expiresAt),
    );
  }

  Future<void> clearTokens() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('expires_at');
    } else {
      const storage = FlutterSecureStorage();
      await storage.deleteAll();
    }
  }
}
