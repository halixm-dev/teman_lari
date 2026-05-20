import '../entities/return_context.dart';
import '../entities/run_activity.dart';
import '../entities/running_stats.dart';
import '../entities/workout_type.dart';
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
  final int maxConsecutiveRunDays;
  final int targetEasyRunsAfterBreak;

  const DynamicWorkoutSequenceStrategy({
    this.maxConsecutiveRunDays = 3,
    this.targetEasyRunsAfterBreak = 2,
  });

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

    if (stats.totalRuns < config.continuousRunThreshold) {
      return _beginnerSequence();
    }

    final returnCtx = stats.returnContext;
    if (returnCtx != null && returnCtx.isReturning) {
      return _returnRampSequence(returnCtx, 1);
    }

    if (weekInCycle == 3 && stats.recommendedPhase == CyclePhase.advanced) {
      return _easyOnlySequence();
    }

    List<WorkoutType> history = _buildContinuousHistory(
      recentActivities,
      startDate,
      thresholdPace,
      longRunMinDuration,
    );

    List<WorkoutType> nextWeek = [];
    int plannedEasyRunCount = 0;

    for (int i = 0; i < 7; i++) {
      bool isReturning = _checkIfReturningFromBreak(
        history,
        config.returnGapDays,
        plannedEasyRunCount: plannedEasyRunCount,
      );
      WorkoutType next = _pickNextWorkout(history, isReturning);

      nextWeek.add(next);
      if (next == WorkoutType.easy) plannedEasyRunCount++;

      history.insert(0, next);
    }

    final daysSinceLastRun = _daysSinceLastRun(recentActivities, startDate);
    if (daysSinceLastRun >= 2 && nextWeek.first == WorkoutType.rest) {
      nextWeek = [...nextWeek.sublist(1), WorkoutType.easy];
    }

    return nextWeek;
  }

  List<WorkoutType> _beginnerSequence() {
    return [
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.rest,
    ];
  }

  List<WorkoutType> _returnRampSequence(ReturnContext ctx, int rampWeek) {
    switch (ctx.category) {
      case GapCategory.short:
        return _easyOnlySequence();
      case GapCategory.long:
        return rampWeek <= 1
            ? _easyOnlySequence()
            : _tempoAndLongRunSequence();
      case GapCategory.injury:
        return rampWeek <= 2
            ? _easyOnlySequence()
            : _tempoAndLongRunSequence();
      case GapCategory.extended:
      case GapCategory.none:
        return _easyOnlySequence();
    }
  }

  List<WorkoutType> _easyOnlySequence() {
    return [
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.rest,
    ];
  }

  List<WorkoutType> _tempoAndLongRunSequence() {
    return [
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.tempo,
      WorkoutType.rest,
      WorkoutType.easy,
      WorkoutType.rest,
      WorkoutType.longRun,
    ];
  }

  WorkoutType _pickNextWorkout(List<WorkoutType> history, bool isReturning) {
    final last = history.isNotEmpty ? history.first : WorkoutType.rest;
    final secondLast = history.length > 1 ? history[1] : WorkoutType.rest;

    bool isHard(WorkoutType t) =>
        t == WorkoutType.intervals ||
        t == WorkoutType.tempo ||
        t == WorkoutType.longRun;

    if (isHard(last)) {
      if (secondLast != WorkoutType.rest) return WorkoutType.rest;
      return WorkoutType.easy;
    }

    int consecutiveRuns = 0;
    for (var w in history) {
      if (w == WorkoutType.rest) break;
      consecutiveRuns++;
    }
    if (consecutiveRuns >= maxConsecutiveRunDays) {
      return WorkoutType.rest;
    }

    if (isReturning) {
      return last == WorkoutType.easy ? WorkoutType.rest : WorkoutType.easy;
    }

    int getDaysSince(WorkoutType t) {
      final idx = history.indexOf(t);
      return idx == -1 ? 999 : idx;
    }

    final candidates = [
      WorkoutType.tempo,
      WorkoutType.longRun,
      WorkoutType.intervals,
    ];

    candidates.sort((a, b) => getDaysSince(b).compareTo(getDaysSince(a)));

    return candidates.first;
  }

  bool _checkIfReturningFromBreak(
    List<WorkoutType> history,
    int returnGapDays, {
    int plannedEasyRunCount = 0,
  }) {
    int currentRestStreak = 0;
    int easyRunsSinceGap = 0;
    bool foundGap = false;

    for (int i = 0; i < history.length; i++) {
      if (history[i] == WorkoutType.rest) {
        currentRestStreak++;
        if (currentRestStreak >= returnGapDays) {
          foundGap = true;
        }
      } else {
        currentRestStreak = 0;
        if (foundGap) {
          if (history[i] == WorkoutType.easy) {
            easyRunsSinceGap++;
          } else {
            easyRunsSinceGap += targetEasyRunsAfterBreak;
          }
        }
      }
    }
    if (!foundGap) {
      return history.every((w) => w == WorkoutType.rest);
    }
    return (easyRunsSinceGap + plannedEasyRunCount) < targetEasyRunsAfterBreak;
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
    final sorted = List.of(activities)..sort((a, b) => b.date.compareTo(a.date));
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
