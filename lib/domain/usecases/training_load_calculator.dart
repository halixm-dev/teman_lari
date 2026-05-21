import '../entities/run_activity.dart';
import '../entities/running_stats.dart';

class TrainingLoadCalculator {
  List<TrainingLoadPoint> computeLoadHistory(
    List<RunActivity> sortedActivities, {
    required int maxHr,
    required int restingHr,
  }) {
    if (sortedActivities.isEmpty) return [];

    final tssByDate = <DateTime, double>{};
    for (final a in sortedActivities) {
      final localDate = a.date.toLocal();
      final day = DateTime(localDate.year, localDate.month, localDate.day);
      tssByDate[day] =
          (tssByDate[day] ?? 0) +
          _trainingStressScore(a, maxHr: maxHr, restingHr: restingHr);
    }

    final firstLocal = sortedActivities.first.date.toLocal();
    final first = DateTime(firstLocal.year, firstLocal.month, firstLocal.day);
    final now = DateTime.now();
    final last = DateTime(now.year, now.month, now.day);
    
    const fitnessDecay = 1 / 42, fatigueDecay = 1 / 7;
    double fitness = 0, fatigue = 0;
    final result = <TrainingLoadPoint>[];

    for (var d = first; !d.isAfter(last); d = DateTime(d.year, d.month, d.day + 1)) {
      final tss = tssByDate[d] ?? 0;
      fitness = tss * fitnessDecay + fitness * (1 - fitnessDecay);
      fatigue = tss * fatigueDecay + fatigue * (1 - fatigueDecay);
      result.add(TrainingLoadPoint(
        date: d,
        fitness: fitness,
        fatigue: fatigue,
        form: fitness - fatigue,
      ));
    }

    return result;
  }

  double _trainingStressScore(
    RunActivity activity, {
    required int maxHr,
    required int restingHr,
  }) {
    if (activity.avgHeartRate == null) {
      return activity.movingTime.inMinutes * 0.5;
    }
    final hrReserve =
        (activity.avgHeartRate! - restingHr) / (maxHr - restingHr);
    final durationHours = activity.movingTime.inMinutes / 60.0;
    return hrReserve * hrReserve * durationHours * 100;
  }

  int hrToZone(double hr, {required int maxHr, required int restingHr}) {
    final hrr = maxHr - restingHr;
    final hrAboveResting = hr - restingHr;
    final pct = hrr > 0 ? hrAboveResting / hrr : 0;
    if (pct < 0.60) return 1;
    if (pct < 0.70) return 2;
    if (pct < 0.80) return 3;
    if (pct < 0.90) return 4;
    return 5;
  }
}
