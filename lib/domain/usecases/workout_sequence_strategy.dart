import '../entities/run_activity.dart';
import '../entities/training_plan.dart';

abstract class WorkoutSequenceStrategy {
  List<WorkoutType> determineSequence({
    required List<RunActivity> recentActivities,
    required int thresholdPace,
    required int longRunMinDuration,
    required int returnGapDays,
  });
}

class DynamicWorkoutSequenceStrategy implements WorkoutSequenceStrategy {
  /// Maximum consecutive days of running before forcing a rest day
  final int maxConsecutiveRunDays;
  /// Number of easy runs required to rebuild base after a long break
  final int targetEasyRunsAfterBreak;

  const DynamicWorkoutSequenceStrategy({
    this.maxConsecutiveRunDays = 3,
    this.targetEasyRunsAfterBreak = 2,
  });

  @override
  List<WorkoutType> determineSequence({
    required List<RunActivity> recentActivities,
    required int thresholdPace,
    required int longRunMinDuration,
    required int returnGapDays,
  }) {
    final now = DateTime.now();
    final startDate = _hasRunToday(recentActivities)
        ? now.add(const Duration(days: 1))
        : now;

    // 1. Build a continuous day-by-day history of the last 14 days
    List<WorkoutType> history = _buildContinuousHistory(
      recentActivities,
      startDate,
      thresholdPace,
      longRunMinDuration,
    );

    List<WorkoutType> nextWeek = [];

    // 2. Dynamically simulate and build the next 7 days
    for (int i = 0; i < 7; i++) {
      bool isReturning = _checkIfReturningFromBreak(history, returnGapDays);
      WorkoutType next = _pickNextWorkout(history, isReturning);
      
      nextWeek.add(next);
      
      // Insert the picked workout at the front of our simulated history 
      // so the next iteration makes decisions based on it.
      history.insert(0, next);
    }

    // 3. Shift rest day if the user hasn't run in 2+ days and today says "rest"
    final daysSinceLastRun = _daysSinceLastRun(recentActivities, startDate);
    if (daysSinceLastRun >= 2 && nextWeek.first == WorkoutType.rest) {
      nextWeek = [...nextWeek.sublist(1), WorkoutType.easy];
    }

    return nextWeek;
  }

  /// Evaluates the history to decide the absolute best next workout
  WorkoutType _pickNextWorkout(List<WorkoutType> history, bool isReturning) {
    final last = history.isNotEmpty ? history.first : WorkoutType.rest;
    final secondLast = history.length > 1 ? history[1] : WorkoutType.rest;

    bool isHard(WorkoutType t) =>
        t == WorkoutType.intervals ||
        t == WorkoutType.tempo ||
        t == WorkoutType.longRun;

    // RULE 1: Ensure recovery after a hard workout
    if (isHard(last)) {
      // If they ran the day before the hard workout too, force a rest day.
      if (secondLast != WorkoutType.rest) return WorkoutType.rest;
      return WorkoutType.easy;
    }

    // RULE 2: Prevent too many consecutive active days
    int consecutiveRuns = 0;
    for (var w in history) {
      if (w == WorkoutType.rest) break;
      consecutiveRuns++;
    }
    if (consecutiveRuns >= maxConsecutiveRunDays) {
      return WorkoutType.rest;
    }

    // RULE 3: If returning from a break, gently alternate Easy and Rest
    if (isReturning) {
      return last == WorkoutType.easy ? WorkoutType.rest : WorkoutType.easy;
    }

    // RULE 4: Pick the hard effort we haven't done in the longest time
    int getDaysSince(WorkoutType t) {
      final idx = history.indexOf(t);
      return idx == -1 ? 999 : idx;
    }

    // Prioritized tie-breaker order (if all haven't been done in a long time)
    final candidates = [
      WorkoutType.tempo,
      WorkoutType.longRun,
      WorkoutType.intervals,
    ];
    
    // Sort descending by "days since last done"
    candidates.sort((a, b) => getDaysSince(b).compareTo(getDaysSince(a)));

    return candidates.first;
  }

  /// Checks if a gap > returnGapDays exists recently without enough easy runs following it
  bool _checkIfReturningFromBreak(List<WorkoutType> history, int returnGapDays) {
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
            // Doing a hard run means they are already out of the return phase
            easyRunsSinceGap += targetEasyRunsAfterBreak;
          }
        }
      }
    }
    if (!foundGap) {
      // If completely new user (all rest history), treat as returning to ease them in
      return history.every((w) => w == WorkoutType.rest);
    }
    return easyRunsSinceGap < targetEasyRunsAfterBreak;
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
        history.add(WorkoutType.rest); // Fill gaps with rest days
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
