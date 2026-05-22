import '../entities/return_context.dart';
import '../entities/run_activity.dart';
import '../entities/running_stats.dart';
import '../entities/workout_type.dart';
import 'schedule_constraints.dart';
import 'training_plan_config.dart';

abstract class WorkoutSequenceStrategy {
  List<WorkoutType> determineSequence({
    required RunningStats stats,
    required TrainingPlanConfig config,
    required List<RunActivity> recentActivities,
    required int thresholdPace,
    required int longRunMinDuration,
    required int weekInCycle,
  });
}

class DynamicWorkoutSequenceStrategy implements WorkoutSequenceStrategy {
  const DynamicWorkoutSequenceStrategy();

  @override
  List<WorkoutType> determineSequence({
    required RunningStats stats,
    required TrainingPlanConfig config,
    required List<RunActivity> recentActivities,
    required int thresholdPace,
    required int longRunMinDuration,
    required int weekInCycle,
  }) {
    final now = DateTime.now();
    final startDate = _hasRunToday(recentActivities)
        ? now.add(const Duration(days: 1))
        : now;

    final constraints = _resolveConstraints(stats, config, weekInCycle);

    final sorted = [...recentActivities]
      ..sort((a, b) => b.date.compareTo(a.date));
    final recentNonRest = sorted
        .where((a) => a.movingTime.inMinutes >= config.minRunDuration)
        .toList();

    List<WorkoutType> history = _buildContinuousHistory(
      recentNonRest,
      startDate,
      thresholdPace,
      longRunMinDuration,
    );

    List<WorkoutType> nextWeek = [];
    int plannedRunCount = 0;

    for (int i = 0; i < 7; i++) {
      WorkoutType next = _pickNextWorkout(
        history,
        constraints,
        plannedRunCount,
      );

      nextWeek.add(next);
      if (ScheduleConstraints.isRunning(next)) plannedRunCount++;

      history.insert(0, next);
    }

    // If the user hasn't run in 2+ days and the first slot is rest,
    // rotate to start with a run (it's been long enough).
    final daysSinceLastRun = _daysSinceLastRun(recentActivities, startDate);
    if (daysSinceLastRun >= 2 && nextWeek.first == WorkoutType.rest) {
      // Find the first non-rest day and rotate to it
      final firstRunIdx = nextWeek.indexWhere(
        (w) => w != WorkoutType.rest,
      );
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
    if (stats.totalRuns < config.continuousRunThreshold) {
      return ScheduleConstraints.beginner;
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

    // Deload (advanced, week 3)
    if (weekInCycle == 3 && stats.recommendedPhase == CyclePhase.advanced) {
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
      return last == WorkoutType.rest
          ? WorkoutType.easy
          : WorkoutType.rest;
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
    List<RunActivity> activities,
    DateTime startDate,
    int thresholdPace,
    int longRunMinDuration,
  ) {
    List<WorkoutType> history = [];
    DateTime cursor = startDate.subtract(const Duration(days: 1));

    for (int i = 0; i < 14; i++) {
      final act = _getActivityOn(activities, cursor);
      if (act != null) {
        history.add(classifyWorkoutType(
          act,
          thresholdPace,
          longRunMinDuration: longRunMinDuration,
        ));
      } else {
        history.add(WorkoutType.rest);
      }
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return history;
  }

  RunActivity? _getActivityOn(List<RunActivity> activities, DateTime date) {
    for (var a in activities) {
      if (a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day) {
        return a;
      }
    }
    return null;
  }

  bool _hasRunToday(List<RunActivity> activities) {
    final today = DateTime.now();
    return activities.any((a) =>
        a.date.year == today.year &&
        a.date.month == today.month &&
        a.date.day == today.day);
  }

  int _daysSinceLastRun(List<RunActivity> activities, DateTime startDate) {
    if (activities.isEmpty) return 999;
    final sorted = List.of(activities)
      ..sort((a, b) => b.date.compareTo(a.date));
    return startDate.difference(sorted.first.date).inDays;
  }

  static WorkoutType classifyWorkoutType(
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
}
