import '../entities/run_activity.dart';
import '../entities/running_stats.dart';

class AnalyzeRunsUseCase {
  RunningStats compute(List<RunActivity> activities) {
    if (activities.isEmpty) return RunningStats.empty();

    final sortedByDate = [...activities]
      ..sort((a, b) => a.date.compareTo(b.date));

    return RunningStats(
      totalRuns: activities.length,
      totalDistanceKm: _totalDistance(activities),
      weeklyVolume: _weeklyVolume(activities),
      averagePace: _averagePace(activities),
      paceProgression: _paceProgression(sortedByDate),
      heartRateZones: _hrZoneDistribution(activities),
      trainingLoadHistory: _trainingLoadHistory(sortedByDate),
      vo2MaxEstimate: _estimateVo2Max(activities),
      fitnessScore: _fitnessScore(activities),
      fatigueSCore: _fatigueScore(activities),
      formScore: _formScore(activities),
    );
  }

  double _fitnessScore(List<RunActivity> activities) {
    return _exponentialMovingAverage(activities, decayDays: 42);
  }

  double _fatigueScore(List<RunActivity> activities) {
    return _exponentialMovingAverage(activities, decayDays: 7);
  }

  double _formScore(List<RunActivity> activities) {
    return _fitnessScore(activities) - _fatigueScore(activities);
  }

  double _exponentialMovingAverage(List<RunActivity> activities,
      {required int decayDays}) {
    if (activities.isEmpty) return 0;
    final decay = 2 / (decayDays + 1);
    double ema = 0;
    for (final activity in activities) {
      final tss = _trainingStressScore(activity);
      ema = tss * decay + ema * (1 - decay);
    }
    return ema;
  }

  double _trainingStressScore(RunActivity activity) {
    if (activity.avgHeartRate == null) {
      return activity.movingTime.inMinutes * 0.5;
    }
    final hrReserve = (activity.avgHeartRate! - 60) / (190 - 60);
    final durationHours = activity.movingTime.inMinutes / 60.0;
    return hrReserve * hrReserve * durationHours * 100;
  }

  List<PaceDataPoint> _paceProgression(List<RunActivity> sorted) {
    return sorted
        .where((a) => a.distanceKm > 3)
        .map((a) => PaceDataPoint(
              date: a.date,
              paceSecondsPerKm: a.pace.inSeconds,
              distanceKm: a.distanceKm,
            ))
        .toList();
  }

  Map<int, double> _hrZoneDistribution(List<RunActivity> activities) {
    final withHr = activities.where((a) => a.avgHeartRate != null);
    if (withHr.isEmpty) return {};

    final zoneTotals = <int, double>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalMinutes = 0;

    for (final activity in withHr) {
      final zone = _hrToZone(activity.avgHeartRate!, maxHr: 190);
      final minutes = activity.movingTime.inMinutes.toDouble();
      zoneTotals[zone] = (zoneTotals[zone] ?? 0) + minutes;
      totalMinutes += minutes;
    }

    return zoneTotals.map((k, v) => MapEntry(k, v / totalMinutes));
  }

  int _hrToZone(double hr, {required int maxHr}) {
    final pct = hr / maxHr;
    if (pct < 0.60) return 1;
    if (pct < 0.70) return 2;
    if (pct < 0.80) return 3;
    if (pct < 0.90) return 4;
    return 5;
  }

  double? _estimateVo2Max(List<RunActivity> activities) {
    final candidates = activities.where((a) =>
        a.distanceKm >= 4.5 && a.distanceKm <= 5.5);
    if (candidates.isEmpty) return null;

    final best = candidates.reduce((a, b) =>
        a.pace.inSeconds < b.pace.inSeconds ? a : b);

    final paceMinKm = best.pace.inSeconds / 60.0;
    return 29.54 + (5.000663 / paceMinKm) + (0.007546 / (paceMinKm * paceMinKm));
  }

  Map<String, double> _weeklyVolume(List<RunActivity> activities) {
    final weekly = <String, double>{};
    for (final activity in activities) {
      final weekKey = _isoWeekKey(activity.date);
      weekly[weekKey] = (weekly[weekKey] ?? 0) + activity.distanceKm;
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
    final totalSeconds =
        activities.fold<int>(0, (sum, a) => sum + a.pace.inSeconds);
    return Duration(seconds: totalSeconds ~/ activities.length);
  }

  List<TrainingLoadPoint> _trainingLoadHistory(List<RunActivity> sorted) {
    double fitness = 0, fatigue = 0;
    return sorted.map((activity) {
      final tss = _trainingStressScore(activity);
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
