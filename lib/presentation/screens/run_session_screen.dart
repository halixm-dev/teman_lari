import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/gps_service.dart';
import '../../core/services/pedometer_service.dart';
import '../../domain/entities/training_plan.dart';
import '../widgets/run_session/run_controls.dart';
import '../widgets/run_session/run_pacer_display.dart';
import '../widgets/run_session/run_secondary_metrics.dart';
import '../widgets/run_session/run_session_state.dart';
import '../widgets/run_session/run_timer_display.dart';

enum PaceSource { gps, pedometer, none }

class RunSessionScreen extends StatefulWidget {
  final TrainingDay day;

  const RunSessionScreen({super.key, required this.day});

  @override
  State<RunSessionScreen> createState() => _RunSessionScreenState();
}

class _RunSessionScreenState extends State<RunSessionScreen> {
  late RunSessionState _state;
  Timer? _timer;

  final _gpsService = GpsService();
  final _pedometerService = PedometerService();
  StreamSubscription<Position>? _gpsSubscription;
  StreamSubscription<int>? _pedometerSubscription;

  // GPS state
  double _smoothedSpeed = 0.0;
  Position? _lastPosition;
  int _gpsPaceSeconds = 0;
  DateTime? _lastGpsUpdate;
  bool _gpsPermissionGranted = false;
  bool _gpsHasFix = false;

  // Pedometer state
  int _lastStepCount = 0;
  final List<int> _stepHistory = [];

  PaceSource _paceSource = PaceSource.none;

  static const double _smoothingAlpha = 0.4;
  static const Duration _gpsTimeout = Duration(seconds: 10);
  static const double _minGpsSpeed = 0.5;
  static const int _stepWindowSize = 10;

  @override
  void initState() {
    super.initState();
    final plan = widget.day;
    _state = RunSessionState(plan: plan, currentPaceSecondsPerKm: null);
    _initSensors();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _gpsSubscription?.cancel();
    _pedometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initSensors() async {
    _gpsPermissionGranted = await _gpsService.requestPermission();
    if (_gpsPermissionGranted) {
      _gpsSubscription = _gpsService.trackPosition().listen(
        _onGpsPosition,
        onError: (_) {
          if (mounted) setState(() => _gpsHasFix = false);
        },
      );
    }

    _pedometerSubscription = _pedometerService.trackSteps().listen(
      _onPedometerStep,
      onError: (_) {},
    );
  }

  void _onGpsPosition(Position pos) {
    _gpsHasFix = true;
    _lastGpsUpdate = DateTime.now();

    if (!_state.isRunning) {
      _paceSource = PaceSource.gps;
      setState(() {});
    }

    final rawSpeed = pos.speed;

    if (rawSpeed > 0) {
      if (_smoothedSpeed == 0) {
        _smoothedSpeed = rawSpeed;
      } else {
        _smoothedSpeed =
            _smoothingAlpha * rawSpeed + (1 - _smoothingAlpha) * _smoothedSpeed;
      }
    } else if (_lastPosition != null) {
      final last = _lastPosition!;
      final dist = Geolocator.distanceBetween(
        last.latitude,
        last.longitude,
        pos.latitude,
        pos.longitude,
      );
      final timeDelta = pos.timestamp
          .difference(last.timestamp)
          .inSeconds
          .clamp(1, 60);
      if (dist < 200) {
        final calcSpeed = dist / timeDelta;
        if (_smoothedSpeed == 0) {
          _smoothedSpeed = calcSpeed;
        } else {
          _smoothedSpeed =
              _smoothingAlpha * calcSpeed +
              (1 - _smoothingAlpha) * _smoothedSpeed;
        }
      }
    }

    if (_smoothedSpeed > _minGpsSpeed) {
      _gpsPaceSeconds = (1000 / _smoothedSpeed).round();
    }

    if (pos.accuracy < 50 && _lastPosition != null) {
      final last = _lastPosition!;
      final dist = Geolocator.distanceBetween(
        last.latitude,
        last.longitude,
        pos.latitude,
        pos.longitude,
      );
      if (dist > 0 && dist < 200) {
        setState(() {
          _state = RunSessionState(
            plan: _state.plan,
            phase: _state.phase,
            elapsedSeconds: _state.elapsedSeconds,
            currentPaceSecondsPerKm: _state.currentPaceSecondsPerKm,
            distanceKm: _state.distanceKm + dist / 1000.0,
            isRunning: _state.isRunning,
            isLocked: _state.isLocked,
            isAudioCoachOn: _state.isAudioCoachOn,
          );
        });
        _pedometerService.calibrateStrideLength(dist);
      }
    }

    _lastPosition = pos;
  }

  void _onPedometerStep(int steps) {
    _pedometerService.updateSteps(steps);
  }

  void _start() {
    if (_timer != null && _timer!.isActive) return;

    _lastStepCount = _pedometerService.stepsSinceStart;
    _stepHistory.clear();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() {
      _state = RunSessionState(
        plan: _state.plan,
        phase: _state.phase,
        elapsedSeconds: _state.elapsedSeconds,
        currentPaceSecondsPerKm: _state.currentPaceSecondsPerKm,
        distanceKm: _state.distanceKm,
        isRunning: true,
        isLocked: _state.isLocked,
        isAudioCoachOn: _state.isAudioCoachOn,
      );
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _state = RunSessionState(
        plan: _state.plan,
        phase: _state.phase,
        elapsedSeconds: _state.elapsedSeconds,
        currentPaceSecondsPerKm: _state.currentPaceSecondsPerKm,
        distanceKm: _state.distanceKm,
        isRunning: false,
        isLocked: _state.isLocked,
        isAudioCoachOn: _state.isAudioCoachOn,
      );
    });
  }

