import 'dart:math';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'run_session_state.dart';

class PhaseArc {
  final double sweepFraction;
  final double fillFraction;
  final Color color;

  const PhaseArc({
    required this.sweepFraction,
    required this.fillFraction,
    required this.color,
  });
}

class RunTimerDisplay extends StatelessWidget {
  final String timeText;
  final List<PhaseArc> phaseArcs;
  final String? phaseLabel;

  const RunTimerDisplay({
    super.key,
    required this.timeText,
    required this.phaseArcs,
    this.phaseLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _MultiPhaseProgressPainter(
                phaseArcs: phaseArcs,
                trackColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeText,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
                if (phaseLabel != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    phaseLabel!,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color phaseColor(PhaseSegmentType type) {
  return switch (type) {
    PhaseSegmentType.warmup => AppColors.success,
    PhaseSegmentType.work => AppColors.brandOrange,
    PhaseSegmentType.recovery => const Color(0xFFF59E0B),
    PhaseSegmentType.cooldown => AppColors.info,
  };
}

String phaseLabelFromType(PhaseSegmentType type) {
  return switch (type) {
    PhaseSegmentType.warmup => 'Warm Up',
    PhaseSegmentType.work => 'Run',
    PhaseSegmentType.recovery => 'Recovery Jog',
    PhaseSegmentType.cooldown => 'Cool Down',
  };
}

class _MultiPhaseProgressPainter extends CustomPainter {
  final List<PhaseArc> phaseArcs;
  final Color trackColor;

  _MultiPhaseProgressPainter({
    required this.phaseArcs,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final totalSweep =
        phaseArcs.fold(0.0, (sum, arc) => sum + arc.sweepFraction);
    if (phaseArcs.isEmpty || totalSweep <= 0) {
      canvas.drawArc(rect, -pi / 2, 2 * pi, false, trackPaint);
      return;
    }

    final gapAngle = phaseArcs.length > 1 ? 0.02 : 0.0;
    final availableSweep = 2 * pi - gapAngle * phaseArcs.length;
    double currentAngle = -pi / 2;

    for (final arc in phaseArcs) {
      if (arc.sweepFraction <= 0) continue;

      final sweepAngle = (arc.sweepFraction / totalSweep) * availableSweep;

      canvas.drawArc(rect, currentAngle, sweepAngle, false, trackPaint);

      final fillAngle = sweepAngle * arc.fillFraction.clamp(0.0, 1.0);
      if (fillAngle > 0) {
        final progressPaint = Paint()
          ..color = arc.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawArc(rect, currentAngle, fillAngle, false, progressPaint);
      }

      currentAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(_MultiPhaseProgressPainter oldDelegate) =>
      oldDelegate.phaseArcs != phaseArcs || oldDelegate.trackColor != trackColor;
}

// Keep backward-compatible single-color version
class RunTimerDisplayLegacy extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final String timeText;

  const RunTimerDisplayLegacy({
    super.key,
    required this.progress,
    required this.progressColor,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(begin: progressColor, end: progressColor),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              builder: (context, color, _) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _CircularProgressPainter(
                    progress: progress,
                    trackColor:
                        theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    progressColor: color ?? progressColor,
                  ),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeText,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  _CircularProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, 2 * pi, false, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress.clamp(0.0, 1.0),
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor;
}
