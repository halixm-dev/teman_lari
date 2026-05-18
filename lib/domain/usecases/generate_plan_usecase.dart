import '../entities/run_activity.dart';
import '../entities/running_stats.dart';
import '../entities/training_plan.dart';
import 'analyze_runs_usecase.dart';
import 'hr_zone_calculator.dart';
import 'pace_zone_calculator.dart';

class GeneratePlanUseCase {
  // --- Volume allocation fractions ---
  static const _longRunFraction = 0.30;
  static const _easyFraction = 0.20;
  static const _tempoFraction = 0.15;

  // --- Duration bounds ---
  static const _minRunDuration = 10;
  static const _longRunMultiplier = 1.5;
  static const _longRunMinCap = 20;
  static const _longRunMaxCap = 120;

  // --- Weekly minute bounds ---
  static const _defaultWeeklyMinutes = 150.0;
  static const _minWeeklyMinutes = 60.0;
  static const _maxWeeklyMinutes = 600.0;
  static const _maxWeeklyMinutesScaleUp = 900.0;
  static const _recentMinutesFloor = 60.0;

  // --- Form thresholds ---
  static const _fatiguedThreshold = -10.0;
  static const _slightlyFatiguedThreshold = -5.0;

  // --- Interval duration thresholds ---
  static const _beginnerRunCount = 15;
  static const _beginnerWeeklyKm = 20.0;
  static const _advancedRunCount = 50;
  static const _advancedWeeklyKm = 50.0;
  static const _beginnerIntervalMin = 30;
  static const _intermediateIntervalMin = 36;
  static const _advancedIntervalMin = 42;

  // --- Goal & description thresholds ---
  static const _baseBuildingRunCount = 10;
  static const _aerobicFitnessScore = 30.0;
  static const _freshFormScore = 10.0;

  // --- Gap threshold for return sequence ---
  static const _returnGapDays = 3;

  final AnalyzeRunsUseCase _analyzeRuns;

  GeneratePlanUseCase({AnalyzeRunsUseCase? analyzeRuns})
    : _analyzeRuns = analyzeRuns ?? AnalyzeRunsUseCase();

