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
    final weeklyMinutes = _targetWeeklyMinutes(stats);
    final startDate = _startDate(activities);

    return TrainingPlan(
      startDate: startDate,
      goal: _determineGoal(stats),
      description: _planDescription(stats),
      days: _buildWeek(
        startDate: startDate,
        weeklyMinutes: weeklyMinutes,
        paceZones: paceZones,
        hrZones: hrZones,
        stats: stats,
      ),
    );
  }

  List<TrainingDay> _buildWeek({
    required DateTime startDate,
    required double weeklyMinutes,
    required List<PaceZone> paceZones,
    required List<HrZone> hrZones,
    required RunningStats stats,
  }) {
    final longRunMin = (weeklyMinutes * 0.30).round();
    final easyMin = (weeklyMinutes * 0.20).round();
    final tempoWorkMin = (weeklyMinutes * 0.15).round();

    return [
      TrainingDay(
        date: startDate,
        type: WorkoutType.easy,
        targetMinutes: easyMin,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        estimatedDuration: Duration(minutes: easyMin),
        description:
            'Easy recovery run. Conversational pace throughout. '
            'Focus on form, not speed.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 1)),
        type: WorkoutType.intervals,
        targetMinutes: _intervalMinutes(stats),
        warmUpMinutes: 10,
        coolDownMinutes: 10,
        paceTarget: paceZones[4],
        heartRateTarget: hrZones[4],
        estimatedDuration: Duration(minutes: _intervalMinutes(stats)),
        description: _intervalDescription(stats),
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 2)),
        type: WorkoutType.rest,
        description:
            'Rest or 20-30 min easy walk. Let your body absorb '
            'yesterday\'s interval session.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 3)),
        type: WorkoutType.easy,
        targetMinutes: easyMin,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        estimatedDuration: Duration(minutes: easyMin),
        description:
            'Easy aerobic run. Stay in Zone 2 the entire run. '
            'Great day for strides at the end (4x100m).',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 4)),
        type: WorkoutType.tempo,
        targetMinutes: tempoWorkMin + 20,
        warmUpMinutes: 10,
        coolDownMinutes: 10,
        paceTarget: paceZones[3],
        heartRateTarget: hrZones[3],
        estimatedDuration: Duration(minutes: tempoWorkMin + 20),
        description:
            '10 min warm-up, $tempoWorkMin min @ '
            'threshold pace (Zone 4), 10 min cool-down. '
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
        targetMinutes: longRunMin,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        estimatedDuration: Duration(minutes: longRunMin),
        description:
            'Long easy run - the most important run of the week. '
            'Stay strictly in Zone 2. Walk breaks are fine. '
            'Hydrate every 20-30 min.',
      ),
    ];
  }

  double _targetWeeklyMinutes(RunningStats stats) {
    final recentMinutes = stats.recentWeeklyAvgMinutes;
    if (recentMinutes <= 0) return 150;
    if (stats.formScore < -10) return (recentMinutes * 0.80).clamp(60, 600);
    if (stats.formScore < -5) return (recentMinutes * 0.95).clamp(60, 600);
    return (recentMinutes * 1.10).clamp(60, 900);
  }

  int _intervalMinutes(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      return 30;
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      return 42;
    }
    return 36;
  }

  String _intervalDescription(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      return '10 min warm-up @ Zone 2, then 4x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      return '10 min warm-up @ Zone 2, then 8x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
    }
    return '10 min warm-up @ Zone 2, then 6x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
  }

  String _determineGoal(RunningStats stats) {
    if (stats.totalRuns < 10) return 'Build a consistent running base';
    if (stats.fitnessScore < 30) return 'Develop aerobic fitness';
    if (stats.formScore < -10) return 'Recovery & consolidation week';
    return 'Improve threshold pace & race readiness';
  }

  List<HrZone> _calculateHrZones(List<RunActivity> activities) {
    final maxHr =
        activities
            .where((a) => a.maxHeartRate != null)
            .map((a) => a.maxHeartRate!)
            .fold<double?>(
              null,
              (max, hr) => max == null ? hr : (hr > max ? hr : max),
            )
            ?.round() ??
        190;
    final restingHr =
        activities
            .where((a) => a.avgHeartRate != null)
            .map((a) => a.avgHeartRate!)
            .fold<double?>(
              null,
              (min, hr) => min == null ? hr : (hr < min ? hr : min),
            )
            ?.round() ??
        60;
    final actualMax = maxHr.clamp(100, 230);
    final actualResting = restingHr.clamp(35, actualMax - 20);
    final hrr = actualMax - actualResting;

    return [
      HrZone(
        zoneNumber: 1,
        label: 'Zone 1 - Recovery',
        minBpm: actualResting,
        maxBpm: (actualResting + hrr * 0.60).round(),
      ),
      HrZone(
        zoneNumber: 2,
        label: 'Zone 2 - Aerobic Base',
        minBpm: (actualResting + hrr * 0.60).round(),
        maxBpm: (actualResting + hrr * 0.70).round(),
      ),
      HrZone(
        zoneNumber: 3,
        label: 'Zone 3 - Tempo',
        minBpm: (actualResting + hrr * 0.70).round(),
        maxBpm: (actualResting + hrr * 0.80).round(),
      ),
      HrZone(
        zoneNumber: 4,
        label: 'Zone 4 - Threshold',
        minBpm: (actualResting + hrr * 0.80).round(),
        maxBpm: (actualResting + hrr * 0.90).round(),
      ),
      HrZone(
        zoneNumber: 5,
        label: 'Zone 5 - VO2max',
        minBpm: (actualResting + hrr * 0.90).round(),
        maxBpm: actualMax,
      ),
    ];
  }

  DateTime _startDate(List<RunActivity> activities) {
    final today = DateTime.now();
    final hasRunToday = activities.any(
      (a) =>
          a.date.year == today.year &&
          a.date.month == today.month &&
          a.date.day == today.day,
    );
    if (!hasRunToday) return today;
    return today.add(const Duration(days: 1));
  }

  String _planDescription(RunningStats stats) {
    final form = stats.formScore;
    if (form < -10) {
      return 'You\'re currently fatigued. This week focuses on recovery with reduced volume and easy effort.';
    }
    if (form > 10) {
      return 'You\'re fresh and ready. This week includes a quality session to build fitness.';
    }
    return 'Balanced week combining easy aerobic base, quality work, and a long run.';
  }
}
