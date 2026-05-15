import '../../core/constants/api_constants.dart';
import '../../data/datasources/strava_auth_datasource.dart';
import '../../data/datasources/token_storage.dart';
import '../../data/models/strava_tokens.dart';

class StravaAuthUseCase {
  final StravaAuthDataSource authDataSource;
  final TokenStorage tokenStorage;

  StravaAuthUseCase({
    required this.authDataSource,
    required this.tokenStorage,
  });

  Future<bool> checkAuthStatus() async {
    var tokens = await tokenStorage.getTokens();

    tokens ??= await _seedPreconfiguredTokens();

    if (tokens == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (tokens.expiresAt > now) {
      return true;
    }

    try {
      final newTokens = await authDataSource.refreshToken(tokens.refreshToken);
      await tokenStorage.saveTokens(newTokens);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<StravaTokens?> _seedPreconfiguredTokens() async {
    final accessToken = ApiConstants.stravaAccessToken;
    final refreshToken = ApiConstants.stravaRefreshToken;

    if (accessToken.isEmpty || refreshToken.isEmpty) return null;

    final tokens = StravaTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: 0,
    );

    await tokenStorage.saveTokens(tokens);
    return tokens;
  }

  Future<void> authenticate() async {
    final tokens = await authDataSource.authenticate();
    await tokenStorage.saveTokens(tokens);
  }

  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }
}
