import 'package:flutter/material.dart';

import '../../domain/entities/running_stats.dart';

class StatsGrid extends StatelessWidget {
  final RunningStats stats;
  final bool showVo2Max;

  const StatsGrid({super.key, required this.stats, this.showVo2Max = false});

  void _showVo2MaxInfo(BuildContext context) {
    final vo2max = stats.vo2MaxEstimate;
    final vo2maxText = vo2max?.toStringAsFixed(1) ?? 'N/A';
    final category = vo2max == null
        ? 'Unknown'
        : vo2max >= 56
        ? 'Excellent'
        : vo2max >= 51
        ? 'Good'
        : vo2max >= 45
        ? 'Fair'
        : 'Needs Improvement';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('VO2 Max', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Your estimated VO2 Max: $vo2maxText ($category)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              'VO₂ Max is the maximum amount of oxygen your body can utilize '
              'during intense exercise. It is a key indicator of aerobic fitness.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Estimation method: Based on your best pace from runs lasting '
              '12 minutes or more, using the formula by Jack Daniels.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Reference ranges (men):',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              '• Excellent: ≥56 mL/kg/min',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '• Good: 51–55 mL/kg/min',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '• Fair: 45–50 mL/kg/min',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Note: Ranges vary by age, gender, '
              'and training history.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

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
            onTap: () => _showVo2MaxInfo(context),
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
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Semantics(
        button: onTap != null,
        label: '$label: $value',
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
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
        ),
      ),
    );
  }
}
