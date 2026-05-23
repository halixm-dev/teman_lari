import 'dart:io' show Platform;

import 'package:flutter_tts/flutter_tts.dart';

import '../../presentation/widgets/run_session/run_session_state.dart';

/// Audio coach script samples (spoken aloud during run):
///
///   Phase change:   "Starting warm up" / "Start running" / "Begin cool down"
///   KM split:       "Kilometer 5, 5:42 per kilometer"
///   Pace alert:     "You're ahead of pace, slow down to 5:30"
///   Workout done:   "Workout complete. Great job!"
///   Countdown:      "3… 2… 1… Go!"
class AudioCoachService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _ssmlSupported = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      _initialized = true;
      _ssmlSupported = Platform.isAndroid || Platform.isIOS;
    } catch (_) {}
  }

  /// "Starting warm up" / "Start running" / "Begin cool down"
  Future<void> announcePhaseChange(WorkoutPhase phase) async {
    final msg = switch (phase) {
      WorkoutPhase.warmup => 'Starting warm up',
      WorkoutPhase.work => 'Start running',
      WorkoutPhase.recovery => 'Recovery jog',
      WorkoutPhase.walk => 'Start walking',
      WorkoutPhase.cooldown => 'Begin cool down',
      WorkoutPhase.finished => 'Workout complete',
    };
    await _speakMilestone(msg);
  }

  /// "Kilometer 5, 5:42 per kilometer"
  Future<void> announceSplit(int km, int paceSecondsPerKm) async {
    final paceMin = paceSecondsPerKm ~/ 60;
    final paceSec = paceSecondsPerKm % 60;
    await _speakMilestone('Kilometer $km, $paceMin:$paceSec per kilometer');
  }

  /// "You're ahead of pace, slow down to 5:30"
  Future<void> announcePaceAlert(String message) async {
    await _speakPaced(message);
  }

  /// "Workout complete. Great job!"
  Future<void> announceWorkoutComplete() async {
    await _speakMilestone('Workout complete. Great job!');
  }

  /// "3… 2… 1… Go!"
  Future<void> announceCountdown(int seconds) async {
    if (seconds > 3) return;
    await speak(seconds == 0 ? 'Go!' : '$seconds');
  }

  Future<void> speak(String message) async {
    if (!_initialized) return;
    try {
      final text = _ssmlSupported ? '<speak>$message</speak>' : message;
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> _speakPaced(String message) async {
    if (!_initialized) return;
    try {
      final text = _ssmlSupported
          ? '<speak><emphasis level="moderate">$message</emphasis></speak>'
          : message;
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> _speakMilestone(String message) async {
    if (!_initialized) return;
    try {
      final text = _ssmlSupported
          ? '<speak><prosody pitch="+5%" rate="95%">$message</prosody></speak>'
          : message;
      await _tts.speak(text);
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
