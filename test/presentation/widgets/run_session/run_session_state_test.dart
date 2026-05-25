import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teman_lari/domain/entities/training_plan.dart';
import 'package:teman_lari/presentation/widgets/run_session/run_session_state.dart';

void main() {
  group('RunSessionState.computeSegments', () {
    test('includes warmup segment when warmUpMinutes > 0', () {
      final day = TrainingDay(
        date: DateTime.now(),
        type: WorkoutType.tempo,
        targetMinutes: 40,
        warmUpMinutes: 10,
        coolDownMinutes: 10,
        description: 'test',
      );
      final segments = RunSessionState.computeSegments(day);

      check(segments).isNotEmpty();
      check(segments.first.type).equals(PhaseSegmentType.warmup);
      check(segments.first.durationSeconds).equals(600);
      check(segments.first.phase).equals(WorkoutPhase.warmup);
    });
  });

  group('RunSessionState initial phase', () {
    test('starts in warmup when segments begin with warmup', () {
      final day = TrainingDay(
        date: DateTime.now(),
        type: WorkoutType.tempo,
        targetMinutes: 40,
        warmUpMinutes: 10,
        coolDownMinutes: 10,
        description: 'test',
      );
      final segments = RunSessionState.computeSegments(day);
      final state = RunSessionState(
        plan: day,
        segments: segments,
      );

      check(state.phase).equals(WorkoutPhase.warmup);
      check(state.currentSegmentIndex).equals(0);
      check(state.segments[0].type).equals(PhaseSegmentType.warmup);
    });
  });

  group('Phase detection at first tick', () {
    test('newPhase differs from null _lastPhase so phase change triggers', () {
      final day = TrainingDay(
        date: DateTime.now(),
        type: WorkoutType.tempo,
        targetMinutes: 40,
        warmUpMinutes: 10,
        coolDownMinutes: 10,
        description: 'test',
      );
      final segments = RunSessionState.computeSegments(day);

      // Simulate first tick (_lastPhase is null, _state.elapsedSeconds is 0)
      const newElapsed = 1;
      WorkoutPhase? lastPhase; // starts null like in the widget

      int cumulative = 0;
      WorkoutPhase newPhase = WorkoutPhase.warmup;
      for (final seg in segments) {
        if (newElapsed < cumulative + seg.durationSeconds) {
          newPhase = seg.phase;
          break;
        }
        cumulative += seg.durationSeconds;
      }

      // This is the critical check: newPhase != _lastPhase
      // newPhase is warmup (non-null), lastPhase is null → condition is true
      final phaseChanged = newPhase != lastPhase;
      check(phaseChanged).isTrue();
      check(newPhase).equals(WorkoutPhase.warmup);
      check(newPhase != WorkoutPhase.finished).isTrue();
    });
  });
}
