import 'package:audioplayers/audioplayers.dart';

class SoundEffectsService {
  final AudioPlayer _player = AudioPlayer();
  final Map<String, AudioPlayer> _cache = {};

  Future<void> playStart() => _play('start.wav');
  Future<void> playPause() => _play('pause.wav');
  Future<void> playCountdown() => _play('countdown_beep.wav');
  Future<void> playGo() => _play('go.wav');
  Future<void> playLap() => _play('lap.wav');
  Future<void> playComplete() => _play('complete.wav');
  Future<void> playAlert() => _play('alert.wav');
  Future<void> playPhaseChange() => _play('phase_change.wav');
  Future<void> playSplit() => _play('split.wav');

  Future<void> _play(String name) async {
    try {
      final source = AssetSource('sounds/$name');
      await _player.stop();
      await _player.play(source);
    } catch (_) {}
  }

  void dispose() {
    _player.dispose();
    for (final p in _cache.values) {
      p.dispose();
    }
  }
}
