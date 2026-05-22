import 'package:teman_lari/domain/entities/training_plan.dart';

enum WorkoutPhase { warmup, work, cooldown, finished }

enum PhaseSegmentType { warmup, work, recovery, cooldown }

class PhaseSegment {
  final PhaseSegmentType type;
  final int durationSeconds;

  const PhaseSegment({required this.type, required this.durationSeconds});

  WorkoutPhase get phase => switch (type) {
        PhaseSegmentType.warmup => WorkoutPhase.warmup,
        PhaseSegmentType.work => WorkoutPhase.work,
        PhaseSegmentType.recovery => WorkoutPhase.work,
        PhaseSegmentType.cooldown => WorkoutPhase.cooldown,
      };
}

class RunSessionState {
  final TrainingDay plan;
  final WorkoutPhase phase;
  final int elapsedSeconds;
  final int? currentPaceSecondsPerKm;
  final double distanceKm;
  final bool isRunning;
  final bool isLocked;
  final bool isAudioCoachOn;
  final List<PhaseSegment> segments;

  const RunSessionState({
    required this.plan,
    this.phase = WorkoutPhase.warmup,
    this.elapsedSeconds = 0,
    this.currentPaceSecondsPerKm,
    this.distanceKm = 0.0,
    this.isRunning = false,
    this.isLocked = false,
    this.isAudioCoachOn = true,
    this.segments = const [],
  });

  int get warmUpSeconds => (plan.warmUpMinutes ?? 0) * 60;
  int get coolDownSeconds => (plan.coolDownMinutes ?? 0) * 60;
  int get workSeconds => (plan.workMinutes ?? 0) * 60;
  int get totalSeconds => segments.fold(0, (sum, s) => sum + s.durationSeconds);

  int get phaseElapsedSeconds {
    int elapsed = 0;
    for (final seg in segments) {
      if (seg.phase == phase) {
        return (elapsedSeconds - elapsed).clamp(0, seg.durationSeconds);
      }
      elapsed += seg.durationSeconds;
    }
    return 0;
  }

  int get phaseDurationSeconds {
    for (final seg in segments) {
      if (seg.phase == phase) return seg.durationSeconds;
    }
    return 0;
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

  int get currentSegmentIndex {
    int elapsed = 0;
    for (int i = 0; i < segments.length; i++) {
      if (elapsedSeconds < elapsed + segments[i].durationSeconds) return i;
      elapsed += segments[i].durationSeconds;
    }
    return segments.isEmpty ? 0 : segments.length - 1;
  }

  static List<PhaseSegment> computeSegments(TrainingDay plan) {
    final segments = <PhaseSegment>[];
    final warmup = (plan.warmUpMinutes ?? 0) * 60;
    final cooldown = (plan.coolDownMinutes ?? 0) * 60;

    if (warmup > 0) {
      segments.add(PhaseSegment(
        type: PhaseSegmentType.warmup,
        durationSeconds: warmup,
      ));
    }

    final intervals = plan.intervals;
    if (plan.type == WorkoutType.intervals &&
        intervals != null &&
        intervals.isNotEmpty) {
      for (final interval in intervals) {
        segments.add(PhaseSegment(
          type: interval.type == IntervalPhaseType.work
              ? PhaseSegmentType.work
              : PhaseSegmentType.recovery,
          durationSeconds: interval.duration.inSeconds,
        ));
      }
    } else {
      final workMins = plan.workMinutes;
      if (workMins != null && workMins > 0) {
        segments.add(PhaseSegment(
          type: PhaseSegmentType.work,
          durationSeconds: workMins * 60,
        ));
      }
    }

    if (cooldown > 0) {
      segments.add(PhaseSegment(
        type: PhaseSegmentType.cooldown,
        durationSeconds: cooldown,
      ));
    }

    return segments;
  }
}
