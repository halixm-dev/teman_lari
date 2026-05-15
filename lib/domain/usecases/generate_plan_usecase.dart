import '../entities/run_activity.dart';
import '../entities/running_stats.dart';
import '../entities/training_plan.dart';
import 'analyze_runs_usecase.dart';
import 'pace_zone_calculator.dart';

class GeneratePlanUseCase {
  TrainingPlan generate(List<RunActivity> activities) {
    if (activities.isEmpty) return TrainingPlan.empty();

    final stats = AnalyzeRunsUseCase().compute(activities);
    final thresholdPace = PaceZoneCalculator.estimateThresholdPace(activities);
    final paceZones = PaceZoneCalculator.fromThresholdPace(thresholdPace);
    final hrZones = _calculateHrZones(activities);
    final weeklyKm = _targetWeeklyVolume(stats);
    final startDate = _nextMonday();

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
    final intervalKm = weeklyKm * 0.12;

    return [
      TrainingDay(
        date: startDate,
        type: WorkoutType.easy,
        targetDistanceKm: easyKm,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        description: 'Easy recovery run. Conversational pace throughout. '
            'Focus on form, not speed.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 1)),
        type: WorkoutType.intervals,
        targetDistanceKm: intervalKm + 2,
        paceTarget: paceZones[4],
        heartRateTarget: hrZones[4],
        description: '2km warm-up @ Zone 2, then 6x400m @ Zone 5 '
            'with 90s recovery jogs, 2km cool-down.',
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
        description: 'Easy aerobic run. Stay in Zone 2 the entire run. '
            'Great day for strides at the end (4x100m).',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 4)),
        type: WorkoutType.tempo,
        targetDistanceKm: tempoKm + 2,
        paceTarget: paceZones[3],
        heartRateTarget: hrZones[3],
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
        description: 'Long easy run - the most important run of the week. '
            'Stay strictly in Zone 2. Walk breaks are fine. '
            'Hydrate every 20-30 min.',
      ),
    ];
  }

  double _targetWeeklyVolume(RunningStats stats) {
    final recentVolume = stats.recentWeeklyAvgKm;
    return recentVolume * 1.10;
  }

  String _determineGoal(RunningStats stats) {
    if (stats.totalRuns < 10) return 'Build a consistent running base';
    if (stats.fitnessScore < 30) return 'Develop aerobic fitness';
    if (stats.formScore < -10) return 'Recovery & consolidation week';
    return 'Improve threshold pace & race readiness';
  }

  List<HrZone> _calculateHrZones(List<RunActivity> activities,
      {int maxHr = 190, int restingHr = 60}) {
    final hrr = maxHr - restingHr;
    return [
      HrZone(zoneNumber: 1, label: 'Zone 1 - Recovery',
          minBpm: restingHr, maxBpm: (restingHr + hrr * 0.60).round()),
      HrZone(zoneNumber: 2, label: 'Zone 2 - Aerobic Base',
          minBpm: (restingHr + hrr * 0.60).round(),
          maxBpm: (restingHr + hrr * 0.70).round()),
      HrZone(zoneNumber: 3, label: 'Zone 3 - Tempo',
          minBpm: (restingHr + hrr * 0.70).round(),
          maxBpm: (restingHr + hrr * 0.80).round()),
      HrZone(zoneNumber: 4, label: 'Zone 4 - Threshold',
          minBpm: (restingHr + hrr * 0.80).round(),
          maxBpm: (restingHr + hrr * 0.90).round()),
      HrZone(zoneNumber: 5, label: 'Zone 5 - VO2max',
          minBpm: (restingHr + hrr * 0.90).round(), maxBpm: maxHr),
    ];
  }

  DateTime _nextMonday() {
    final today = DateTime.now();
    final daysUntilMonday = (8 - today.weekday) % 7;
    return today.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
  }

  String _planDescription(RunningStats stats) {
    final form = stats.formScore;
    if (form < -10) return 'You\'re currently fatigued. This week focuses on recovery with reduced volume and easy effort.';
    if (form > 10) return 'You\'re fresh and ready. This week includes a quality session to build fitness.';
    return 'Balanced week combining easy aerobic base, quality work, and a long run.';
  }
}
