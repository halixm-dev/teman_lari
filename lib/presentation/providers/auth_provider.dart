import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/network/strava_api_client.dart';
import '../../data/datasources/preferences_storage.dart';
import '../../data/datasources/strava_auth_datasource.dart';
import '../../data/datasources/strava_activity_datasource.dart';
import '../../data/datasources/token_storage.dart';
import '../../domain/usecases/strava_auth_usecase.dart';

// Shared HTTP client with proper disposal
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(() => client.close());
  return client;
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final stravaAuthDataSourceProvider = Provider<StravaAuthDataSource>((ref) {
  return StravaAuthDataSource(ref.read(httpClientProvider));
});

final stravaAuthUseCaseProvider = Provider<StravaAuthUseCase>((ref) {
  return StravaAuthUseCase(
    authDataSource: ref.read(stravaAuthDataSourceProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
});

final authApiClientProvider = Provider<StravaApiClient>((ref) {
  return StravaApiClient(
    ref.read(tokenStorageProvider),
    ref.read(stravaAuthDataSourceProvider),
    ref.read(httpClientProvider),
  );
});

final authAthleteDataSourceProvider = Provider<StravaActivityDataSource>((ref) {
  return StravaActivityDataSource(ref.read(authApiClientProvider));
});

final authPreferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  return PreferencesStorage();
});

final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthState.unknown();
  }

  Future<void> _checkAuthStatus() async {
    final result = await ref.read(stravaAuthUseCaseProvider).checkAuthStatus();
    state = result
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  Future<void> login() async {
    state = const AuthState.loading();
    try {
      await ref.read(stravaAuthUseCaseProvider).authenticate();
      await _syncAthleteProfile();
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> _syncAthleteProfile() async {
    try {
      final athlete =
          await ref.read(authAthleteDataSourceProvider).getAthlete();
      final storage = ref.read(authPreferencesStorageProvider);
      await storage.updateFromStrava(
        athleteMaxHr: athlete.maxHeartrate,
        athleteDateOfBirth: athlete.dateOfBirth,
      );
    } catch (_) {}
  }

  Future<void> logout() async {
    await ref.read(stravaAuthUseCaseProvider).logout();
    state = const AuthState.unauthenticated();
  }
}

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.isAuthenticated,
    required this.isLoading,
    this.error,
  });

  const AuthState.unknown()
    : isAuthenticated = false,
      isLoading = true,
      error = null;

  const AuthState.unauthenticated()
    : isAuthenticated = false,
      isLoading = false,
      error = null;

  const AuthState.loading()
    : isAuthenticated = false,
      isLoading = true,
      error = null;

  const AuthState.authenticated()
    : isAuthenticated = true,
      isLoading = false,
      error = null;

  const AuthState.error(String message)
    : isAuthenticated = false,
      isLoading = false,
      error = message;
}
