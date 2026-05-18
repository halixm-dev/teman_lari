import 'package:flutter/material.dart';

import '../../domain/entities/running_stats.dart';

class StatsGrid extends StatelessWidget {
  final RunningStats stats;
  final bool showVo2Max;

  const StatsGrid({super.key, required this.stats, this.showVo2Max = false});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          icon: Icons.run_circle,
          label: 'Total Runs',
          value: '${stats.totalRuns}',
          color: Colors.blue,
        ),
        _StatCard(
          icon: Icons.straighten,
          label: 'Total Distance',
          value: '${stats.totalDistanceKm.toStringAsFixed(1)} km',
          color: Colors.green,
        ),
        _StatCard(
          icon: Icons.speed,
          label: 'Avg Pace',
          value:
              '${stats.averagePace.inMinutes}:${(stats.averagePace.inSeconds % 60).toString().padLeft(2, '0')}',
          color: Colors.orange,
        ),
        if (showVo2Max)
          _StatCard(
            icon: Icons.favorite,
            label: 'VO2 Max',
            value: stats.vo2MaxEstimate?.toStringAsFixed(1) ?? 'N/A',
            color: Colors.purple,
          )
        else
          _StatCard(
            icon: Icons.show_chart,
            label: 'Weekly Avg',
            value: '${stats.recentWeeklyAvgKm.toStringAsFixed(1)} km',
            color: Colors.purple,
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
