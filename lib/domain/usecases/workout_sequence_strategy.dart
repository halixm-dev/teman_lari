import '../entities/analyzed_activity.dart';
import '../entities/return_context.dart';
import '../entities/activity.dart';
import '../entities/running_stats.dart';
import '../entities/tsb_state.dart';
import '../entities/workout_type.dart';
import 'schedule_constraints.dart';
import 'training_plan_config.dart';

abstract class WorkoutSequenceStrategy {
  List<WorkoutType> determineSequence({
    required RunningStats stats,
    required TrainingPlanConfig config,
    required List<Activity> recentActivities,
    required int weekInCycle,
  });
}

class DynamicWorkoutSequenceStrategy implements WorkoutSequenceStrategy {
  const DynamicWorkoutSequenceStrategy();

  @override
  List<WorkoutType> determineSequence({
    required RunningStats stats,
    required TrainingPlanConfig config,
    required List<Activity> recentActivities,
    required int weekInCycle,
  }) {
    final now = DateTime.now();
    final startDate = _hasRunToday(recentActivities)
        ? now.add(const Duration(days: 1))
        : now;

    final constraints = _resolveConstraints(stats, config, weekInCycle);

    // Load recent classification history
    List<WorkoutType> history = _buildContinuousHistory(
      stats.analyzedActivities,
      startDate,
    );

    List<WorkoutType> nextWeek = [];
    int plannedRunCount = 0;
    int crossTrainingCount = 0;

    for (int i = 0; i < 7; i++) {
      WorkoutType next = _pickNextWorkout(
        history,
        constraints,
        plannedRunCount,
      );

      // Active recovery substitution
      if ((next == WorkoutType.rest || next == WorkoutType.easy) &&
          stats.formScore < config.fatiguedTsbThreshold &&
          crossTrainingCount < 1 &&
          constraints.allows(WorkoutType.crossTraining)) {
        next = WorkoutType.crossTraining;
        crossTrainingCount++;
      }

      nextWeek.add(next);
      if (ScheduleConstraints.isRunning(next)) plannedRunCount++;

      history.insert(0, next);
    }

    // If the user hasn't run in 2+ days and the first slot is rest,
    // rotate to start with a run (it's been long enough).
    final daysSinceLastRun = _daysSinceLastRun(recentActivities, startDate);
    if (daysSinceLastRun >= 2 && nextWeek.first == WorkoutType.rest) {
      // Find the first non-rest day and rotate to it
      final firstRunIdx = nextWeek.indexWhere((w) => w != WorkoutType.rest);
      if (firstRunIdx > 0) {
        nextWeek = [
          ...nextWeek.sublist(firstRunIdx),
          ...nextWeek.sublist(0, firstRunIdx),
        ];
      }
    }

    return nextWeek;
  }

  /// Select the appropriate constraints based on user segment.
  ScheduleConstraints _resolveConstraints(
    RunningStats stats,
    TrainingPlanConfig config,
    int weekInCycle,
  ) {
    // Beginner
    if (stats.recommendedPhase == CyclePhase.beginner) {
      return ScheduleConstraints.beginner;
    }

    // Transition
    if (stats.recommendedPhase == CyclePhase.transition) {
      return ScheduleConstraints.transition;
    }

    // Returning runner
    final returnCtx = stats.returnContext;
    if (returnCtx != null && returnCtx.isReturning) {
      // Extended gap → beginner constraints
      if (returnCtx.category == GapCategory.extended) {
        return ScheduleConstraints.beginner;
      }
      // All returning runners get easy-only constraints.
      // The original design always used rampWeek 1 (easy-only);
      // full ramp progression can be added when we track current ramp week.
      return ScheduleConstraints.returnRampEasy;
    }

    // TSB States
    final tsbState = TsbStateResolver.fromFormScore(
      stats.formScore,
      dangerThreshold: config.dangerTsbThreshold,
      fatiguedThreshold: config.fatiguedTsbThreshold,
      tiredThreshold: config.tiredTsbThreshold,
      optimalThreshold: config.optimalTsbThreshold,
    );

    if (tsbState == TsbState.danger) {
      return ScheduleConstraints.tsbDanger;
    }

    if (tsbState == TsbState.fatigued) {
      return ScheduleConstraints.tsbFatigued;
    }

    if (tsbState == TsbState.tired) {
      return ScheduleConstraints.tsbTired;
    }

    // Deload (advanced, week 3)
    if (weekInCycle == 3 && stats.recommendedPhase == CyclePhase.advanced) {
      return ScheduleConstraints.deload;
    }

    // Deload (intermediate, week 2 of 3-week cycle)
    if (weekInCycle == 2 && stats.recommendedPhase == CyclePhase.intermediate) {
      return ScheduleConstraints.deload;
    }

    // Normal
    return ScheduleConstraints.normal;
  }

