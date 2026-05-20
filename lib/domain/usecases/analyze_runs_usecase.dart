import '../entities/return_context.dart';
import '../entities/run_activity.dart';
import '../entities/running_stats.dart';
import 'return_context_detector.dart';
import 'training_load_calculator.dart';
import 'training_plan_config.dart';

class AnalyzeRunsUseCase {
  final TrainingLoadCalculator _loadCalculator;
  final ReturnContextDetector _returnDetector;

  AnalyzeRunsUseCase({
    TrainingLoadCalculator? loadCalculator,
    ReturnContextDetector? returnDetector,
  })  : _loadCalculator = loadCalculator ?? TrainingLoadCalculator(),
        _returnDetector = returnDetector ?? ReturnContextDetector();

  RunningStats compute(
    List<RunActivity> activities, {
    int? userMaxHr,
    int? userRestingHr,
    TrainingPlanConfig? config,
  }) {
    if (activities.isEmpty) return RunningStats.empty();

    final sortedByDate = [...activities]
      ..sort((a, b) => a.date.compareTo(b.date));

    final actualMaxHr = _resolveMaxHr(activities, userValue: userMaxHr) ?? 190;
    final actualRestingHr =
        _resolveRestingHr(activities, userValue: userRestingHr) ?? 65;

    final loadHistory = _loadCalculator.computeLoadHistory(
      sortedByDate,
      maxHr: actualMaxHr,
      restingHr: actualRestingHr,
    );

    final cfg = config ?? TrainingPlanConfig.defaultConfig;

    final returnCtx = _returnDetector.detect(activities, cfg);

    return RunningStats(
      totalRuns: activities.length,
      totalDistanceKm: _totalDistance(activities),
      weeklyVolume: _weeklyVolume(activities),
      weeklyMinutes: _weeklyMinutes(activities),
      averagePace: _averagePace(activities),
      paceProgression: _paceProgression(sortedByDate),
      heartRateZones: _hrZoneDistribution(
        activities,
        maxHr: actualMaxHr,
        restingHr: actualRestingHr,
      ),
      trainingLoadHistory: loadHistory,
      vo2MaxEstimate: _estimateVo2Max(activities),
      fitnessScore: loadHistory.isNotEmpty ? loadHistory.last.fitness : 0.0,
      fatigueScore: loadHistory.isNotEmpty ? loadHistory.last.fatigue : 0.0,
      formScore: loadHistory.isNotEmpty ? loadHistory.last.form : 0.0,
      returnContext: returnCtx,
      recommendedPhase: _determinePhase(
        returnCtx,
        totalRuns: activities.length,
        recentWeeklyAvgKm: sortedByDate.isNotEmpty
            ? _recentWeeklyAvg(sortedByDate, byDistance: true)
            : 0,
        config: cfg,
      ),
    );
  }

  CyclePhase _determinePhase(
    ReturnContext? returnCtx, {
    required int totalRuns,
    required double recentWeeklyAvgKm,
    required TrainingPlanConfig config,
  }) {
    if (returnCtx != null && returnCtx.isReturning) {
      return CyclePhase.returning;
    }
    if (totalRuns < config.baseBuildingRunCount) {
      return CyclePhase.baseBuilding;
    }
    if (totalRuns < config.beginnerRunCount ||
        recentWeeklyAvgKm < config.beginnerWeeklyKm) {
      return CyclePhase.beginner;
    }
    if (totalRuns >= config.advancedRunCount &&
        recentWeeklyAvgKm >= config.advancedWeeklyKm) {
      return CyclePhase.advanced;
    }
    return CyclePhase.intermediate;
  }

  double _recentWeeklyAvg(
    List<RunActivity> activities, {
    required bool byDistance,
  }) {
    if (activities.isEmpty) return 0;
    final weekly = <String, double>{};
    for (final activity in activities) {
      final weekKey = _weekCommencingKey(activity.date);
      weekly[weekKey] = (weekly[weekKey] ?? 0) +
          (byDistance
              ? activity.distanceKm
              : activity.movingTime.inMinutes.toDouble());
    }
    final values = weekly.values.toList();
    final recentCount = values.length > 4 ? 4 : values.length;
    final recent = values.sublist(values.length - recentCount);
    return recent.reduce((a, b) => a + b) / recentCount;
  }

