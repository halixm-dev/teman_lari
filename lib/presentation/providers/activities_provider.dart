import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/network/strava_api_client.dart';
import '../../data/datasources/local_activity_datasource.dart';
import '../../data/datasources/strava_activity_datasource.dart';
import '../../data/repositories/activity_repository_impl.dart';
import '../../domain/entities/run_activity.dart';
import '../../domain/entities/running_stats.dart';
import '../../domain/entities/training_plan.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/usecases/analyze_runs_usecase.dart';
import '../../domain/usecases/generate_plan_usecase.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import 'auth_provider.dart';

final stravaApiClientProvider = Provider<StravaApiClient>((ref) {
  return StravaApiClient(
    ref.read(tokenStorageProvider),
    ref.read(stravaAuthDataSourceProvider),
    http.Client(),
  );
});

final stravaActivityDataSourceProvider = Provider<StravaActivityDataSource>((ref) {
  return StravaActivityDataSource(ref.read(stravaApiClientProvider));
});

final localActivityDataSourceProvider = Provider<LocalActivityDataSource>((ref) {
  return LocalActivityDataSource();
});

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepositoryImpl(
    remoteDataSource: ref.read(stravaActivityDataSourceProvider),
    localDataSource: ref.read(localActivityDataSourceProvider),
  );
});

final getActivitiesUseCaseProvider = Provider<GetActivitiesUseCase>((ref) {
  return GetActivitiesUseCase(ref.read(activityRepositoryProvider));
});

final analyzeRunsUseCaseProvider = Provider<AnalyzeRunsUseCase>((ref) {
  return AnalyzeRunsUseCase();
});

final generatePlanUseCaseProvider = Provider<GeneratePlanUseCase>((ref) {
  return GeneratePlanUseCase();
});

final activitiesProvider =
    AsyncNotifierProvider<ActivitiesNotifier, List<RunActivity>>(
        () => ActivitiesNotifier());

class ActivitiesNotifier extends AsyncNotifier<List<RunActivity>> {
  @override
  Future<List<RunActivity>> build() async {
    return ref.read(getActivitiesUseCaseProvider).execute(monthsBack: 12);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(getActivitiesUseCaseProvider).execute(monthsBack: 12));
  }
}

final runningStatsProvider = Provider<RunningStats?>((ref) {
  final activities = ref.watch(activitiesProvider);
  return activities.whenOrNull(
    data: (data) => ref.read(analyzeRunsUseCaseProvider).compute(data),
  );
});

final trainingPlanProvider = FutureProvider<TrainingPlan>((ref) async {
  final activities = await ref.watch(activitiesProvider.future);
  return ref.read(generatePlanUseCaseProvider).generate(activities);
});
