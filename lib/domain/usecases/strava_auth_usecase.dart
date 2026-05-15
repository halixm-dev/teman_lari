import '../../data/datasources/strava_auth_datasource.dart';
import '../../data/datasources/token_storage.dart';

class StravaAuthUseCase {
  final StravaAuthDataSource authDataSource;
  final TokenStorage tokenStorage;

  StravaAuthUseCase({
    required this.authDataSource,
    required this.tokenStorage,
  });

  Future<bool> checkAuthStatus() async {
    final tokens = await tokenStorage.getTokens();
    if (tokens == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return tokens.expiresAt > now;
  }

  Future<void> authenticate() async {
    final tokens = await authDataSource.authenticate();
    await tokenStorage.saveTokens(tokens);
  }

  Future<void> logout() async {
    await tokenStorage.clearTokens();
  }
}
