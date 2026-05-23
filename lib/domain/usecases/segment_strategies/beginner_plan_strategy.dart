import '../../entities/activity.dart';
import '../../entities/running_stats.dart';
import '../../entities/training_plan.dart';
import '../../entities/run_walk_phase.dart';
import '../../entities/workout_type.dart';
import '../hr_zone_calculator.dart';
import '../pace_zone_calculator.dart';
import '../training_plan_config.dart';
import '../workout_descriptions.dart';
import '../workout_sequence_strategy.dart';
import '../schedule_constraints.dart';
import 'segment_plan_strategy.dart';

class BeginnerPlanStrategy extends SegmentPlanStrategy {
  @override
  double calculateTargetWeeklyMinutes(
    RunningStats stats,
    int weekInCycle,
    TrainingPlanConfig config,
  ) {
    return config.beginnerWeeklyMinTarget.toDouble();
  }

  @override
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
  }) {
    final sequence = sequenceStrategy.determineSequence(
      constraints: ScheduleConstraints.beginner,
      stats: stats,
      config: config,
      recentActivities: recentActivities,
      weekInCycle: weekInCycle,
    );

    final easyMin = (finalWeeklyMinutes * config.easyFraction).round();

    return List.generate(7, (i) {
      final date = startDate.add(Duration(days: i));
      final type = sequence[i];

      if (type == WorkoutType.rest) {
        return TrainingDay(
          date: date,
          type: WorkoutType.rest,
          description: descriptions.rest(),
        );
      }

      if (type == WorkoutType.crossTraining) {
        return TrainingDay(
          date: date,
          type: WorkoutType.crossTraining,
          description: descriptions.crossTraining(),
        );
      }

      final effective = easyMin.clamp(config.minEasyRunMinutes, 9999);
      final daysSinceFirstRun = stats.firstActivityDate != null
          ? DateTime.now().difference(stats.firstActivityDate!).inDays
          : 0;
      final phase = RunWalkPhase.fromStats(stats.totalRuns, daysSinceFirstRun);

      if (!phase.isContinuous) {
        final target = phase.totalDurationMinutes;
        return TrainingDay(
          date: date,
          type: WorkoutType.easy,
          targetMinutes: target + 10,
          warmUpMinutes: 5,
          coolDownMinutes: 5,
          paceTarget: paceZones[1],
          heartRateTarget: hrZones[1],
          estimatedDuration: Duration(minutes: target + 10),
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
    });
  }
}
