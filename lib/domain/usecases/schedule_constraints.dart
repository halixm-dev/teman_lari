import '../entities/workout_type.dart';

/// Packages scheduling rules per user segment so the dynamic path
/// can enforce beginner / return-ramp / deload constraints without
/// hardcoded static sequences.
class ScheduleConstraints {
  /// Workout types the scheduler is allowed to assign.
  final Set<WorkoutType> allowedTypes;

  /// Maximum running days in the planned 7-day window.
  final int maxRunsPerWeek;

  /// Maximum consecutive running days before a forced rest.
  final int maxConsecutiveRunDays;

  const ScheduleConstraints({
    required this.allowedTypes,
    required this.maxRunsPerWeek,
    required this.maxConsecutiveRunDays,
  });

  /// Beginner (<15 runs): easy + rest only, max 3/wk, strict alternation.
  static const beginner = ScheduleConstraints(
    allowedTypes: {WorkoutType.easy, WorkoutType.rest},
    maxRunsPerWeek: 3,
    maxConsecutiveRunDays: 1,
  );

  /// Returning runner (early ramp): easy + rest only, strict alternation.
  static const returnRampEasy = ScheduleConstraints(
    allowedTypes: {WorkoutType.easy, WorkoutType.rest},
    maxRunsPerWeek: 3,
    maxConsecutiveRunDays: 1,
  );

  /// Returning runner (later ramp): adds tempo + long run back.
  static const returnRampFull = ScheduleConstraints(
    allowedTypes: {
      WorkoutType.easy,
      WorkoutType.tempo,
      WorkoutType.longRun,
      WorkoutType.rest,
    },
    maxRunsPerWeek: 4,
    maxConsecutiveRunDays: 2,
  );

  /// Deload week (advanced, week 3): easy + rest only, strict alternation.
  static const deload = ScheduleConstraints(
    allowedTypes: {WorkoutType.easy, WorkoutType.rest},
    maxRunsPerWeek: 3,
    maxConsecutiveRunDays: 1,
  );

  /// Transition phase (runs 15-22): easy + rest only, max 3 days/wk.
  static const transition = ScheduleConstraints(
    allowedTypes: {WorkoutType.easy, WorkoutType.rest},
    maxRunsPerWeek: 3,
    maxConsecutiveRunDays: 2,
  );

  /// TSB Danger state (< -20): deload week rules
  static const tsbDanger = ScheduleConstraints(
    allowedTypes: {WorkoutType.easy, WorkoutType.rest, WorkoutType.crossTraining},
    maxRunsPerWeek: 3,
    maxConsecutiveRunDays: 1,
  );

  /// TSB Fatigued state (< -15): Z1 only
  static const tsbFatigued = ScheduleConstraints(
    allowedTypes: {WorkoutType.easy, WorkoutType.rest, WorkoutType.crossTraining},
    maxRunsPerWeek: 4,
    maxConsecutiveRunDays: 2,
  );

  /// TSB Tired state (< -10): no intervals
  static const tsbTired = ScheduleConstraints(
    allowedTypes: {
      WorkoutType.easy,
      WorkoutType.tempo,
      WorkoutType.longRun,
      WorkoutType.rest,
      WorkoutType.crossTraining,
    },
    maxRunsPerWeek: 4,
    maxConsecutiveRunDays: 3,
  );

  /// Normal scheduling: all workout types, 80/20 rule enforced elsewhere.
  static const normal = ScheduleConstraints(
    allowedTypes: {
      WorkoutType.easy,
      WorkoutType.tempo,
      WorkoutType.intervals,
      WorkoutType.longRun,
      WorkoutType.rest,
      WorkoutType.crossTraining,
    },
    maxRunsPerWeek: 7, // effectively uncapped; 80/20 logic caps hard sessions
    maxConsecutiveRunDays: 3,
  );

  /// Whether [type] is permitted by these constraints.
  bool allows(WorkoutType type) => allowedTypes.contains(type);

  /// Whether [type] is a running (non-rest) workout.
  static bool isRunning(WorkoutType type) =>
      type != WorkoutType.rest && type != WorkoutType.crossTraining;
}