  List<PaceDataPoint> _paceProgression(List<RunActivity> sorted) {
    return sorted
        .where((a) => a.distanceKm > 3)
        .map(
          (a) => PaceDataPoint(
            date: a.date,
            paceSecondsPerKm: a.pace.inSeconds,
            distanceKm: a.distanceKm,
          ),
        )
        .toList();
  }

  Map<int, double> _hrZoneDistribution(
    List<RunActivity> activities, {
    required int maxHr,
    required int restingHr,
  }) {
    final withHr = activities.where((a) => a.avgHeartRate != null);
    if (withHr.isEmpty) return {};

    final zoneSeconds = <int, double>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalSeconds = 0;

    for (final activity in withHr) {
      final stream = activity.heartRateData;
      if (stream != null && stream.isNotEmpty) {
        final secondsPerPoint = activity.movingTime.inSeconds / stream.length;
        for (final hr in stream) {
          final zone = _loadCalculator.hrToZone(
            hr,
            maxHr: maxHr,
            restingHr: restingHr,
          );
          zoneSeconds[zone] = (zoneSeconds[zone] ?? 0) + secondsPerPoint;
        }
        totalSeconds += activity.movingTime.inSeconds.toDouble();
      } else {
        final zone = _loadCalculator.hrToZone(
          activity.avgHeartRate!,
          maxHr: maxHr,
          restingHr: restingHr,
        );
        final seconds = activity.movingTime.inSeconds.toDouble();
        zoneSeconds[zone] = (zoneSeconds[zone] ?? 0) + seconds;
        totalSeconds += seconds;
      }
    }

    if (totalSeconds <= 0) return {};
    return zoneSeconds.map((k, v) => MapEntry(k, v / totalSeconds));
  }

  int? _resolveMaxHr(
    List<RunActivity> activities, {
    int? userValue,
  }) {
    if (userValue != null) return userValue;
    final values = activities
        .where((a) => a.maxHeartRate != null)
        .map((a) => a.maxHeartRate!);
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a > b ? a : b).round();
  }

  int? _resolveRestingHr(
    List<RunActivity> activities, {
    int? userValue,
  }) {
    if (userValue != null) return userValue;
    return null;
  }

  double? _estimateVo2Max(List<RunActivity> activities) {
    final candidates =
        activities.where((a) => a.movingTime.inMinutes >= 12).toList();
    if (candidates.isEmpty) return null;

    final best = candidates.reduce(
      (a, b) => a.pace.inSeconds < b.pace.inSeconds ? a : b,
    );

    final paceMinKm = best.pace.inSeconds / 60.0;
    return 29.54 +
        (5.000663 / paceMinKm) +
        (0.007546 / (paceMinKm * paceMinKm));
  }

  Map<String, double> _weeklyVolume(List<RunActivity> activities) {
    final weekly = <String, double>{};
    for (final activity in activities) {
      final weekKey = _weekCommencingKey(activity.date);
      weekly[weekKey] = (weekly[weekKey] ?? 0) + activity.distanceKm;
    }
    return weekly;
  }

  Map<String, double> _weeklyMinutes(List<RunActivity> activities) {
    final weekly = <String, double>{};
    for (final activity in activities) {
      final weekKey = _weekCommencingKey(activity.date);
      weekly[weekKey] =
          (weekly[weekKey] ?? 0) + activity.movingTime.inMinutes.toDouble();
    }
    return weekly;
  }

  String _weekCommencingKey(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  double _totalDistance(List<RunActivity> activities) =>
      activities.fold(0, (sum, a) => sum + a.distanceKm);

  Duration _averagePace(List<RunActivity> activities) {
    final totalDistance = activities.fold<double>(
      0,
      (sum, a) => sum + a.distanceKm,
    );
    if (totalDistance == 0) return Duration.zero;
    final totalSeconds = activities.fold<int>(
      0,
      (sum, a) => sum + a.movingTime.inSeconds,
    );
    return Duration(seconds: (totalSeconds / totalDistance).round());
  }
}
