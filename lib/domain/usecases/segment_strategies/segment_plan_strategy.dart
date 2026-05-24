import '../../entities/activity.dart';
import '../../entities/running_stats.dart';
import '../../entities/training_plan.dart';
import '../training_plan_config.dart';
import '../workout_descriptions.dart';
import '../workout_sequence_strategy.dart';

import '../../entities/tsb_state.dart';
import '../schedule_constraints.dart';

abstract class SegmentPlanStrategy {
  /// Resolves the appropriate schedule constraints based on TSB state and week in cycle.
  ScheduleConstraints resolveConstraints({
    required RunningStats stats,
    required TrainingPlanConfig config,
    required int weekInCycle,
    required bool isDeloadWeek,
  }) {
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
    if (isDeloadWeek) {
      return ScheduleConstraints.deload;
    }
    return ScheduleConstraints.normal;
  }

  /// Calculate the un-capped target weekly minutes for this segment.
  double calculateTargetWeeklyMinutes(
    RunningStats stats,
    int weekInCycle,
    TrainingPlanConfig config,
  );

  /// Build the training days using the finalized (capped) weekly minutes.
  List<TrainingDay> buildWeek({
    required double finalWeeklyMinutes,
    required double longRunMinTarget,
    required DateTime startDate,
    required RunningStats stats,
    required List<Activity> recentActivities,
    required List<PaceZone> paceZones,
    required List<HrZone> hrZones,
    required int thresholdPace,
    required TrainingPlanConfig config,
    required int weekInCycle,
    required WorkoutDescriptions descriptions,
    required WorkoutSequenceStrategy sequenceStrategy,
  });
}
