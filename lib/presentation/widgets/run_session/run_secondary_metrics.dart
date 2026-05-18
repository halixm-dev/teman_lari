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
    final theme = Theme.of(context);
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
          Container(
            width: 1,
            height: 32,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
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
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 0.05,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontFamily: 'JetBrains Mono',
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
