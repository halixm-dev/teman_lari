import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/strava_auth_datasource.dart';
import '../../data/datasources/token_storage.dart';
import '../../domain/usecases/strava_auth_usecase.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final stravaAuthDataSourceProvider = Provider<StravaAuthDataSource>((ref) {
  return StravaAuthDataSource(http.Client());
});

final stravaAuthUseCaseProvider = Provider<StravaAuthUseCase>((ref) {
  return StravaAuthUseCase(
    authDataSource: ref.read(stravaAuthDataSourceProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
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
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
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
