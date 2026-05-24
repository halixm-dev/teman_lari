import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/widgets/run_session/run_session_state.dart';

part 'voice_coach_service.g.dart';

@riverpod
VoiceCoachService voiceCoach(Ref ref) {
  final service = VoiceCoachService();
  ref.onDispose(() => service.dispose());
  return service;
}

class VoiceCoachService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> announcePhaseChange(WorkoutPhase phase) async {
    final file = switch (phase) {
      WorkoutPhase.warmup => 'voice_warmup.wav',
      WorkoutPhase.work => 'voice_work.wav',
      WorkoutPhase.recovery => 'voice_recovery.wav',
      WorkoutPhase.walk => 'voice_walk.wav',
      WorkoutPhase.cooldown => 'voice_cooldown.wav',
      WorkoutPhase.finished => 'voice_complete.wav',
    };
    await _play(file);
  }

  Future<void> announceMidpoint() async {
    await _play('voice_midpoint.wav');
  }

  Future<void> announceWorkoutComplete() async {
    await _play('voice_complete.wav');
  }

  Future<void> _play(String name) async {
    try {
      final source = AssetSource('sounds/$name');
      await _player.stop();
      await _player.play(source);
    } catch (_) {}
  }

  void dispose() {
    _player.dispose();
  }
}