  TrainingPlan generate(List<RunActivity> activities) {
    if (activities.isEmpty) return TrainingPlan.empty();

    final stats = _analyzeRuns.compute(activities);
    final thresholdPace = PaceZoneCalculator.estimateThresholdPace(activities);
    final paceZones = PaceZoneCalculator.fromThresholdPace(thresholdPace);
    final hrZones = HrZoneCalculator.fromActivities(activities);
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
        .where((a) =>
            a.trainingLoad != TrainingLoad.hard &&
            a.trainingLoad != TrainingLoad.veryHard &&
            a.movingTime.inMinutes >= _minRunDuration)
        .map((a) => a.movingTime.inMinutes)
        .toList()
      ..sort();
    final easyMedian = easyLike.isNotEmpty
        ? easyLike[easyLike.length ~/ 2]
        : 30;
    final longRunMinDuration =
        (easyMedian * _longRunMultiplier).round().clamp(_longRunMinCap, _longRunMaxCap);

    final recentNonRest = sorted
      .where((a) => a.movingTime.inMinutes >= _minRunDuration)
      .toList();

    List<WorkoutType> sequence;

    if (recentNonRest.isNotEmpty) {
      final lastRunDate = recentNonRest.first.date;
      final daysSinceLastRun = startDate.difference(lastRunDate).inDays;

      if (daysSinceLastRun > _returnGapDays) {
        sequence = const [
          WorkoutType.easy, WorkoutType.rest,
          WorkoutType.easy, WorkoutType.tempo,
          WorkoutType.rest, WorkoutType.longRun,
          WorkoutType.easy,
        ];
      } else {
        final returnSeq = _continueReturnSequence(
          recentNonRest,
          thresholdPace,
          longRunMinDuration,
        );

        if (returnSeq != null) {
          sequence = returnSeq;
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
      }
    } else {
      sequence = const [
        WorkoutType.easy, WorkoutType.intervals,
        WorkoutType.rest, WorkoutType.easy,
        WorkoutType.tempo, WorkoutType.rest,
        WorkoutType.longRun,
      ];
    }

    final longRunMin = (weeklyMinutes * _longRunFraction).round();
    final easyMin = (weeklyMinutes * _easyFraction).round();
    final tempoWorkMin = (weeklyMinutes * _tempoFraction).round();
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

  static const _returnSequence = [
    WorkoutType.easy, WorkoutType.rest,
    WorkoutType.easy, WorkoutType.tempo,
    WorkoutType.rest, WorkoutType.longRun,
    WorkoutType.easy,
  ];

  static const _returnRunEntries = [
    (dayIndex: 0, type: WorkoutType.easy),
    (dayIndex: 2, type: WorkoutType.easy),
    (dayIndex: 3, type: WorkoutType.tempo),
    (dayIndex: 5, type: WorkoutType.longRun),
    (dayIndex: 6, type: WorkoutType.easy),
  ];

  List<WorkoutType>? _continueReturnSequence(
    List<RunActivity> sortedNonRest,
    int thresholdPace,
    int longRunMinDuration,
  ) {
    int breakIdx = -1;
    for (int i = 0; i < sortedNonRest.length - 1; i++) {
      final gap =
          sortedNonRest[i].date.difference(sortedNonRest[i + 1].date).inDays;
      if (gap > _returnGapDays) {
        breakIdx = i;
        break;
      }
    }
    if (breakIdx < 0) return null;

    final afterBreak =
        sortedNonRest.sublist(0, breakIdx + 1).reversed.toList();
    final recentTypes = afterBreak
        .take(_returnRunEntries.length)
        .map((a) => _classifyWorkoutType(a, thresholdPace,
            longRunMinDuration: longRunMinDuration))
        .toList();

    int matched = 0;
    for (int i = 0; i < recentTypes.length && i < _returnRunEntries.length; i++) {
      if (recentTypes[i] != _returnRunEntries[i].type) break;
      matched = i + 1;
    }

    if (matched == _returnRunEntries.length) return [..._defaultSeq];

    final startDay = matched > 0 ? _returnRunEntries[matched - 1].dayIndex + 1 : 0;
    final remaining = _returnSequence.sublist(startDay);
    if (remaining.length >= 7) return remaining.take(7).toList();

    final filler =
        _next7Days(_returnSequence.last).take(7 - remaining.length).toList();
    return [...remaining, ...filler];
  }

  double _targetWeeklyMinutes(RunningStats stats) {
    final recentMinutes = stats.recentWeeklyAvgMinutes;
    if (recentMinutes < _recentMinutesFloor) return _defaultWeeklyMinutes;
    if (stats.formScore < _fatiguedThreshold) {
      return (recentMinutes * 0.80).clamp(_minWeeklyMinutes, _maxWeeklyMinutes);
    }
    if (stats.formScore < _slightlyFatiguedThreshold) {
      return (recentMinutes * 0.95).clamp(_minWeeklyMinutes, _maxWeeklyMinutes);
    }
    return (recentMinutes * 1.10).clamp(_minWeeklyMinutes, _maxWeeklyMinutesScaleUp);
  }

  int _intervalMinutes(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < _beginnerRunCount || weeklyKm < _beginnerWeeklyKm) {
      return _beginnerIntervalMin;
    }
    if (totalRuns > _advancedRunCount || weeklyKm > _advancedWeeklyKm) {
      return _advancedIntervalMin;
    }
    return _intermediateIntervalMin;
  }

  String _intervalDescription(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < _beginnerRunCount || weeklyKm < _beginnerWeeklyKm) {
      return '10 min warm-up @ Zone 2, then 4x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
    }
    if (totalRuns > _advancedRunCount || weeklyKm > _advancedWeeklyKm) {
      return '10 min warm-up @ Zone 2, then 8x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
    }
    return '10 min warm-up @ Zone 2, then 6x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
  }

  String _determineGoal(RunningStats stats) {
    if (stats.totalRuns < _baseBuildingRunCount) {
      return 'Build a consistent running base';
    }
    if (stats.fitnessScore < _aerobicFitnessScore) return 'Develop aerobic fitness';
    if (stats.formScore < _fatiguedThreshold) return 'Recovery & consolidation week';
    return 'Improve threshold pace & race readiness';
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
    if (form < _fatiguedThreshold) {
      return 'You\'re currently fatigued. This week focuses on recovery with reduced volume and easy effort.';
    }
    if (form > _freshFormScore) {
      return 'You\'re fresh and ready. This week includes a quality session to build fitness.';
    }
    return 'Balanced week combining easy aerobic base, quality work, and a long run.';
  }
}
