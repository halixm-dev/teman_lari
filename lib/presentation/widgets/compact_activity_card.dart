import 'package:flutter/material.dart';
import 'package:teman_lari/domain/entities/run_activity.dart';
import 'package:teman_lari/presentation/theme/app_theme_extensions.dart';
import 'package:teman_lari/core/utils/date_utils.dart';

class CompactActivityCard extends StatelessWidget {
  final RunActivity run;

  const CompactActivityCard({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final typoExt = Theme.of(context).extension<AppTypographyExtension>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            run.name,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            AppDateUtils.formatDate(run.date),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StatColumn(
                  label: 'DISTANCE',
                  value: '${run.distanceKm.toStringAsFixed(2)} km',
                  typoExt: typoExt,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'PACE',
                  value: run.paceString,
                  typoExt: typoExt,
                ),
              ),
              Expanded(
                child: _StatColumn(
                  label: 'TIME',
                  value: _formatDuration(run.movingTime),
                  typoExt: typoExt,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final AppTypographyExtension? typoExt;

  const _StatColumn({
    required this.label,
    required this.value,
    this.typoExt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: typoExt?.statLabel ??
              Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 0.05),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: typoExt?.statValue ??
              Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
