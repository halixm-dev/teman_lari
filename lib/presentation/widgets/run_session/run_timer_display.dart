import 'dart:math';

import 'package:flutter/material.dart';

class RunTimerDisplay extends StatelessWidget {
  final double progress;
  final Color progressColor;
  final String timeText;

  const RunTimerDisplay({
    super.key,
    required this.progress,
    required this.progressColor,
    required this.timeText,
  });

  @override
  Widget build(BuildContext context) {
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
                    trackColor: const Color(0xFF3A3A3C),
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
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 72,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF2F2F7),
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
