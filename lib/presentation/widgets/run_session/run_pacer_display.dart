import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class RunPacerDisplay extends StatelessWidget {
  final int? currentPaceSecondsPerKm;
  final int fastestTargetSeconds;
  final int slowestTargetSeconds;
  final bool isWorkPhase;

  const RunPacerDisplay({
    super.key,
    required this.currentPaceSecondsPerKm,
    required this.fastestTargetSeconds,
    required this.slowestTargetSeconds,
    this.isWorkPhase = true,
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
    final pace = currentPaceSecondsPerKm;
    if (pace == null) return 0.5;
    return ((pace - mid) / buffer + 0.5).clamp(0.0, 1.0);
  }

  Color _paceStatusColor() {
    final pos = _pacePosition();
    if (pos < 0.2 || pos > 0.8) return AppColors.danger;
    if (pos < 0.4 || pos > 0.6) return AppColors.warning;
    return AppColors.success;
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
    final pace = currentPaceSecondsPerKm;
    final hasPace = pace != null;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
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
                hasPace ? _formatPace(pace) : "--'--",
                style: theme.textTheme.displayMedium?.copyWith(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '/km',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ],
          ),
          if (isWorkPhase) ...[
            const SizedBox(height: 4),
            Text(
              'Target: ${_formatPace(fastestTargetSeconds)} - ${_formatPace(slowestTargetSeconds)} /km',
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (hasPace && isWorkPhase) ...[
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
                                _segment(AppColors.danger),
                                _segment(AppColors.warning),
                                _segment(AppColors.success),
                                _segment(AppColors.warning),
                                _segment(AppColors.danger),
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
                                    color: theme.scaffoldBackgroundColor,
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
          color: color.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
