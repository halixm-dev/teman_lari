import '../entities/run_activity.dart';

abstract class ActivityRepository {
  Future<List<RunActivity>> getAllRunningActivities({int monthsBack = 12});
  Future<void> refreshActivities({int monthsBack = 12});
  Future<Map<int, List<double>>> getHeartRateStreams(List<int> activityIds);
}
