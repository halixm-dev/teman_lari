import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/strava_api_client.dart';
import '../../data/datasources/local_activity_datasource.dart';
import '../../data/datasources/preferences_storage.dart';
import '../../data/datasources/strava_activity_datasource.dart';
import '../../data/repositories/activity_repository_impl.dart';
import '../../domain/entities/run_activity.dart';
import '../../domain/entities/running_stats.dart';
import '../../domain/entities/training_plan.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/usecases/analyze_runs_usecase.dart';
import '../../domain/usecases/generate_plan_usecase.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import '../../domain/usecases/training_plan_config.dart';
import '../../domain/usecases/workout_descriptions.dart';
import '../../domain/usecases/workout_sequence_strategy.dart';
import 'auth_provider.dart';

final stravaApiClientProvider = Provider<StravaApiClient>((ref) {
  return StravaApiClient(
    ref.read(tokenStorageProvider),
    ref.read(stravaAuthDataSourceProvider),
    ref.read(httpClientProvider),
  );
});

final stravaActivityDataSourceProvider = Provider<StravaActivityDataSource>((
  ref,
) {
  return StravaActivityDataSource(ref.read(stravaApiClientProvider));
});

final localActivityDataSourceProvider = Provider<LocalActivityDataSource>((
  ref,
) {
  return LocalActivityDataSource();
});

final preferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  return PreferencesStorage();
});

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepositoryImpl(
    remoteDataSource: ref.read(stravaActivityDataSourceProvider),
    localDataSource: ref.read(localActivityDataSourceProvider),
    preferencesStorage: ref.read(preferencesStorageProvider),
  );
});

final getActivitiesUseCaseProvider = Provider<GetActivitiesUseCase>((ref) {
  return GetActivitiesUseCase(ref.read(activityRepositoryProvider));
});

final analyzeRunsUseCaseProvider = Provider<AnalyzeRunsUseCase>((ref) {
  return AnalyzeRunsUseCase();
});

final trainingPlanConfigProvider = Provider<TrainingPlanConfig>((ref) {
  return TrainingPlanConfig.defaultConfig;
});

final workoutSequenceStrategyProvider = Provider<WorkoutSequenceStrategy>((
  ref,
) {
  return const DynamicWorkoutSequenceStrategy();
});

final workoutDescriptionsProvider = Provider<WorkoutDescriptions>((ref) {
  return const WorkoutDescriptions();
});

final generatePlanUseCaseProvider = Provider<GeneratePlanUseCase>((ref) {
  return GeneratePlanUseCase(
    analyzeRuns: ref.read(analyzeRunsUseCaseProvider),
    config: ref.read(trainingPlanConfigProvider),
    sequenceStrategy: ref.read(workoutSequenceStrategyProvider),
    descriptions: ref.read(workoutDescriptionsProvider),
  );
});

final activitiesProvider =
    AsyncNotifierProvider<ActivitiesNotifier, List<RunActivity>>(
      () => ActivitiesNotifier(),
    );

class ActivitiesNotifier extends AsyncNotifier<List<RunActivity>> {
  @override
  Future<List<RunActivity>> build() async {
    return ref.read(getActivitiesUseCaseProvider).execute(monthsBack: 12);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final runningStatsProvider = FutureProvider<RunningStats?>((ref) async {
  final activities = await ref.watch(activitiesProvider.future);
  final prefs = await ref.read(preferencesStorageProvider).getPreferences();
  final repo = ref.read(activityRepositoryProvider);
  final sortedActivities = [...activities]..sort((a, b) => b.date.compareTo(a.date));
  final withHrIds = sortedActivities
      .where((a) => a.avgHeartRate != null)
      .map((a) => a.id)
      .take(50)
      .toList();

  List<RunActivity> target;
  if (withHrIds.isNotEmpty) {
    final streams = await repo.getHeartRateStreams(withHrIds);
    target = activities.map((a) {
      if (a.avgHeartRate == null) return a;
      final hrData = streams[a.id];
      if (hrData == null) return a;
      return RunActivity(
        id: a.id,
        name: a.name,
        date: a.date,
        distanceKm: a.distanceKm,
        movingTime: a.movingTime,
        pace: a.pace,
        elevationGainM: a.elevationGainM,
        trainingLoad: a.trainingLoad,
        avgHeartRate: a.avgHeartRate,
        maxHeartRate: a.maxHeartRate,
        avgCadence: a.avgCadence,
        sufferScore: a.sufferScore,
        heartRateData: hrData,
      );
    }).toList();
  } else {
    target = activities;
  }

  final useCase = ref.read(analyzeRunsUseCaseProvider);
  final stats = useCase.compute(
    target,
    userMaxHr: prefs.maxHr,
    userRestingHr: prefs.restingHr,
  );

  final activityMaxHr = target
      .where((a) => a.maxHeartRate != null)
      .map((a) => a.maxHeartRate!)
      .fold<double?>(null, (max, hr) => max == null ? hr : (hr > max ? hr : max));

  if (activityMaxHr != null) {
    await ref.read(preferencesStorageProvider).updateFromStrava(
      activityMaxHr: activityMaxHr.round(),
    );
  }

  return stats;
});

final trainingPlanProvider = FutureProvider<TrainingPlan>((ref) async {
  final activities = await ref.watch(activitiesProvider.future);
  final weekInCycle = await ref.watch(weekInCycleProvider.future);
  return ref.read(generatePlanUseCaseProvider).generate(
    activities,
    weekInCycle: weekInCycle,
  );
});

final weekInCycleProvider = FutureProvider<int>((ref) async {
  final prefs = ref.read(preferencesStorageProvider);
  return prefs.getWeekInCycle();
});

final cycleStartDateProvider = FutureProvider<DateTime>((ref) async {
  final prefs = ref.read(preferencesStorageProvider);
  return prefs.getCycleStartDate();
});

final athleteNameProvider = FutureProvider<String?>((ref) async {
  return ref.read(preferencesStorageProvider).getAthleteName();
});
