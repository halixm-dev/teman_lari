import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/usecases/strava_auth_usecase.dart';
import 'core_provider.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
StravaAuthUseCase stravaAuthUseCase(Ref ref) {
  return StravaAuthUseCase(
    authDataSource: ref.read(stravaAuthDataSourceProvider),
    tokenStorage: ref.read(tokenStorageProvider),
  );
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
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
    } catch (e, stack) {
      log('Login failed', name: 'AuthNotifier', error: e, stackTrace: stack);
      state = AuthState.error(e.toString());
    }
  }

  Future<void> _syncAthleteProfile() async {
    try {
      final athlete = await ref
          .read(stravaActivityDataSourceProvider)
          .getAthlete();
      final storage = ref.read(preferencesStorageProvider);
      final name = [
        if (athlete.firstName != null) athlete.firstName,
        if (athlete.lastName != null) athlete.lastName,
      ].join(' ');
      await storage.updateFromStrava(
        athleteMaxHr: athlete.maxHeartrate,
        athleteDateOfBirth: athlete.dateOfBirth,
        athleteName: name.isNotEmpty ? name : null,
      );
    } catch (e, stack) {
      log(
        'Profile sync failed',
        name: 'AuthNotifier',
        error: e,
        stackTrace: stack,
      );
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
