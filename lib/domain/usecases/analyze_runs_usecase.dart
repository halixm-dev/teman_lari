import '../entities/run_activity.dart';
import '../entities/running_stats.dart';

class AnalyzeRunsUseCase {
  RunningStats compute(
    List<RunActivity> activities, {
    int? maxHr,
    int? restingHr,
  }) {
    if (activities.isEmpty) return RunningStats.empty();

    final sortedByDate = [...activities]
      ..sort((a, b) => a.date.compareTo(b.date));

    final actualMaxHr = maxHr ?? _resolveMaxHr(activities) ?? 190;
    final actualRestingHr = restingHr ?? _resolveRestingHr(activities) ?? 60;

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
      trainingLoadHistory: _trainingLoadHistory(
        sortedByDate,
        maxHr: actualMaxHr,
        restingHr: actualRestingHr,
      ),
      vo2MaxEstimate: _estimateVo2Max(activities),
      fitnessScore: _fitnessScore(
        activities,
        maxHr: actualMaxHr,
        restingHr: actualRestingHr,
      ),
      fatigueScore: _fatigueScore(
        activities,
        maxHr: actualMaxHr,
        restingHr: actualRestingHr,
      ),
      formScore: _formScore(
        activities,
        maxHr: actualMaxHr,
        restingHr: actualRestingHr,
      ),
    );
  }

  double _fitnessScore(
    List<RunActivity> activities, {
    int maxHr = 190,
    int restingHr = 60,
  }) {
    return _exponentialMovingAverage(
      activities,
      decayDays: 42,
      maxHr: maxHr,
      restingHr: restingHr,
    );
  }

  double _fatigueScore(
    List<RunActivity> activities, {
    int maxHr = 190,
    int restingHr = 60,
  }) {
    return _exponentialMovingAverage(
      activities,
      decayDays: 7,
      maxHr: maxHr,
      restingHr: restingHr,
    );
  }

  double _formScore(
    List<RunActivity> activities, {
    int maxHr = 190,
    int restingHr = 60,
  }) {
    return _fitnessScore(activities, maxHr: maxHr, restingHr: restingHr) -
        _fatigueScore(activities, maxHr: maxHr, restingHr: restingHr);
  }

  double _exponentialMovingAverage(
    List<RunActivity> activities, {
    required int decayDays,
    int maxHr = 190,
    int restingHr = 60,
  }) {
    if (activities.isEmpty) return 0;
    final decay = 2 / (decayDays + 1);
    double ema = 0;
    for (final activity in activities) {
      final tss = _trainingStressScore(
        activity,
        maxHr: maxHr,
        restingHr: restingHr,
      );
      ema = tss * decay + ema * (1 - decay);
    }
    return ema;
  }

  double _trainingStressScore(
    RunActivity activity, {
    int maxHr = 190,
    int restingHr = 60,
  }) {
    if (activity.avgHeartRate == null) {
      return activity.movingTime.inMinutes * 0.5;
    }
    final hrReserve =
        (activity.avgHeartRate! - restingHr) / (maxHr - restingHr);
    final durationHours = activity.movingTime.inMinutes / 60.0;
    return hrReserve * hrReserve * durationHours * 100;
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
    int maxHr = 190,
    int restingHr = 60,
  }) {
    final withHr = activities.where((a) => a.avgHeartRate != null);
    if (withHr.isEmpty) return {};

    final actualMax = _resolveMaxHr(activities) ?? maxHr;
    final actualResting = _resolveRestingHr(activities) ?? restingHr;

    final zoneTotals = <int, double>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalMinutes = 0;

    for (final activity in withHr) {
      final zone = _hrToZone(
        activity.avgHeartRate!,
        maxHr: actualMax,
        restingHr: actualResting,
      );
      final minutes = activity.movingTime.inMinutes.toDouble();
      zoneTotals[zone] = (zoneTotals[zone] ?? 0) + minutes;
      totalMinutes += minutes;
    }

    return zoneTotals.map((k, v) => MapEntry(k, v / totalMinutes));
  }

  int? _resolveMaxHr(List<RunActivity> activities) {
    final values = activities
        .where((a) => a.maxHeartRate != null)
        .map((a) => a.maxHeartRate!);
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a > b ? a : b).round();
  }

  int? _resolveRestingHr(List<RunActivity> activities) {
    final values = activities
        .where((a) => a.avgHeartRate != null)
        .map((a) => a.avgHeartRate!);
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a < b ? a : b).round();
  }

  int _hrToZone(double hr, {required int maxHr, int restingHr = 60}) {
    final hrr = maxHr - restingHr;
    final hrAboveResting = hr - restingHr;
    final pct = hrr > 0 ? hrAboveResting / hrr : 0;
    if (pct < 0.60) return 1;
    if (pct < 0.70) return 2;
    if (pct < 0.80) return 3;
    if (pct < 0.90) return 4;
    return 5;
  }

  double? _estimateVo2Max(List<RunActivity> activities) {
    final candidates = activities.where(
      (a) => a.distanceKm >= 4.5 && a.distanceKm <= 5.5,
    );
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
      final weekKey = _isoWeekKey(activity.date);
      weekly[weekKey] = (weekly[weekKey] ?? 0) + activity.distanceKm;
    }
    return weekly;
  }

  Map<String, double> _weeklyMinutes(List<RunActivity> activities) {
    final weekly = <String, double>{};
    for (final activity in activities) {
      final weekKey = _isoWeekKey(activity.date);
      weekly[weekKey] =
          (weekly[weekKey] ?? 0) + activity.movingTime.inMinutes.toDouble();
    }
    return weekly;
  }

  String _isoWeekKey(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-W${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  double _totalDistance(List<RunActivity> activities) =>
      activities.fold(0, (sum, a) => sum + a.distanceKm);

  Duration _averagePace(List<RunActivity> activities) {
    final totalSeconds = activities.fold<int>(
      0,
      (sum, a) => sum + a.pace.inSeconds,
    );
    return Duration(seconds: totalSeconds ~/ activities.length);
  }

  List<TrainingLoadPoint> _trainingLoadHistory(
    List<RunActivity> sorted, {
    int maxHr = 190,
    int restingHr = 60,
  }) {
    double fitness = 0, fatigue = 0;
    return sorted.map((activity) {
      final tss = _trainingStressScore(
        activity,
        maxHr: maxHr,
        restingHr: restingHr,
      );
      fitness = tss * (2 / 43) + fitness * (41 / 43);
      fatigue = tss * (2 / 8) + fatigue * (6 / 8);
      return TrainingLoadPoint(
        date: activity.date,
        fitness: fitness,
        fatigue: fatigue,
        form: fitness - fatigue,
      );
    }).toList();
  }
}
