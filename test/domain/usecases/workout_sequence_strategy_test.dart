import 'package:flutter_test/flutter_test.dart';
import 'package:teman_lari/domain/entities/return_context.dart';
import 'package:teman_lari/domain/entities/analyzed_activity.dart';
import 'package:teman_lari/domain/entities/activity.dart';
import 'package:teman_lari/domain/entities/running_stats.dart';
import 'package:teman_lari/domain/entities/workout_type.dart';
import 'package:teman_lari/domain/usecases/training_plan_config.dart';
import 'package:teman_lari/domain/usecases/workout_sequence_strategy.dart';

void main() {
  const config = TrainingPlanConfig();
  const strategy = DynamicWorkoutSequenceStrategy();

  Activity activity({
    required DateTime date,
    double distanceKm = 3.0,
    Duration movingTime = const Duration(minutes: 20),
    Duration pace = const Duration(seconds: 450),
  }) {
    return Activity(
      type: ActivityType.run,
      id: date.millisecondsSinceEpoch,
      name: 'Run',
      date: date,
      distanceKm: distanceKm,
      movingTime: movingTime,
      pace: pace,
      elevationGainM: 0,
      trainingLoad: TrainingLoad.easy,
    );
  }

  RunningStats beginnerStats({
    int totalRuns = 5,
    ReturnContext? returnCtx,
    List<Activity>? activities,
  }) {
    return RunningStats(
      totalRuns: totalRuns,
      totalDistanceKm: totalRuns * 3.0,
      weeklyVolume: {'2026-W20': 9.0},
      weeklyMinutes: {'2026-W20': 60.0},
      averagePace: const Duration(minutes: 7),
      paceProgression: [],
      heartRateZones: {},
      trainingLoadHistory: [],
      vo2MaxEstimate: null,
      fitnessScore: 0,
      fatigueScore: 0,
      formScore: 0,
      returnContext: returnCtx,
      recommendedPhase: CyclePhase.beginner,
      analyzedActivities:
          activities
              ?.map<AnalyzedActivity>(
                (a) => AnalyzedActivity(activity: a, type: WorkoutType.easy),
              )
              .toList() ??
          [],
    );
  }

  RunningStats advancedStats({
    int totalRuns = 60,
    ReturnContext? returnCtx,
    List<Activity>? activities,
  }) {
    return RunningStats(
      totalRuns: totalRuns,
      totalDistanceKm: totalRuns * 8.0,
      weeklyVolume: {'2026-W20': 50.0},
      weeklyMinutes: {'2026-W20': 300.0},
      averagePace: const Duration(minutes: 5, seconds: 30),
      paceProgression: [],
      heartRateZones: {},
      trainingLoadHistory: [],
      vo2MaxEstimate: 50.0,
      fitnessScore: 30,
      fatigueScore: 10,
      formScore: 20,
      returnContext: returnCtx,
      recommendedPhase: CyclePhase.advanced,
      analyzedActivities:
          activities
              ?.map<AnalyzedActivity>(
                (a) => AnalyzedActivity(activity: a, type: WorkoutType.easy),
              )
              .toList() ??
          [],
    );
  }

  group('Beginner scheduling (totalRuns < 15)', () {
    test('after a run today, day 1 (tomorrow) should be rest', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final activities = [
        activity(date: today),
        activity(date: today.subtract(const Duration(days: 2))),
        activity(date: today.subtract(const Duration(days: 4))),
      ];

      final sequence = strategy.determineSequence(
        stats: beginnerStats(totalRuns: 5, activities: activities),
        config: config,
        recentActivities: activities,

        weekInCycle: -1,
      );

      // Plan starts tomorrow (since ran today). Tomorrow must be rest.
      expect(
        sequence[0],
        equals(WorkoutType.rest),
        reason: 'Day after a run should be rest for beginners',
      );
    });

    test('with no recent runs (3 days ago), day 1 should be easy', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final activities = [
        activity(date: today.subtract(const Duration(days: 3))),
        activity(date: today.subtract(const Duration(days: 5))),
        activity(date: today.subtract(const Duration(days: 7))),
      ];

      final sequence = strategy.determineSequence(
        stats: beginnerStats(totalRuns: 5, activities: activities),
        config: config,
        recentActivities: activities,

        weekInCycle: -1,
      );

      // Plan starts today (no run today). Should be easy since rested 3 days.
      expect(
        sequence[0],
        equals(WorkoutType.easy),
        reason: 'After 3 rest days, next workout should be easy',
      );
    });

    test('strict alternation — no two consecutive run days', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final activities = [
        activity(date: today.subtract(const Duration(days: 1))),
        activity(date: today.subtract(const Duration(days: 3))),
      ];

      final sequence = strategy.determineSequence(
        stats: beginnerStats(totalRuns: 5, activities: activities),
        config: config,
        recentActivities: activities,

        weekInCycle: -1,
      );

      // Verify no two consecutive running days
      for (int i = 0; i < sequence.length - 1; i++) {
        if (sequence[i] != WorkoutType.rest) {
          expect(
            sequence[i + 1],
            equals(WorkoutType.rest),
            reason: 'Beginner day ${i + 1} after a run day $i should be rest',
          );
        }
      }
    });

    test('max 3 running days per week', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final activities = [
        activity(date: today.subtract(const Duration(days: 7))),
      ];

      final sequence = strategy.determineSequence(
        stats: beginnerStats(totalRuns: 5, activities: activities),
        config: config,
        recentActivities: activities,

        weekInCycle: -1,
      );

      final runDays = sequence.where((w) => w != WorkoutType.rest).length;
      expect(
        runDays,
        lessThanOrEqualTo(3),
        reason: 'Beginners should have at most 3 running days per week',
      );
    });
  });

  group('Return ramp scheduling', () {
    test('returning runner after a run today, day 1 should be rest', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final returnCtx = ReturnContext(
        gapDays: 10,
        category: GapCategory.long,
        preGapAvgKm: 30,
        preGapAvgMin: 180,
        lastActivityDate: today.subtract(const Duration(days: 10)),
      );
      final activities = [activity(date: today)];

      final sequence = strategy.determineSequence(
        stats: beginnerStats(
          totalRuns: 20,
          returnCtx: returnCtx,
          activities: activities,
        ),
        config: config,
        recentActivities: activities,

        weekInCycle: -1,
      );

      expect(
        sequence[0],
        equals(WorkoutType.rest),
        reason: 'Return ramp: day after a run should be rest',
      );
    });
  });

  group('Deload scheduling (weekInCycle == 3, advanced)', () {
    test('deload after a run today, day 1 should be rest', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final activities = [
        activity(date: today),
        activity(date: today.subtract(const Duration(days: 2))),
        activity(date: today.subtract(const Duration(days: 4))),
      ];

      final sequence = strategy.determineSequence(
        stats: advancedStats(activities: activities),
        config: config,
        recentActivities: activities,

        weekInCycle: 3,
      );

      expect(
        sequence[0],
        equals(WorkoutType.rest),
        reason: 'Deload: day after a run should be rest',
      );
    });
  });
}
