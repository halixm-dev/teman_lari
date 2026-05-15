import '../entities/run_activity.dart';
import '../entities/running_stats.dart';
import '../entities/training_plan.dart';
import 'analyze_runs_usecase.dart';
import 'pace_zone_calculator.dart';

class GeneratePlanUseCase {
  final AnalyzeRunsUseCase _analyzeRuns;

  GeneratePlanUseCase({AnalyzeRunsUseCase? analyzeRuns})
      : _analyzeRuns = analyzeRuns ?? AnalyzeRunsUseCase();

  TrainingPlan generate(List<RunActivity> activities) {
    if (activities.isEmpty) return TrainingPlan.empty();

    final stats = _analyzeRuns.compute(activities);
    final thresholdPace = PaceZoneCalculator.estimateThresholdPace(activities);
    final paceZones = PaceZoneCalculator.fromThresholdPace(thresholdPace);
    final hrZones = _calculateHrZones(activities);
    final weeklyKm = _targetWeeklyVolume(stats);
    final startDate = _startDate(activities);

    return TrainingPlan(
      startDate: startDate,
      goal: _determineGoal(stats),
      description: _planDescription(stats),
      days: _buildWeek(
        startDate: startDate,
        weeklyKm: weeklyKm,
        paceZones: paceZones,
        hrZones: hrZones,
        stats: stats,
      ),
    );
  }

