import 'package:teman_lari/domain/entities/training_plan.dart';

enum WorkoutPhase { warmup, work, cooldown, finished }

class RunSessionState {
  final TrainingDay plan;
  final WorkoutPhase phase;
  final int elapsedSeconds;
  final int? currentPaceSecondsPerKm;
  final double distanceKm;
  final bool isRunning;
  final bool isLocked;
  final bool isAudioCoachOn;

  const RunSessionState({
    required this.plan,
    this.phase = WorkoutPhase.warmup,
    this.elapsedSeconds = 0,
    this.currentPaceSecondsPerKm,
    this.distanceKm = 0.0,
    this.isRunning = false,
    this.isLocked = false,
    this.isAudioCoachOn = true,
  });

  int get warmUpSeconds => (plan.warmUpMinutes ?? 0) * 60;
  int get coolDownSeconds => (plan.coolDownMinutes ?? 0) * 60;
  int get workSeconds => (plan.workMinutes ?? 0) * 60;
  int get totalSeconds => warmUpSeconds + workSeconds + coolDownSeconds;

  int get phaseElapsedSeconds {
    switch (phase) {
      case WorkoutPhase.warmup:
        return elapsedSeconds;
      case WorkoutPhase.work:
        return elapsedSeconds - warmUpSeconds;
      case WorkoutPhase.cooldown:
        return elapsedSeconds - warmUpSeconds - workSeconds;
      case WorkoutPhase.finished:
        return 0;
    }
  }

  int get phaseDurationSeconds {
    switch (phase) {
      case WorkoutPhase.warmup:
        return warmUpSeconds;
      case WorkoutPhase.work:
        return workSeconds;
      case WorkoutPhase.cooldown:
        return coolDownSeconds;
      case WorkoutPhase.finished:
        return 0;
    }
  }

  double get phaseProgress => phaseDurationSeconds > 0
      ? phaseElapsedSeconds / phaseDurationSeconds
      : 0.0;

  double get totalProgress =>
      totalSeconds > 0 ? elapsedSeconds / totalSeconds : 0.0;

  int get remainingSeconds =>
      (totalSeconds - elapsedSeconds).clamp(0, totalSeconds);

  Duration get fastestTarget =>
      plan.paceTarget?.fastestPace ?? const Duration(seconds: 300);
  Duration get slowestTarget =>
      plan.paceTarget?.slowestPace ?? const Duration(seconds: 360);
  int get targetMidSeconds =>
      (fastestTarget.inSeconds + slowestTarget.inSeconds) ~/ 2;
}
