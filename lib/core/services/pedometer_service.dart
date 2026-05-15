import 'dart:async';

import 'package:pedometer/pedometer.dart';

class PedometerService {
  double strideLength = 0.75;
  int _startSteps = 0;
  int _lastSteps = 0;
  bool _initialized = false;
  bool _available = false;

  /// Stream of step counts since start. Emits 0 if pedometer unavailable.
  Stream<int> trackSteps() {
    return Pedometer.stepCountStream
        .map((event) => event.steps)
        .handleError((_) => _available = false);
  }

  /// Check if device has a step counter sensor.
  /// Subscribes briefly and resolves true if data arrives within [timeout].
  Future<bool> isAvailable({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (_available) return true;
    try {
      await Pedometer.stepCountStream.first.timeout(timeout);
      _available = true;
    } catch (_) {
      _available = false;
    }
    return _available;
  }

  void initialize(int steps) {
    if (!_initialized) {
      _startSteps = steps;
      _lastSteps = steps;
      _initialized = true;
    }
  }

  void updateSteps(int steps) {
    if (!_initialized) initialize(steps);
    _lastSteps = steps;
  }

  int get stepsSinceStart => _initialized ? (_lastSteps - _startSteps) : 0;

  void calibrateStrideLength(double distanceMeters) {
    final steps = stepsSinceStart;
    if (steps > 20) {
      strideLength = distanceMeters / steps;
    }
  }

  double stepsToDistance(int steps) => steps * strideLength;
}
