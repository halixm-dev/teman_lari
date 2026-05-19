import '../entities/return_context.dart';
import '../entities/run_activity.dart';
import '../entities/run_walk_phase.dart';
import '../entities/running_stats.dart';
import '../entities/training_plan.dart';
import 'analyze_runs_usecase.dart';
import 'hr_zone_calculator.dart';
import 'pace_zone_calculator.dart';
import 'training_plan_config.dart';
import 'workout_descriptions.dart';
import 'workout_sequence_strategy.dart';

class GeneratePlanUseCase {
  final AnalyzeRunsUseCase _analyzeRuns;
  final TrainingPlanConfig config;
  final WorkoutSequenceStrategy sequenceStrategy;
  final WorkoutDescriptions descriptions;

  GeneratePlanUseCase({
    AnalyzeRunsUseCase? analyzeRuns,
    TrainingPlanConfig? config,
    WorkoutSequenceStrategy? sequenceStrategy,
    WorkoutDescriptions? descriptions,
  })  : _analyzeRuns = analyzeRuns ?? AnalyzeRunsUseCase(),
        config = config ?? TrainingPlanConfig.defaultConfig,
        sequenceStrategy =
            sequenceStrategy ?? const DynamicWorkoutSequenceStrategy(),
        descriptions = descriptions ?? const WorkoutDescriptions();

  TrainingPlan generate(List<RunActivity> activities, {int weekInCycle = -1}) {
    if (activities.isEmpty) return TrainingPlan.empty();

    final stats = _analyzeRuns.compute(activities, config: config);
    final thresholdPace = PaceZoneCalculator.estimateThresholdPace(activities);
    final paceZones = PaceZoneCalculator.fromThresholdPace(thresholdPace);
    final hrZones = HrZoneCalculator.fromActivities(activities);
    final weeklyMinutes = _targetWeeklyMinutes(stats, weekInCycle: weekInCycle);
    final startDate = _startDate(activities);

    return TrainingPlan(
      startDate: startDate,
      goal: descriptions.goal(stats),
      description: descriptions.planDescription(stats),
      weekInCycle: weekInCycle,
      cyclePhase: stats.recommendedPhase,
      days: _buildWeek(
        startDate: startDate,
        weeklyMinutes: weeklyMinutes,
        paceZones: paceZones,
        hrZones: hrZones,
        stats: stats,
        activities: activities,
        thresholdPace: thresholdPace,
        weekInCycle: weekInCycle,
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
    int weekInCycle = -1,
  }) {
    final sorted = [...activities]
      ..sort((a, b) => b.date.compareTo(a.date));

    final easyLike = sorted
        .where((a) =>
            a.trainingLoad != TrainingLoad.hard &&
            a.trainingLoad != TrainingLoad.veryHard &&
            a.movingTime.inMinutes >= config.minRunDuration)
        .map((a) => a.movingTime.inMinutes)
        .toList()
      ..sort();
    final easyMedian = easyLike.isNotEmpty
        ? easyLike[easyLike.length ~/ 2]
        : 30;
    final longRunMinDuration = (easyMedian * config.longRunMultiplier)
        .round()
        .clamp(config.longRunMinCap, config.longRunMaxCap);

    final recentNonRest = sorted
        .where((a) => a.movingTime.inMinutes >= config.minRunDuration)
        .toList();

    final returnRampWeek = stats.returnContext != null && stats.returnContext!.isReturning
        ? 1
        : 0;

    final sequence = sequenceStrategy.determineSequence(
      recentActivities: recentNonRest,
      thresholdPace: thresholdPace,
      longRunMinDuration: longRunMinDuration,
      returnGapDays: config.returnGapDays,
      totalRuns: stats.totalRuns,
      continuousRunThreshold: config.continuousRunThreshold,
      returnContext: stats.returnContext,
      returnRampWeek: returnRampWeek,
      weekInCycle: weekInCycle,
      phase: stats.recommendedPhase,
    );

    final longRunMin = (weeklyMinutes * config.longRunFraction).round();
    final easyMin = (weeklyMinutes * config.easyFraction).round();
    final tempoWorkMin = (weeklyMinutes * config.tempoFraction).round();
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
        weekInCycle: weekInCycle,
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
    int weekInCycle = -1,
  }) {
    switch (type) {
      case WorkoutType.easy:
        final effective = easyMin.clamp(config.minEasyRunMinutes, 9999);
        if (stats.totalRuns < config.continuousRunThreshold) {
          final phase = RunWalkPhase.fromTotalRuns(stats.totalRuns);
          final target = phase.totalDurationMinutes
              .clamp(config.beginnerMinEasyMinutes, effective);
          return TrainingDay(
            date: date,
            type: WorkoutType.easy,
            targetMinutes: target,
            paceTarget: paceZones[1],
            heartRateTarget: hrZones[1],
            estimatedDuration: Duration(minutes: target),
            runWalkPhase: phase,
            description: descriptions.beginnerRunWalk(phase),
          );
        }
        return TrainingDay(
          date: date,
          type: WorkoutType.easy,
          targetMinutes: effective,
          paceTarget: paceZones[1],
          heartRateTarget: hrZones[1],
          estimatedDuration: Duration(minutes: effective),
          description: descriptions.easy(),
        );
      case WorkoutType.intervals:
        final desc = weekInCycle >= 0
            ? descriptions.intervalsCycle(stats, weekInCycle)
            : descriptions.intervals(stats);
        return TrainingDay(
          date: date,
          type: WorkoutType.intervals,
          targetMinutes: intervalMin,
          warmUpMinutes: 10,
          coolDownMinutes: 10,
          paceTarget: paceZones[4],
          heartRateTarget: hrZones[4],
          estimatedDuration: Duration(minutes: intervalMin),
          description: desc,
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
          description: descriptions.tempo(tempoWorkMin),
        );
      case WorkoutType.longRun:
        int effectiveLongRun = longRunMin;
        if (stats.recommendedPhase == CyclePhase.advanced &&
            weekInCycle >= 0 && weekInCycle < 3) {
          effectiveLongRun =
              (longRunMin * (1.0 + weekInCycle * 0.10)).round();
        } else if (weekInCycle == 3 &&
            stats.recommendedPhase == CyclePhase.advanced) {
          effectiveLongRun =
              (longRunMin * config.deloadLongRunFraction).round();
        }
        return TrainingDay(
          date: date,
          type: WorkoutType.longRun,
          targetMinutes: effectiveLongRun,
          paceTarget: paceZones[1],
          heartRateTarget: hrZones[1],
          estimatedDuration: Duration(minutes: effectiveLongRun),
          description: weekInCycle == 3
              ? descriptions.deload()
              : descriptions.longRun(),
        );
      case WorkoutType.rest:
        return TrainingDay(
          date: date,
          type: WorkoutType.rest,
          description: descriptions.rest(),
        );
      case WorkoutType.crossTraining:
        return TrainingDay(
          date: date,
          type: WorkoutType.crossTraining,
          description: descriptions.crossTraining(),
        );
    }
  }

