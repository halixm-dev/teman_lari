import 'package:flutter/material.dart';

class RunSecondaryMetrics extends StatelessWidget {
  final int elapsedSeconds;
  final int remainingSeconds;

  const RunSecondaryMetrics({
    super.key,
    required this.elapsedSeconds,
    required this.remainingSeconds,
  });

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _MetricTile(
              label: 'Elapsed',
              value: _formatTime(elapsedSeconds),
            ),
          ),
          Container(width: 1, height: 32, color: const Color(0xFF38383A)),
          Expanded(
            child: _MetricTile(
              label: 'Remaining',
              value: _formatTime(remainingSeconds),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;

  const _MetricTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF636366),
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFF2F2F7),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
