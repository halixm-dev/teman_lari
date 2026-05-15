import 'package:flutter/material.dart';

class RunPacerDisplay extends StatelessWidget {
  final int? currentPaceSecondsPerKm;
  final int fastestTargetSeconds;
  final int slowestTargetSeconds;

  const RunPacerDisplay({
    super.key,
    required this.currentPaceSecondsPerKm,
    required this.fastestTargetSeconds,
    required this.slowestTargetSeconds,
  });

  String _formatPace(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "$m'${s.toString().padLeft(2, '0')}";
  }

  double _pacePosition() {
    final mid = (fastestTargetSeconds + slowestTargetSeconds) / 2;
    final halfRange = (slowestTargetSeconds - fastestTargetSeconds).toDouble();
    final buffer = halfRange * 2;
    if (buffer <= 0) return 0.5;
    return ((currentPaceSecondsPerKm! - mid) / buffer + 0.5).clamp(0.0, 1.0);
  }

  Color _paceStatusColor() {
    final pos = _pacePosition();
    if (pos < 0.2 || pos > 0.8) return const Color(0xFFEF4444);
    if (pos < 0.4 || pos > 0.6) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }

  String _paceStatusLabel() {
    final pos = _pacePosition();
    if (pos < 0.2) return 'Too Fast';
    if (pos < 0.4) return 'Slightly Fast';
    if (pos <= 0.6) return 'On Track';
    if (pos <= 0.8) return 'Slightly Slow';
    return 'Too Slow';
  }

  @override
  Widget build(BuildContext context) {
    final hasPace = currentPaceSecondsPerKm != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                hasPace ? _formatPace(currentPaceSecondsPerKm!) : "--'--",
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF2F2F7),
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '/km',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF636366),
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Target: ${_formatPace(fastestTargetSeconds)} - ${_formatPace(slowestTargetSeconds)} /km',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFFAEAEB2),
            ),
          ),
          if (hasPace) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 6,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final pos = _pacePosition();
                        final dotLeft = (pos * (constraints.maxWidth - 14))
                            .clamp(0.0, constraints.maxWidth - 14);

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              children: [
                                _segment(const Color(0xFFEF4444)),
                                _segment(const Color(0xFFF59E0B)),
                                _segment(const Color(0xFF22C55E)),
                                _segment(const Color(0xFFF59E0B)),
                                _segment(const Color(0xFFEF4444)),
                              ],
                            ),
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              left: dotLeft,
                              top: -4,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: _paceStatusColor(),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF1C1C1E),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _paceStatusLabel(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _paceStatusColor(),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _segment(Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
