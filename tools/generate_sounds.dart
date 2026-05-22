import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'dart:typed_data';

const _sampleRate = 22050;
const _volume = 0.55;

void main() {
  final outDir = Directory('assets/sounds');
  outDir.createSync(recursive: true);

  generate('start.wav', 300, _ascendingTone(440, 880));
  generate('pause.wav', 200, _descendingTone(660, 330));
  generate('countdown_beep.wav', 120, _tone(880, _square));
  generate('go.wav', 500, _doubleBeep(660, 880));
  generate('lap.wav', 400, _twoToneChime(523, 659));
  generate('complete.wav', 1000, _arpeggio([523, 659, 784, 1047]));
  generate('alert.wav', 350, _pulseTone(440, 2));
  generate('phase_change.wav', 300, _swoosh(300, 900));
  generate('split.wav', 250, _bellTone(784));

  log('Generated ${outDir.listSync().length} sound files in $outDir');
}

void generate(String name, int durationMs, double Function(double) gen) {
  final path = 'assets/sounds/$name';
  final numSamples = (_sampleRate * durationMs / 1000).round();
  final data = Int16List(numSamples);

  for (int i = 0; i < numSamples; i++) {
    final t = i / _sampleRate;
    var sample = gen(t);

    final fadeLen = (_sampleRate * 0.005).round();
    if (i < fadeLen) {
      sample *= i / fadeLen;
    }
    if (i > numSamples - fadeLen) {
      sample *= (numSamples - i) / fadeLen;
    }

    data[i] = (sample * 32767).round().clamp(-32768, 32767);
  }

  final dataSize = numSamples * 2;
  final header = BytesBuilder();
  header.add(_utf8('RIFF'));
  header.add(_le32(36 + dataSize));
  header.add(_utf8('WAVE'));
  header.add(_utf8('fmt '));
  header.add(_le32(16));
  header.add(_le16(1));
  header.add(_le16(1));
  header.add(_le32(_sampleRate));
  header.add(_le32(_sampleRate * 2));
  header.add(_le16(2));
  header.add(_le16(16));
  header.add(_utf8('data'));
  header.add(_le32(dataSize));
  header.add(data.buffer.asUint8List());

  File(path).writeAsBytesSync(header.toBytes());
}

double Function(double) _tone(double freq, double Function(double) wave) {
  return (double t) => _volume * wave(2 * pi * freq * t);
}

double Function(double) _ascendingTone(double f0, double f1) {
  return (double t) {
    final freq = f0 + (f1 - f0) * (t / 0.3);
    return _volume * sin(2 * pi * freq * t);
  };
}

double Function(double) _descendingTone(double f0, double f1) {
  return (double t) {
    final freq = f0 + (f1 - f0) * (t / 0.2);
    return _volume * sin(2 * pi * freq * t);
  };
}

double Function(double) _doubleBeep(double f1, double f2) {
  return (double t) {
    if (t < 0.15) return _volume * sin(2 * pi * f1 * t);
    if (t < 0.2) return 0.0;
    if (t < 0.5) return _volume * sin(2 * pi * f2 * (t - 0.2));
    return 0.0;
  };
}

double Function(double) _twoToneChime(double f1, double f2) {
  return (double t) {
    if (t < 0.2) return _volume * sin(2 * pi * f1 * t);
    return _volume * sin(2 * pi * f2 * t);
  };
}

double Function(double) _arpeggio(List<double> freqs) {
  final noteLen = 0.25;
  return (double t) {
    for (int i = 0; i < freqs.length; i++) {
      final start = i * noteLen;
      if (t >= start && t < start + noteLen) {
        return _volume * sin(2 * pi * freqs[i] * (t - start));
      }
    }
    return 0.0;
  };
}

double Function(double) _pulseTone(double freq, int pulses) {
  final pulseLen = 0.1;
  final gapLen = 0.075;
  return (double t) {
    for (int i = 0; i < pulses; i++) {
      final start = i * (pulseLen + gapLen);
      if (t >= start && t < start + pulseLen) {
        return _volume * sin(2 * pi * freq * (t - start));
      }
    }
    return 0.0;
  };
}

double Function(double) _swoosh(double f0, double f1) {
  return (double t) {
    final freq = f0 + (f1 - f0) * (t / 0.3);
    return _volume * sin(2 * pi * freq * t);
  };
}

double Function(double) _bellTone(double freq) {
  return (double t) {
    final env = exp(-t * 8);
    return _volume * env * sin(2 * pi * freq * t);
  };
}

double _square(double phase) => sin(phase) > 0 ? 1.0 : -1.0;

List<int> _le16(int v) => [v & 0xFF, (v >> 8) & 0xFF];
List<int> _le32(int v) => [
      v & 0xFF,
      (v >> 8) & 0xFF,
      (v >> 16) & 0xFF,
      (v >> 24) & 0xFF,
    ];
List<int> _utf8(String s) => s.codeUnits;
