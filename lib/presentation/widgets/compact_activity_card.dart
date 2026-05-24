import 'package:flutter/material.dart';
import 'package:teman_lari/domain/entities/analyzed_activity.dart';
import 'package:teman_lari/presentation/theme/app_theme_extensions.dart';
import 'package:teman_lari/core/utils/date_utils.dart';
import 'package:teman_lari/domain/entities/activity.dart';
import 'package:teman_lari/presentation/widgets/workout_type_badge.dart';
import 'scale_on_press.dart';

class CompactActivityCard extends StatelessWidget {
  final AnalyzedActivity analyzedRun;

  const CompactActivityCard({super.key, required this.analyzedRun});

  @override
  Widget build(BuildContext context) {
    final typoExt = Theme.of(context).extension<AppTypographyExtension>();
    final run = analyzedRun.activity;

    return ScaleOnPress(
      onTap: () {}, // Empty tap for scale feedback
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    run.name,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                WorkoutTypeBadge(type: analyzedRun.type),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              AppDateUtils.formatDate(run.date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final statsWidgets = [
                  _CompactStat(
                    icon: Icons.route_outlined,
                    value: '${run.distanceKm.toStringAsFixed(2)} km',
                    typoExt: typoExt,
                  ),
                  _CompactStat(
                    icon: Icons.timer_outlined,
                    value: _formatDuration(run.movingTime),
                    typoExt: typoExt,
                  ),
                  if (run.type == ActivityType.run ||
                      run.type == ActivityType.walk)
                    _CompactStat(
                      icon: Icons.speed_outlined,
                      value: run.paceString,
                      typoExt: typoExt,
                    ),
                  if (run.avgHeartRate != null)
                    _CompactStat(
                      icon: Icons.favorite_border_outlined,
                      value: '${run.avgHeartRate!.round()} bpm',
                      typoExt: typoExt,
                    ),
                ];

                if (constraints.maxWidth < 280) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: statsWidgets
                        .map(
                          (w) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: w,
                          ),
                        )
                        .toList(),
                  );
                }

                return Wrap(spacing: 16, runSpacing: 8, children: statsWidgets);
              },
            ),
          ],
        ),
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

class _CompactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final AppTypographyExtension? typoExt;

  const _CompactStat({required this.icon, required this.value, this.typoExt});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style:
              typoExt?.statValue ??
              Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