  WorkoutType _pickNextWorkout(
    List<WorkoutType> history,
    ScheduleConstraints constraints,
    int plannedRunCount,
  ) {
    final last = history.isNotEmpty ? history.first : WorkoutType.rest;
    final secondLast = history.length > 1 ? history[1] : WorkoutType.rest;

    bool isHard(WorkoutType t) =>
        t == WorkoutType.intervals ||
        t == WorkoutType.tempo ||
        t == WorkoutType.longRun;

    // After a hard workout, enforce rest or easy
    if (isHard(last)) {
      if (secondLast != WorkoutType.rest) return WorkoutType.rest;
      // Only return easy if constraints allow it
      return constraints.allows(WorkoutType.easy)
          ? WorkoutType.easy
          : WorkoutType.rest;
    }

    // Check consecutive run days
    int consecutiveRuns = 0;
    for (var w in history) {
      if (w == WorkoutType.rest) break;
      consecutiveRuns++;
    }
    if (consecutiveRuns >= constraints.maxConsecutiveRunDays) {
      return WorkoutType.rest;
    }

    // Check weekly run cap
    if (plannedRunCount >= constraints.maxRunsPerWeek) {
      return WorkoutType.rest;
    }

    // If last was a running workout and we're in strict alternation mode
    // (maxConsecutiveRunDays == 1), force rest
    if (constraints.maxConsecutiveRunDays == 1 &&
        ScheduleConstraints.isRunning(last)) {
      return WorkoutType.rest;
    }

    // For easy-only constraints, return easy or rest
    if (!constraints.allows(WorkoutType.tempo) &&
        !constraints.allows(WorkoutType.intervals) &&
        !constraints.allows(WorkoutType.longRun)) {
      return last == WorkoutType.rest ? WorkoutType.easy : WorkoutType.rest;
    }

    // Cap hard workouts to max 3 per week (80/20 rule)
    final recentWeek = history.length > 7 ? history.sublist(0, 7) : history;
    final hardCount = recentWeek.where((w) => isHard(w)).length;
    if (hardCount >= 3) {
      return last == WorkoutType.easy ? WorkoutType.rest : WorkoutType.easy;
    }

    int getDaysSince(WorkoutType t) {
      final idx = history.indexOf(t);
      return idx == -1 ? 999 : idx;
    }

    // Pick the hard workout type that hasn't appeared most recently
    final candidates = <WorkoutType>[
      if (constraints.allows(WorkoutType.tempo)) WorkoutType.tempo,
      if (constraints.allows(WorkoutType.longRun)) WorkoutType.longRun,
      if (constraints.allows(WorkoutType.intervals)) WorkoutType.intervals,
    ];

    if (candidates.isEmpty) {
      return WorkoutType.easy;
    }

    candidates.sort((a, b) => getDaysSince(b).compareTo(getDaysSince(a)));
    return candidates.first;
  }

  List<WorkoutType> _buildContinuousHistory(
    List<AnalyzedActivity> analyzedActivities,
    DateTime startDate,
  ) {
    List<WorkoutType> history = [];
    DateTime cursor = startDate.subtract(const Duration(days: 1));

    for (int i = 0; i < 14; i++) {
      final analyzed = _getAnalyzedActivityOn(analyzedActivities, cursor);
      if (analyzed != null) {
        history.add(analyzed.type);
      } else {
        history.add(WorkoutType.rest);
      }
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return history;
  }

  AnalyzedActivity? _getAnalyzedActivityOn(
    List<AnalyzedActivity> analyzedActivities,
    DateTime date,
  ) {
    for (var a in analyzedActivities) {
      if (a.activity.date.year == date.year &&
          a.activity.date.month == date.month &&
          a.activity.date.day == date.day) {
        return a;
      }
    }
    return null;
  }

  bool _hasRunToday(List<Activity> activities) {
    final today = DateTime.now();
    return activities.any(
      (a) =>
          a.date.year == today.year &&
          a.date.month == today.month &&
          a.date.day == today.day,
    );
  }

  int _daysSinceLastRun(List<Activity> activities, DateTime startDate) {
    if (activities.isEmpty) return 999;
    final sorted = List.of(activities)
      ..sort((a, b) => b.date.compareTo(a.date));
    return startDate.difference(sorted.first.date).inDays;
  }
}
