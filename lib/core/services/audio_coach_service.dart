import 'package:flutter_tts/flutter_tts.dart';

import '../../presentation/widgets/run_session/run_session_state.dart';

class AudioCoachService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      _initialized = true;
    } catch (_) {}
  }

  Future<void> announcePhaseChange(WorkoutPhase phase) async {
    final msg = switch (phase) {
      WorkoutPhase.warmup => 'Starting warm up',
      WorkoutPhase.work => 'Start running',
      WorkoutPhase.cooldown => 'Begin cool down',
      WorkoutPhase.finished => 'Workout complete',
    };
    await speak(msg);
  }

  Future<void> announceSplit(int km, int paceSecondsPerKm) async {
    final paceMin = paceSecondsPerKm ~/ 60;
    final paceSec = paceSecondsPerKm % 60;
    await speak('Kilometer $km, $paceMin:$paceSec per kilometer');
  }

  Future<void> announcePaceAlert(String message) async {
    await speak(message);
  }

  Future<void> announceWorkoutComplete() async {
    await speak('Workout complete. Great job!');
  }

  Future<void> announceCountdown(int seconds) async {
    if (seconds > 3) return;
    await speak(seconds == 0 ? 'Go!' : '$seconds');
  }

  Future<void> speak(String message) async {
    if (!_initialized) return;
    try {
      await _tts.speak(message);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
