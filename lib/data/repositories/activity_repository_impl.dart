import 'dart:async';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/run_activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/local_activity_datasource.dart';
import '../datasources/preferences_storage.dart';
import '../datasources/strava_activity_datasource.dart';
import '../models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final StravaActivityDataSource remoteDataSource;
  final LocalActivityDataSource localDataSource;
  final PreferencesStorage preferencesStorage;

  ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.preferencesStorage,
  });

  @override
  Future<List<RunActivity>> getAllRunningActivities({
    int monthsBack = 12,
  }) async {
    final prefs = await preferencesStorage.getPreferences();
    final maxHr = prefs.maxHr ?? 190;

    try {
      final cached = await localDataSource.getCachedActivities();
      if (cached != null) {
        return _mapModelsToEntities(cached, maxHr: maxHr);
      }
    } catch (_) {}

    try {
      final remoteActivities = await remoteDataSource.getAllRunningActivities(
        monthsBack: monthsBack,
      );
      await localDataSource.saveActivities(remoteActivities);
      return _mapModelsToEntities(remoteActivities, maxHr: maxHr);
    } on StravaApiException catch (e) {
      throw ServerFailure(e.message, e.statusCode);
    }
  }

  @override
  Future<void> refreshActivities({int monthsBack = 12}) async {
    final remoteActivities = await remoteDataSource.getAllRunningActivities(
      monthsBack: monthsBack,
    );
    await localDataSource.saveActivities(remoteActivities);
  }

  @override
  Future<Map<int, List<double>>> getHeartRateStreams(
    List<int> activityIds,
  ) async {
    if (activityIds.isEmpty) return {};

    final cached = await localDataSource.getCachedHeartRateStreams();
    final result = Map<int, List<double>>.from(cached);
    final uncached = activityIds
        .where((id) => !result.containsKey(id))
        .toList();

    if (uncached.isEmpty) return result;

    const batchSize = 10;
    for (var i = 0; i < uncached.length; i += batchSize) {
      final batch = uncached.sublist(
        i,
        (i + batchSize > uncached.length) ? uncached.length : i + batchSize,
      );
      final futures = batch.map((id) async {
        try {
          final streams = await remoteDataSource.getActivityStreams(id);
          final data = streams.heartrate?.data;
          if (data != null && data.isNotEmpty) {
            await localDataSource.saveHeartRateStream(id, data);
            return MapEntry(id, data);
          }
        } catch (_) {}
        return null;
      });
      final entries = await Future.wait(futures);
      for (final entry in entries) {
        if (entry != null) {
          result[entry.key] = entry.value;
        }
      }
    }

    return result;
  }

  List<RunActivity> _mapModelsToEntities(
    List<ActivityModel> models, {
    int maxHr = 190,
  }) {
    return models.map((model) {
      final date = DateTime.parse(model.startDate);
      final distanceKm = model.distance / 1000.0;
      final movingTimeSeconds = model.movingTime;
      final paceSecondsPerKm =
          movingTimeSeconds / (distanceKm > 0 ? distanceKm : 1);

      TrainingLoad load;
      if (model.averageHeartrate != null) {
        final hrPercent = model.averageHeartrate! / maxHr;
        if (hrPercent < 0.70) {
          load = TrainingLoad.easy;
        } else if (hrPercent < 0.80) {
          load = TrainingLoad.moderate;
        } else if (hrPercent < 0.90) {
          load = TrainingLoad.hard;
        } else {
          load = TrainingLoad.veryHard;
        }
      } else {
        load = TrainingLoad.moderate;
      }

      return RunActivity(
        id: model.id,
        name: model.name,
        date: date,
        distanceKm: distanceKm,
        movingTime: Duration(seconds: movingTimeSeconds),
        pace: Duration(seconds: paceSecondsPerKm.round()),
        elevationGainM: model.totalElevationGain,
        trainingLoad: load,
        avgHeartRate: model.averageHeartrate,
        maxHeartRate: model.maxHeartrate,
        avgCadence: model.averageCadence,
        sufferScore: model.sufferScore,
      );
    }).toList();
  }
}
