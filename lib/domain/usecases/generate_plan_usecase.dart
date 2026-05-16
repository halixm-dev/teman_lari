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
        activities: activities,
        thresholdPace: thresholdPace,
      ),
    );
  }

  List<TrainingDay> _buildWeek({
    required DateTime startDate,
    required double weeklyMinutes,
    required List<PaceZone> paceZones,
    required List<HrZone> hrZones,
    required RunningStats stats,
    required List<RunActivity> activities,
    required int thresholdPace,
  }) {
    final sorted = [...activities]
      ..sort((a, b) => b.date.compareTo(a.date));

    final easyLike = sorted
        .where((a) => a.trainingLoad != TrainingLoad.hard &&
            a.trainingLoad != TrainingLoad.veryHard &&
            a.movingTime.inMinutes >= 10)
        .map((a) => a.movingTime.inMinutes)
        .toList()
      ..sort();
    final easyMedian = easyLike.isNotEmpty
        ? easyLike[easyLike.length ~/ 2]
        : 30;
    final longRunMinDuration = (easyMedian * 1.5).round().clamp(20, 120);

    final recentNonRest = sorted
      .where((a) => a.movingTime.inMinutes >= 10)
      .toList();

    List<WorkoutType> sequence;

    if (recentNonRest.isNotEmpty) {
      final lastRunDate = recentNonRest.first.date;
      final daysSinceLastRun = startDate.difference(lastRunDate).inDays;

      final returnSeq = _continueReturnSequence(
        recentNonRest,
        thresholdPace,
        longRunMinDuration,
      );

      if (returnSeq != null) {
        sequence = returnSeq;
      } else if (daysSinceLastRun > 3) {
        sequence = const [
          WorkoutType.easy, WorkoutType.rest,
          WorkoutType.easy, WorkoutType.tempo,
          WorkoutType.rest, WorkoutType.longRun,
          WorkoutType.easy,
        ];
      } else {
        final recentTypes = recentNonRest
          .take(2)
          .map((a) => _classifyWorkoutType(a, thresholdPace,
              longRunMinDuration: longRunMinDuration))
          .toList();

        sequence = _next7Days(
          recentTypes.isNotEmpty ? recentTypes.first : WorkoutType.easy,
          secondLastType: recentTypes.length > 1 ? recentTypes[1] : null,
        );

        if (daysSinceLastRun >= 2 && sequence.first == WorkoutType.rest) {
          sequence = [...sequence.sublist(1), WorkoutType.easy];
        }
      }
    } else {
      sequence = const [
        WorkoutType.easy, WorkoutType.intervals,
        WorkoutType.rest, WorkoutType.easy,
        WorkoutType.tempo, WorkoutType.rest,
        WorkoutType.longRun,
      ];
    }

    final longRunMin = (weeklyMinutes * 0.30).round();
    final easyMin = (weeklyMinutes * 0.20).round();
    final tempoWorkMin = (weeklyMinutes * 0.15).round();
    final intervalMin = _intervalMinutes(stats);

    return List.generate(7, (i) {
      final date = startDate.add(Duration(days: i));
      return _buildDay(
        type: sequence[i],
        date: date,
        easyMin: easyMin,
        tempoWorkMin: tempoWorkMin,
        intervalMin: intervalMin,
        longRunMin: longRunMin,
        paceZones: paceZones,
        hrZones: hrZones,
        stats: stats,
      );
    });
  }

  TrainingDay _buildDay({
    required WorkoutType type,
    required DateTime date,
    required int easyMin,
    required int tempoWorkMin,
    required int intervalMin,
    required int longRunMin,
    required List<PaceZone> paceZones,
    required List<HrZone> hrZones,
    required RunningStats stats,
  }) {
    switch (type) {
      case WorkoutType.easy:
        return TrainingDay(
          date: date,
          type: WorkoutType.easy,
          targetMinutes: easyMin,
          paceTarget: paceZones[1],
          heartRateTarget: hrZones[1],
          estimatedDuration: Duration(minutes: easyMin),
          description:
              'Easy recovery run. Conversational pace throughout. '
              'Focus on form, not speed.',
        );
      case WorkoutType.intervals:
        return TrainingDay(
          date: date,
          type: WorkoutType.intervals,
          targetMinutes: intervalMin,
          warmUpMinutes: 10,
          coolDownMinutes: 10,
          paceTarget: paceZones[4],
          heartRateTarget: hrZones[4],
          estimatedDuration: Duration(minutes: intervalMin),
          description: _intervalDescription(stats),
        );
      case WorkoutType.tempo:
        return TrainingDay(
          date: date,
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
        );
      case WorkoutType.longRun:
        return TrainingDay(
          date: date,
          type: WorkoutType.longRun,
          targetMinutes: longRunMin,
          paceTarget: paceZones[1],
          heartRateTarget: hrZones[1],
          estimatedDuration: Duration(minutes: longRunMin),
          description:
              'Long easy run - the most important run of the week. '
              'Stay strictly in Zone 2. Walk breaks are fine. '
              'Hydrate every 20-30 min.',
        );
      case WorkoutType.rest:
        return TrainingDay(
          date: date,
          type: WorkoutType.rest,
          description: 'Rest day. Let your body recover.',
        );
      case WorkoutType.crossTraining:
        return TrainingDay(
          date: date,
          type: WorkoutType.crossTraining,
          description: 'Cross-training day.',
        );
    }
  }

  static WorkoutType _classifyWorkoutType(
    RunActivity activity,
    int thresholdPaceSecPerKm, {
    int longRunMinDuration = 55,
  }) {
    final pace = activity.pace.inSeconds;
    final durationMin = activity.movingTime.inMinutes;

    if (durationMin >= longRunMinDuration &&
        pace > (thresholdPaceSecPerKm * 1.05).round()) {
      return WorkoutType.longRun;
    }

    if (pace <= (thresholdPaceSecPerKm * 1.05).round()) {
      if (pace < (thresholdPaceSecPerKm * 0.98).round() ||
          activity.trainingLoad == TrainingLoad.veryHard) {
        return WorkoutType.intervals;
      }
      return WorkoutType.tempo;
    }

    return WorkoutType.easy;
  }

  static const _easySeq = [
    WorkoutType.intervals, WorkoutType.rest,
    WorkoutType.easy, WorkoutType.tempo,
    WorkoutType.rest, WorkoutType.longRun,
    WorkoutType.easy,
  ];

  static const _intervalsSeq = [
    WorkoutType.rest, WorkoutType.easy,
    WorkoutType.tempo, WorkoutType.rest,
    WorkoutType.longRun, WorkoutType.easy,
    WorkoutType.intervals,
  ];

  static const _tempoSeq = [
    WorkoutType.easy, WorkoutType.intervals,
    WorkoutType.rest, WorkoutType.easy,
    WorkoutType.longRun, WorkoutType.rest,
    WorkoutType.tempo,
  ];

  static const _longRunSeq = [
    WorkoutType.rest, WorkoutType.easy,
    WorkoutType.intervals, WorkoutType.rest,
    WorkoutType.easy, WorkoutType.tempo,
    WorkoutType.rest,
  ];

  static const _intervalsThenEasySeq = [
    WorkoutType.tempo, WorkoutType.rest,
    WorkoutType.longRun, WorkoutType.easy,
    WorkoutType.intervals, WorkoutType.rest,
    WorkoutType.easy,
  ];

  static const _defaultSeq = [
    WorkoutType.easy, WorkoutType.intervals,
    WorkoutType.rest, WorkoutType.easy,
    WorkoutType.tempo, WorkoutType.rest,
    WorkoutType.longRun,
  ];

  List<WorkoutType> _next7Days(
    WorkoutType lastType, {
    WorkoutType? secondLastType,
  }) {
    if (secondLastType == WorkoutType.intervals &&
        lastType == WorkoutType.easy) {
      return [..._intervalsThenEasySeq];
    }
    switch (lastType) {
      case WorkoutType.easy:
        return [..._easySeq];
      case WorkoutType.intervals:
        return [..._intervalsSeq];
      case WorkoutType.tempo:
        return [..._tempoSeq];
      case WorkoutType.longRun:
        return [..._longRunSeq];
      default:
        return [..._defaultSeq];
    }
  }

  List<WorkoutType>? _continueReturnSequence(
    List<RunActivity> sortedNonRest,
    int thresholdPace,
    int longRunMinDuration,
  ) {
    const returnSeq = [
      WorkoutType.easy, WorkoutType.rest,
      WorkoutType.easy, WorkoutType.tempo,
      WorkoutType.rest, WorkoutType.longRun,
      WorkoutType.easy,
    ];
    const runDays = [0, 2, 3, 5, 6];
    const runTypes = [
      WorkoutType.easy, WorkoutType.easy,
      WorkoutType.tempo, WorkoutType.longRun,
      WorkoutType.easy,
    ];

    // Find a gap > 3 days between any consecutive runs
    int breakIdx = -1;
    for (int i = 0; i < sortedNonRest.length - 1; i++) {
      final gap =
          sortedNonRest[i].date.difference(sortedNonRest[i + 1].date).inDays;
      if (gap > 3) {
        breakIdx = i;
        break;
      }
    }
    if (breakIdx < 0) return null;

    // Runs after the break, oldest-first
    final afterBreak =
        sortedNonRest.sublist(0, breakIdx + 1).reversed.toList();
    final recentTypes = afterBreak
        .take(5)
        .map((a) => _classifyWorkoutType(a, thresholdPace,
            longRunMinDuration: longRunMinDuration))
        .toList();

    int matched = 0;
    for (int i = 0; i < recentTypes.length && i < runTypes.length; i++) {
      if (recentTypes[i] != runTypes[i]) break;
      matched = i + 1;
    }

    if (matched >= runTypes.length) return null;

    final startDay = matched > 0 ? runDays[matched - 1] + 1 : 0;
    final remaining = returnSeq.sublist(startDay);
    if (remaining.length >= 7) return remaining.take(7).toList();

    final filler =
        _next7Days(returnSeq.last).take(7 - remaining.length).toList();
    return [...remaining, ...filler];
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
    if (totalRuns < 15 || weeklyKm < 20) return 30;
    if (totalRuns > 50 || weeklyKm > 50) return 42;
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