  void _toggleRunning() {
    if (_state.isRunning) {
      _pause();
    } else {
      _start();
    }
  }

  void _tick() {
    final newElapsed = _state.elapsedSeconds + 1;

    final currentSteps = _pedometerService.stepsSinceStart;
    final stepsThisSecond = (currentSteps - _lastStepCount).clamp(0, 5);
    _stepHistory.add(stepsThisSecond);
    if (_stepHistory.length > 30) {
      _stepHistory.removeAt(0);
    }
    _lastStepCount = currentSteps;

    final gpsTimedOut =
        _lastGpsUpdate == null ||
        DateTime.now().difference(_lastGpsUpdate!) > _gpsTimeout;
    final gpsConnected = _gpsPermissionGranted && _gpsHasFix && !gpsTimedOut;
    final gpsSpeedUsable = gpsConnected && _smoothedSpeed > _minGpsSpeed;

    int? newPace;
    if (gpsSpeedUsable) {
      newPace = _gpsPaceSeconds.clamp(120, 600);
      _paceSource = PaceSource.gps;
    } else {
      final windowSize = _stepHistory.length > _stepWindowSize
          ? _stepWindowSize
          : _stepHistory.length;
      if (windowSize >= 5) {
        final windowSteps = _stepHistory
            .sublist(_stepHistory.length - windowSize)
            .fold(0, (a, b) => a + b);
        if (windowSteps > 3) {
          final distMeters = windowSteps * _pedometerService.strideLength;
          final paceSecPerKm = (windowSize / (distMeters / 1000)).round();
          if (paceSecPerKm >= 120 && paceSecPerKm <= 1800) {
            newPace = paceSecPerKm;
            _paceSource = PaceSource.pedometer;
          } else {
            newPace = null;
            _paceSource = gpsConnected ? PaceSource.gps : PaceSource.none;
          }
        } else {
          newPace = null;
          _paceSource = gpsConnected ? PaceSource.gps : PaceSource.none;
        }
      } else {
        newPace = null;
        _paceSource = gpsConnected ? PaceSource.gps : PaceSource.none;
      }
    }

    var newPhase = _state.phase;
    if (newElapsed >= _state.totalSeconds && _state.totalSeconds > 0) {
      _timer?.cancel();
      newPhase = WorkoutPhase.finished;
    } else if (_state.warmUpSeconds > 0 && newElapsed < _state.warmUpSeconds) {
      newPhase = WorkoutPhase.warmup;
    } else if (_state.warmUpSeconds + _state.workSeconds > 0 &&
        newElapsed < _state.warmUpSeconds + _state.workSeconds) {
      newPhase = WorkoutPhase.work;
    } else if (_state.totalSeconds > 0) {
      newPhase = WorkoutPhase.cooldown;
    }

    setState(() {
      _state = RunSessionState(
        plan: _state.plan,
        phase: newPhase,
        elapsedSeconds: newElapsed,
        currentPaceSecondsPerKm: newPace,
        distanceKm: _state.distanceKm,
        isRunning: newPhase != WorkoutPhase.finished,
        isLocked: _state.isLocked,
        isAudioCoachOn: _state.isAudioCoachOn,
      );
    });
  }

  void _toggleLock() {
    setState(() {
      _state = RunSessionState(
        plan: _state.plan,
        phase: _state.phase,
        elapsedSeconds: _state.elapsedSeconds,
        currentPaceSecondsPerKm: _state.currentPaceSecondsPerKm,
        distanceKm: _state.distanceKm,
        isRunning: _state.isRunning,
        isLocked: !_state.isLocked,
        isAudioCoachOn: _state.isAudioCoachOn,
      );
    });
  }

  void _toggleAudioCoach() {
    setState(() {
      _state = RunSessionState(
        plan: _state.plan,
        phase: _state.phase,
        elapsedSeconds: _state.elapsedSeconds,
        currentPaceSecondsPerKm: _state.currentPaceSecondsPerKm,
        distanceKm: _state.distanceKm,
        isRunning: _state.isRunning,
        isLocked: _state.isLocked,
        isAudioCoachOn: !_state.isAudioCoachOn,
      );
    });
  }

