import 'package:teman_lari/domain/entities/training_plan.dart';

enum WorkoutPhase { warmup, work, recovery, walk, cooldown, finished }

enum PhaseSegmentType { warmup, work, recovery, walk, cooldown }

class PhaseSegment {
  final PhaseSegmentType type;
  final int durationSeconds;

  const PhaseSegment({required this.type, required this.durationSeconds});

  WorkoutPhase get phase => switch (type) {
    PhaseSegmentType.warmup => WorkoutPhase.warmup,
    PhaseSegmentType.work => WorkoutPhase.work,
    PhaseSegmentType.recovery => WorkoutPhase.recovery,
    PhaseSegmentType.walk => WorkoutPhase.walk,
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
    if (segments.isEmpty || phase == WorkoutPhase.finished) return 0;
    int elapsed = 0;
    for (int i = 0; i < currentSegmentIndex; i++) {
      elapsed += segments[i].durationSeconds;
    }
    return (elapsedSeconds - elapsed).clamp(
      0,
      segments[currentSegmentIndex].durationSeconds,
    );
  }

  int get phaseDurationSeconds {
    if (segments.isEmpty || phase == WorkoutPhase.finished) return 0;
    return segments[currentSegmentIndex].durationSeconds;
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
      segments.add(
        PhaseSegment(type: PhaseSegmentType.warmup, durationSeconds: warmup),
      );
    }

    final intervals = plan.intervals;
    final runWalk = plan.runWalkPhase;

    if (runWalk != null && !runWalk.isContinuous) {
      final workMins = plan.workMinutes ?? runWalk.totalDurationMinutes;
      if (workMins > 0) {
        final totalWorkSeconds = workMins * 60;
        int elapsed = 0;
        while (elapsed < totalWorkSeconds) {
          if (runWalk.runSeconds > 0) {
            final remaining = totalWorkSeconds - elapsed;
            final dur = runWalk.runSeconds < remaining
                ? runWalk.runSeconds
                : remaining;
            segments.add(
              PhaseSegment(type: PhaseSegmentType.work, durationSeconds: dur),
            );
            elapsed += dur;
          }
          if (elapsed >= totalWorkSeconds) break;
          if (runWalk.walkSeconds > 0) {
            final remaining = totalWorkSeconds - elapsed;
            final dur = runWalk.walkSeconds < remaining
                ? runWalk.walkSeconds
                : remaining;
            segments.add(
              PhaseSegment(type: PhaseSegmentType.walk, durationSeconds: dur),
            );
            elapsed += dur;
          }
        }
      }
    } else if (plan.type == WorkoutType.intervals &&
        intervals != null &&
        intervals.isNotEmpty) {
      for (final interval in intervals) {
        segments.add(
          PhaseSegment(
            type: interval.type == IntervalPhaseType.work
                ? PhaseSegmentType.work
                : PhaseSegmentType.recovery,
            durationSeconds: interval.duration.inSeconds,
          ),
        );
      }
    } else {
      final workMins = plan.workMinutes;
      if (workMins != null && workMins > 0) {
        segments.add(
          PhaseSegment(
            type: PhaseSegmentType.work,
            durationSeconds: workMins * 60,
          ),
        );
      }
    }

    if (cooldown > 0) {
      segments.add(
        PhaseSegment(
          type: PhaseSegmentType.cooldown,
          durationSeconds: cooldown,
        ),
      );
    }

    return segments;
  }
}
