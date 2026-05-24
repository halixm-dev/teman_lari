import 'package:audioplayers/audioplayers.dart';

class SoundEffectsService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playPause() => _play('pause.wav');

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
