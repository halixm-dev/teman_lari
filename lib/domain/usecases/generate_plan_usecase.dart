import '../entities/return_context.dart';
import '../entities/activity.dart';
import '../entities/run_walk_phase.dart';
import '../entities/running_stats.dart';
import '../entities/training_plan.dart';
import '../entities/tsb_state.dart';
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
  }) : _analyzeRuns = analyzeRuns ?? AnalyzeRunsUseCase(),
       config = config ?? TrainingPlanConfig.defaultConfig,
       sequenceStrategy =
           sequenceStrategy ?? const DynamicWorkoutSequenceStrategy(),
       descriptions = descriptions ?? const WorkoutDescriptions();

  TrainingPlan generate(
    List<Activity> activities, {
    int weekInCycle = -1,
    int? userMaxHr,
    int? userRestingHr,
  }) {
    if (activities.isEmpty) return TrainingPlan.empty();

    final stats = _analyzeRuns.compute(
      activities,
      userMaxHr: userMaxHr,
      userRestingHr: userRestingHr,
      config: config,
    );
    final thresholdPace = PaceZoneCalculator.estimateThresholdPace(activities);
    final paceZones = PaceZoneCalculator.fromThresholdPace(thresholdPace);
    final hrZones = HrZoneCalculator.fromActivities(
      activities,
      restingHr: userRestingHr,
      maxHr: userMaxHr,
    );
    
    int effectiveWeekInCycle = weekInCycle;
    if (weekInCycle >= 0) {
      if (stats.recommendedPhase == CyclePhase.intermediate) {
        effectiveWeekInCycle = weekInCycle % 3;
      } else if (stats.recommendedPhase == CyclePhase.advanced) {
        effectiveWeekInCycle = weekInCycle % 4;
      }
    }
    
    double weeklyMinutesTarget = _targetWeeklyMinutes(stats, weekInCycle: effectiveWeekInCycle);

    // 1. ACWR cap (<= 1.3 approx). Using 1.3x recent average.
    final maxWeeklyByAcwr = stats.recentWeeklyAvgMinutes * 1.3;
    if (maxWeeklyByAcwr > 0 && weeklyMinutesTarget > maxWeeklyByAcwr) {
      weeklyMinutesTarget = maxWeeklyByAcwr;
    }

    // 2. Weekly volume cap (+15%)
    final maxWeeklyByCap = stats.recentWeeklyAvgMinutes * 1.15;
    if (maxWeeklyByCap > 0 && weeklyMinutesTarget > maxWeeklyByCap) {
      weeklyMinutesTarget = maxWeeklyByCap;
    }

    // 3. Long run cap (+10%)
    double longRunTarget = weeklyMinutesTarget * config.longRunFraction;
    final maxLongRunByCap = stats.longestRecentRunMinutes * 1.10;
    if (maxLongRunByCap > 0 && longRunTarget > maxLongRunByCap) {
      longRunTarget = maxLongRunByCap;
    }

    // 4. Long run allocation (25-35% of final weekly total)
    if (weeklyMinutesTarget > 0) {
      final fraction = longRunTarget / weeklyMinutesTarget;
      if (fraction < 0.25) {
        longRunTarget = weeklyMinutesTarget * 0.25;
      } else if (fraction > 0.35) {
        longRunTarget = weeklyMinutesTarget * 0.35;
      }
    }

    final startDate = _startDate(activities);

    return TrainingPlan(
      startDate: startDate,
      goal: descriptions.goal(stats, weekInCycle: effectiveWeekInCycle),
      description: descriptions.planDescription(
        stats,
        weekInCycle: effectiveWeekInCycle,
      ),
      weekInCycle: effectiveWeekInCycle,
      cyclePhase: stats.recommendedPhase,
      days: _buildWeek(
        startDate: startDate,
        weeklyMinutes: weeklyMinutesTarget,
        longRunMinTarget: longRunTarget,
        paceZones: paceZones,
        hrZones: hrZones,
        stats: stats,
        activities: activities,
        thresholdPace: thresholdPace,
        weekInCycle: effectiveWeekInCycle,
      ),
    );
  }

  List<TrainingDay> _buildWeek({
    required DateTime startDate,
    required double weeklyMinutes,
    required double longRunMinTarget,
    required List<PaceZone> paceZones,
    required List<HrZone> hrZones,
    required RunningStats stats,
    required List<Activity> activities,
    required int thresholdPace,
    int weekInCycle = -1,
  }) {
    final sorted = [...activities]..sort((a, b) => b.date.compareTo(a.date));

    final recentNonRest = sorted
        .where((a) => a.movingTime.inMinutes >= config.minRunDuration)
        .toList();

    final sequence = sequenceStrategy.determineSequence(
      stats: stats,
      config: config,
      recentActivities: recentNonRest,
      weekInCycle: weekInCycle,
    );

    final longRunMin = longRunMinTarget.round();
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
        if (stats.recommendedPhase == CyclePhase.beginner || stats.recommendedPhase == CyclePhase.transition) {
          final daysSinceFirstRun = stats.firstActivityDate != null
              ? DateTime.now().difference(stats.firstActivityDate!).inDays
              : 0;
          final phase = RunWalkPhase.fromStats(stats.totalRuns, daysSinceFirstRun);
          
          if (!phase.isContinuous) {
            final target = phase.totalDurationMinutes.clamp(
              config.beginnerMinEasyMinutes,
              effective,
            );
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
            weekInCycle >= 0 &&
            weekInCycle < 3) {
          effectiveLongRun = (longRunMin * (1.0 + weekInCycle * 0.10)).round();
        } else if (weekInCycle == 3 &&
            stats.recommendedPhase == CyclePhase.advanced) {
          effectiveLongRun = (longRunMin * config.deloadLongRunFraction)
              .round();
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
      case WorkoutType.walk:
        return TrainingDay(
          date: date,
          type: WorkoutType.walk,
          description: descriptions.easy(),
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
    if (returnCtx != null &&
        returnCtx.isReturning &&
        returnCtx.preGapAvgMin > 0) {
      final volume = returnCtx.startVolumeFraction * returnCtx.preGapAvgMin;
      return volume.clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
    }

    // 3. Periodized advanced
    if (weekInCycle >= 0 && stats.recommendedPhase == CyclePhase.advanced) {
      if (weekInCycle == 3) {
        return (recentMinutes * config.deloadVolumeFraction).clamp(
          config.minWeeklyMinutes,
          config.maxWeeklyMinutes,
        );
      }
      final factor = 1.0 + (weekInCycle * config.buildWeekVolumeIncrement);
      return (recentMinutes * factor).clamp(
        config.minWeeklyMinutes,
        config.maxWeeklyMinutesScaleUp,
      );
    }

    // Intermediate periodization
    if (weekInCycle >= 0 && stats.recommendedPhase == CyclePhase.intermediate) {
      if (weekInCycle == 2) { // 3-week cycle: Week C (Recover): 80%
        return (recentMinutes * 0.8).clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
      } else if (weekInCycle == 1) { // Week B (Build): 105%
        return (recentMinutes * 1.05).clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
      } else { // Week A (Base): 100%
        return recentMinutes.clamp(config.minWeeklyMinutes, config.maxWeeklyMinutes);
      }
    }

    // Transition block
    if (stats.recommendedPhase == CyclePhase.transition) {
      return (recentMinutes * 1.05).clamp(
        config.minWeeklyMinutes,
        config.maxWeeklyMinutesScaleUp,
      );
    }

    // 4. Normal form-based (using TSB state)
    final tsbState = TsbStateResolver.fromFormScore(
      stats.formScore,
      dangerThreshold: config.dangerTsbThreshold,
      fatiguedThreshold: config.fatiguedTsbThreshold,
      tiredThreshold: config.tiredTsbThreshold,
      optimalThreshold: config.optimalTsbThreshold,
    );

    double target;
    if (tsbState == TsbState.danger) {
      target = recentMinutes * config.deloadVolumeFraction;
    } else if (tsbState == TsbState.fatigued) {
      target = recentMinutes * 0.85;
    } else if (tsbState == TsbState.tired) {
      target = recentMinutes * 0.90;
    } else if (tsbState == TsbState.optimal) {
      target = recentMinutes * 1.05;
    } else { // fresh
      target = recentMinutes * 1.10;
    }

    return target.clamp(
      config.minWeeklyMinutes,
      config.maxWeeklyMinutesScaleUp,
    );
  }

  DateTime _startDate(List<Activity> activities) {
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
