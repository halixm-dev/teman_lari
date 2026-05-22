import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'domain/entities/activity.dart';
import 'main.dart';
import 'presentation/providers/activities_provider.dart';
import 'presentation/providers/auth_provider.dart';

/// A mock version of the AuthNotifier that starts already authenticated.
class MockAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.authenticated();
  }

  @override
  Future<void> login() async {
    state = const AuthState.authenticated();
  }

  @override
  Future<void> logout() async {
    state = const AuthState.unauthenticated();
  }
}

/// A mock version of ActivitiesNotifier that returns fake activity data.
class MockActivitiesNotifier extends ActivitiesNotifier {
  @override
  Future<List<Activity>> build() async {
    return _generateMockActivities();
  }

  @override
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    state = AsyncValue.data(_generateMockActivities());
  }

  List<Activity> _generateMockActivities() {
    final now = DateTime.now();
    return [
      Activity(
        id: 1,
        name: 'Mock Easy Run',
        date: now.subtract(const Duration(days: 1)),
        type: ActivityType.run,
        distanceKm: 5.0,
        movingTime: const Duration(minutes: 30),
        pace: const Duration(minutes: 6),
        elevationGainM: 20,
        trainingLoad: TrainingLoad.easy,
        avgHeartRate: 130,
        maxHeartRate: 145,
      ),
      Activity(
        id: 2,
        name: 'Mock Hard Workout',
        date: now.subtract(const Duration(days: 3)),
        type: ActivityType.run,
        distanceKm: 10.0,
        movingTime: const Duration(minutes: 50),
        pace: const Duration(minutes: 5),
        elevationGainM: 100,
        trainingLoad: TrainingLoad.hard,
        avgHeartRate: 165,
        maxHeartRate: 185,
      ),
      Activity(
        id: 3,
        name: 'Mock Long Run',
        date: now.subtract(const Duration(days: 7)),
        type: ActivityType.run,
        distanceKm: 15.0,
        movingTime: const Duration(minutes: 90),
        pace: const Duration(minutes: 6),
        elevationGainM: 150,
        trainingLoad: TrainingLoad.moderate,
        avgHeartRate: 145,
        maxHeartRate: 160,
      ),
    ];
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    ProviderScope(
      overrides: [
        // Override Auth to bypass the login screen
        authProvider.overrideWith(() => MockAuthNotifier()),
        // Override Activities with fake runs to generate mock stats and plans
        activitiesProvider.overrideWith(() => MockActivitiesNotifier()),
      ],
      child: const TemanLariApp(),
    ),
  );
}