  void _endWorkout() {
    _timer?.cancel();
    setState(() {
      _state = RunSessionState(
        plan: _state.plan,
        phase: WorkoutPhase.finished,
        elapsedSeconds: _state.elapsedSeconds,
        currentPaceSecondsPerKm: _state.currentPaceSecondsPerKm,
        distanceKm: _state.distanceKm,
        isRunning: false,
        isLocked: _state.isLocked,
        isAudioCoachOn: _state.isAudioCoachOn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showExitSheet(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1C1C1E),
        body: SafeArea(
          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: _state.isLocked,
                child: Column(
                  children: [
                    _Header(
                      planName: typeLabel(_state.plan.type),
                      phase: _state.phase,
                      isFinished: _state.phase == WorkoutPhase.finished,
                      onExit: () => _showExitSheet(context),
                    ),
                    Expanded(
                      child: RunTimerDisplay(
                        progress: _state.totalProgress,
                        progressColor: _phaseColor(_state.phase),
                        timeText: _formatTime(_state.elapsedSeconds),
                      ),
                    ),
                    if (_state.phase == WorkoutPhase.finished)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Workout Complete!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _phaseColor(_state.phase),
                          ),
                        ),
                      )
                    else ...[
                      RunPacerDisplay(
                        currentPaceSecondsPerKm: _state.currentPaceSecondsPerKm,
                        fastestTargetSeconds: _state.fastestTarget.inSeconds,
                        slowestTargetSeconds: _state.slowestTarget.inSeconds,
                      ),
                      _PaceSourceIndicator(source: _paceSource),
                      RunSecondaryMetrics(
                        elapsedSeconds: _state.elapsedSeconds,
                        remainingSeconds: _state.remainingSeconds,
                      ),
                    ],
                    RunControls(
                      isRunning: _state.isRunning,
                      isLocked: _state.isLocked,
                      isAudioCoachOn: _state.isAudioCoachOn,
                      isFinished: _state.phase == WorkoutPhase.finished,
                      onToggleRunning: _toggleRunning,
                      onToggleLock: _toggleLock,
                      onToggleAudioCoach: _toggleAudioCoach,
                    ),
                  ],
                ),
              ),
              if (_state.isLocked)
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _toggleLock,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFC4C02),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Tap to Unlock',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF636366),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'End Workout?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF2F2F7),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your progress so far will be saved.',
                style: TextStyle(fontSize: 14, color: Color(0xFFAEAEB2)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF2F2F7),
                        side: const BorderSide(color: Color(0xFF3A3A3C)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Resume'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        _endWorkout();
                        context.pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('End'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _PaceSourceIndicator extends StatelessWidget {
  final PaceSource source;

  const _PaceSourceIndicator({required this.source});

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (source) {
      PaceSource.gps => (Icons.satellite_alt, 'GPS', const Color(0xFF22C55E)),
      PaceSource.pedometer => (
        Icons.directions_walk,
        'Steps',
        const Color(0xFFF59E0B),
      ),
      PaceSource.none => (
        Icons.sensors_off,
        'No Signal',
        const Color(0xFFEF4444),
      ),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String planName;
  final WorkoutPhase phase;
  final bool isFinished;
  final VoidCallback onExit;

  const _Header({
    required this.planName,
    required this.phase,
    required this.isFinished,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF2F2F7),
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, -0.5),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Row(
                    key: ValueKey(phase),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _phaseColor(phase).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _phaseLabel(phase),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _phaseColor(phase),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onExit,
            icon: const Icon(Icons.close, color: Color(0xFFAEAEB2)),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF3A3A3C),
              minimumSize: const Size(44, 44),
            ),
          ),
        ],
      ),
    );
  }

  String _phaseLabel(WorkoutPhase phase) {
    return switch (phase) {
      WorkoutPhase.warmup => 'Warm Up',
      WorkoutPhase.work => 'Run',
      WorkoutPhase.cooldown => 'Cool Down',
      WorkoutPhase.finished => 'Complete',
    };
  }
}

Color _phaseColor(WorkoutPhase phase) {
  return switch (phase) {
    WorkoutPhase.warmup => const Color(0xFF22C55E),
    WorkoutPhase.work => const Color(0xFFFC4C02),
    WorkoutPhase.cooldown => const Color(0xFF3B82F6),
    WorkoutPhase.finished => const Color(0xFF22C55E),
  };
}

String typeLabel(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => 'Easy Run',
    WorkoutType.tempo => 'Tempo Run',
    WorkoutType.intervals => 'Interval Training',
    WorkoutType.longRun => 'Long Run',
    WorkoutType.rest => 'Rest',
    WorkoutType.crossTraining => 'Cross Training',
  };
}