  List<TrainingDay> _buildWeek({
    required DateTime startDate,
    required double weeklyKm,
    required List<PaceZone> paceZones,
    required List<HrZone> hrZones,
    required RunningStats stats,
  }) {
    final longRunKm = weeklyKm * 0.30;
    final easyKm = weeklyKm * 0.20;
    final tempoKm = weeklyKm * 0.15;

    return [
      TrainingDay(
        date: startDate,
        type: WorkoutType.easy,
        targetDistanceKm: easyKm,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        estimatedDuration: _estimateDuration(easyKm, paceZones[1]),
        description: 'Easy recovery run. Conversational pace throughout. '
            'Focus on form, not speed.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 1)),
        type: WorkoutType.intervals,
        targetDistanceKm: _intervalDistance(stats),
        warmUpCoolDownKm: 4.0,
        paceTarget: paceZones[4],
        heartRateTarget: hrZones[4],
        estimatedDuration: _estimateDuration(_intervalDistance(stats), paceZones[4]),
        description: _intervalDescription(stats),
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 2)),
        type: WorkoutType.rest,
        description: 'Rest or 20-30 min easy walk. Let your body absorb '
            'yesterday\'s interval session.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 3)),
        type: WorkoutType.easy,
        targetDistanceKm: easyKm,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        estimatedDuration: _estimateDuration(easyKm, paceZones[1]),
        description: 'Easy aerobic run. Stay in Zone 2 the entire run. '
            'Great day for strides at the end (4x100m).',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 4)),
        type: WorkoutType.tempo,
        targetDistanceKm: tempoKm + 2,
        warmUpCoolDownKm: 2.0,
        paceTarget: paceZones[3],
        heartRateTarget: hrZones[3],
        estimatedDuration: _estimateDuration(tempoKm + 2, paceZones[3]),
        description: '1km warm-up, ${tempoKm.toStringAsFixed(1)}km @ '
            'threshold pace (Zone 4), 1km cool-down. '
            'Comfortably hard - you can speak in short sentences.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 5)),
        type: WorkoutType.rest,
        description: 'Full rest day before long run.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 6)),
        type: WorkoutType.longRun,
        targetDistanceKm: longRunKm,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        estimatedDuration: _estimateDuration(longRunKm, paceZones[1]),
        description: 'Long easy run - the most important run of the week. '
            'Stay strictly in Zone 2. Walk breaks are fine. '
            'Hydrate every 20-30 min.',
      ),
    ];
  }

  Duration _estimateDuration(double distanceKm, PaceZone zone) {
    final avgPaceSeconds = (zone.slowestPace.inSeconds + zone.fastestPace.inSeconds) ~/ 2;
    return Duration(seconds: (distanceKm * avgPaceSeconds).round());
  }

  double _targetWeeklyVolume(RunningStats stats) {
    final recentVolume = stats.recentWeeklyAvgKm;
    if (recentVolume <= 0) return 15;
    if (stats.formScore < -10) return (recentVolume * 0.80).clamp(10, 200);
    if (stats.formScore < -5) return (recentVolume * 0.95).clamp(10, 200);
    return (recentVolume * 1.10).clamp(10, 300);
  }

  double _intervalDistance(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      // 2km warm-up + 4x400m (1.6km) + 3 recovery jogs (0.75km) + 2km cool-down
      return 6.4;
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      // 2km warm-up + 8x400m (3.2km) + 7 recovery jogs (1.75km) + 2km cool-down
      return 9.0;
    }
    // 2km warm-up + 6x400m (2.4km) + 5 recovery jogs (1.25km) + 2km cool-down
    return 7.7;
  }

  String _intervalDescription(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      return '2km warm-up @ Zone 2, then 4x400m @ Zone 5 with 90s recovery jogs, 2km cool-down.';
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      return '2km warm-up @ Zone 2, then 8x400m @ Zone 5 with 90s recovery jogs, 2km cool-down.';
    }
    return '2km warm-up @ Zone 2, then 6x400m @ Zone 5 with 90s recovery jogs, 2km cool-down.';
  }

  String _determineGoal(RunningStats stats) {
    if (stats.totalRuns < 10) return 'Build a consistent running base';
    if (stats.fitnessScore < 30) return 'Develop aerobic fitness';
    if (stats.formScore < -10) return 'Recovery & consolidation week';
    return 'Improve threshold pace & race readiness';
  }

  List<HrZone> _calculateHrZones(List<RunActivity> activities) {
    final maxHr = activities
            .where((a) => a.maxHeartRate != null)
            .map((a) => a.maxHeartRate!)
            .fold<double?>(null, (max, hr) => max == null ? hr : (hr > max ? hr : max))
            ?.round() ??
        190;
    final restingHr = activities
            .where((a) => a.avgHeartRate != null)
            .map((a) => a.avgHeartRate!)
            .fold<double?>(null, (min, hr) => min == null ? hr : (hr < min ? hr : min))
            ?.round() ??
        60;
    final actualMax = maxHr.clamp(100, 230);
    final actualResting = restingHr.clamp(35, actualMax - 20);
    final hrr = actualMax - actualResting;

    return [
      HrZone(zoneNumber: 1, label: 'Zone 1 - Recovery',
          minBpm: actualResting, maxBpm: (actualResting + hrr * 0.60).round()),
      HrZone(zoneNumber: 2, label: 'Zone 2 - Aerobic Base',
          minBpm: (actualResting + hrr * 0.60).round(),
          maxBpm: (actualResting + hrr * 0.70).round()),
      HrZone(zoneNumber: 3, label: 'Zone 3 - Tempo',
          minBpm: (actualResting + hrr * 0.70).round(),
          maxBpm: (actualResting + hrr * 0.80).round()),
      HrZone(zoneNumber: 4, label: 'Zone 4 - Threshold',
          minBpm: (actualResting + hrr * 0.80).round(),
          maxBpm: (actualResting + hrr * 0.90).round()),
      HrZone(zoneNumber: 5, label: 'Zone 5 - VO2max',
          minBpm: (actualResting + hrr * 0.90).round(), maxBpm: actualMax),
    ];
  }

  DateTime _startDate(List<RunActivity> activities) {
    final today = DateTime.now();
    final hasRunToday = activities.any((a) =>
        a.date.year == today.year &&
        a.date.month == today.month &&
        a.date.day == today.day);
    if (!hasRunToday) return today;
    return today.add(const Duration(days: 1));
  }

  String _planDescription(RunningStats stats) {
    final form = stats.formScore;
    if (form < -10) return 'You\'re currently fatigued. This week focuses on recovery with reduced volume and easy effort.';
    if (form > 10) return 'You\'re fresh and ready. This week includes a quality session to build fitness.';
    return 'Balanced week combining easy aerobic base, quality work, and a long run.';
  }
}
