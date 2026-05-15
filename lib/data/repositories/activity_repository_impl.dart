import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/run_activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/local_activity_datasource.dart';
import '../datasources/strava_activity_datasource.dart';
import '../models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final StravaActivityDataSource remoteDataSource;
  final LocalActivityDataSource localDataSource;

  ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<RunActivity>> getAllRunningActivities({int monthsBack = 12}) async {
    try {
      final cached = await localDataSource.getCachedActivities();
      if (cached != null) {
        return _mapModelsToEntities(cached);
      }
    } catch (_) {
    }

    try {
      final remoteActivities =
          await remoteDataSource.getAllRunningActivities(monthsBack: monthsBack);
      await localDataSource.saveActivities(remoteActivities);
      return _mapModelsToEntities(remoteActivities);
    } on StravaApiException catch (e) {
      throw ServerFailure(e.message, e.statusCode);
    }
  }

  @override
  Future<void> refreshActivities({int monthsBack = 12}) async {
    final remoteActivities =
        await remoteDataSource.getAllRunningActivities(monthsBack: monthsBack);
    await localDataSource.saveActivities(remoteActivities);
  }

  List<RunActivity> _mapModelsToEntities(List<ActivityModel> models) {
    return models
        .map((model) {
          final date = DateTime.parse(model.startDate);
          final distanceKm = model.distance / 1000.0;
          final movingTimeSeconds = model.movingTime;
          final paceSecondsPerKm =
              movingTimeSeconds / (distanceKm > 0 ? distanceKm : 1);

          TrainingLoad load;
          if (model.averageHeartrate != null) {
            final hrPercent = model.averageHeartrate! / 190;
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
        })
        .toList();
  }
}
