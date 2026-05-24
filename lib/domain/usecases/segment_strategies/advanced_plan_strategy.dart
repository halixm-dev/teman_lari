import '../../entities/activity.dart';
import '../../entities/running_stats.dart';
import '../../entities/training_plan.dart';
import '../training_plan_config.dart';
import '../workout_descriptions.dart';
import '../workout_sequence_strategy.dart';
import 'segment_plan_strategy.dart';

class AdvancedPlanStrategy extends SegmentPlanStrategy {
  @override
  double calculateTargetWeeklyMinutes(
    RunningStats stats,
    int weekInCycle,
    TrainingPlanConfig config,
  ) {
    final recentMinutes = stats.recentWeeklyAvgMinutes;

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
    final constraints = resolveConstraints(
      stats: stats,
      config: config,
      weekInCycle: weekInCycle,
      isDeloadWeek: weekInCycle == 3,
    );

    final sequence = sequenceStrategy.determineSequence(
      constraints: constraints,
      stats: stats,
      config: config,
      recentActivities: recentActivities,
      weekInCycle: weekInCycle,
    );

    int effectiveLongRun = longRunMinTarget.round();
    if (weekInCycle < 3) {
      effectiveLongRun = (effectiveLongRun * (1.0 + weekInCycle * 0.10))
          .round();
    } else if (weekInCycle == 3) {
      effectiveLongRun = (effectiveLongRun * config.deloadLongRunFraction)
          .round();
    }

    final easyMin = (finalWeeklyMinutes * config.easyFraction).round();
    final tempoWorkMin = (finalWeeklyMinutes * config.tempoFraction).round();

    return List.generate(7, (i) {
      final date = startDate.add(Duration(days: i));
      final type = sequence[i];

      switch (type) {
        case WorkoutType.easy:
          final effective = easyMin.clamp(config.minEasyRunMinutes, 9999);
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
          final desc = descriptions.intervalsCycle(stats, weekInCycle);
          final generatedIntervals = _buildIntervals(weekInCycle);
          final actualIntervalsMin =
              generatedIntervals.fold<int>(
                0,
                (sum, i) => sum + i.duration.inSeconds,
              ) ~/
              60;
          final totalTargetMinutes = 20 + actualIntervalsMin;

          return TrainingDay(
            date: date,
            type: WorkoutType.intervals,
            targetMinutes: totalTargetMinutes,
            warmUpMinutes: 10,
            coolDownMinutes: 10,
            paceTarget: paceZones[4],
            heartRateTarget: hrZones[4],
            estimatedDuration: Duration(minutes: totalTargetMinutes),
            description: desc,
            intervals: generatedIntervals,
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
          return TrainingDay(
            date: date,
            type: WorkoutType.longRun,
            targetMinutes: effectiveLongRun,
            paceTarget: paceZones[1],
            heartRateTarget: hrZones[1],
            estimatedDuration: Duration(minutes: effectiveLongRun),
            description: weekInCycle == 3
                ? descriptions.deload()
                : descriptions.longRun(effectiveLongRun),
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
    });
  }

  List<IntervalPhase> _buildIntervals(int weekInCycle) {
    int reps = 6;
    int workSec = 90;
    int recSec = 90;

    switch (weekInCycle) {
      case 0:
        reps = 5;
        workSec = 5 * 60;
        recSec = 120;
        break;
      case 1:
        reps = 8;
        workSec = 3 * 60;
        recSec = 90;
        break;
      case 2:
        reps = 12;
        workSec = 2 * 60;
        recSec = 90;
        break;
      case 3:
        return []; // deload
    }

    final intervals = <IntervalPhase>[];
    for (int i = 0; i < reps; i++) {
      intervals.add(
        IntervalPhase(
          type: IntervalPhaseType.work,
          duration: Duration(seconds: workSec),
        ),
      );
      intervals.add(
        IntervalPhase(
          type: IntervalPhaseType.recovery,
          duration: Duration(seconds: recSec),
        ),
      );
    }
    return intervals;
  }
}