  int _intervalMinutes(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < config.beginnerRunCount ||
        weeklyKm < config.beginnerWeeklyKm) {
      return config.beginnerIntervalMin;
    }
    if (totalRuns > config.advancedRunCount ||
        weeklyKm > config.advancedWeeklyKm) {
      return config.advancedIntervalMin;
    }
    return config.intermediateIntervalMin;
  }

  double _targetWeeklyMinutes(RunningStats stats, {int weekInCycle = -1}) {
    final recentMinutes = stats.recentWeeklyAvgMinutes;
    final returnCtx = stats.returnContext;

    // 1. Extended return → beginner volume
    if (returnCtx != null && returnCtx.category == GapCategory.extended) {
      return config.beginnerWeeklyMinTarget.toDouble();
    }

    // 2. Active return ramp
    if (returnCtx != null && returnCtx.isReturning && returnCtx.preGapAvgMin > 0) {
      final volume = returnCtx.startVolumeFraction * returnCtx.preGapAvgMin;
      return volume.clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
    }

    // 3. Periodized advanced
    if (weekInCycle >= 0 && stats.recommendedPhase == CyclePhase.advanced) {
      if (weekInCycle == 3) {
        return (recentMinutes * config.deloadVolumeFraction)
            .clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
      }
      final factor = 1.0 + (weekInCycle * config.buildWeekVolumeIncrement);
      return (recentMinutes * factor)
          .clamp(config.minWeeklyMinutes, config.maxWeeklyMinutesScaleUp);
    }

    // 4. Normal form-based
    if (stats.formScore < config.fatiguedThreshold) {
      return (recentMinutes * 0.80)
          .clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
    }
    if (stats.formScore < config.slightlyFatiguedThreshold) {
      return (recentMinutes * 0.95)
          .clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
    }
    return (recentMinutes * 1.10)
        .clamp(config.minWeeklyMinutes, config.maxWeeklyMinutesScaleUp);
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
}
