import 'package:flutter/material.dart';

import '../../domain/entities/running_stats.dart';

class FitnessFormCard extends StatelessWidget {
  final RunningStats stats;

  const FitnessFormCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final formColor = stats.formScore > 5
        ? Colors.green
        : stats.formScore < -5
            ? Colors.red
            : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Training Status',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricChip(
                    label: 'Fitness',
                    value: stats.fitnessScore.toStringAsFixed(0),
                    color: Colors.blue),
                _MetricChip(
                    label: 'Fatigue',
                    value: stats.fatigueSCore.toStringAsFixed(0),
                    color: Colors.red),
                _MetricChip(
                    label: 'Form',
                    value: stats.formScore.toStringAsFixed(0),
                    color: formColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
