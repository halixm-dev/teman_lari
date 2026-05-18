import 'package:flutter/material.dart';

import '../../domain/entities/running_stats.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class WeeklyVolumeChart extends StatelessWidget {
  final RunningStats stats;

  const WeeklyVolumeChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.weeklyVolume.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final recent = entries.length > 8
        ? entries.sublist(entries.length - 8)
        : entries;

    if (recent.isEmpty) return const SizedBox.shrink();

    final maxVol = recent.map((e) => e.value).reduce(
      (a, b) => a > b ? a : b,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.gray500;

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Volume',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.space4),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: recent.map((e) {
                  final ratio = maxVol > 0 ? e.value / maxVol : 0.0;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            e.value.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 9,
                              color: labelColor,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            height: (ratio * 56).clamp(4, 56),
                            decoration: BoxDecoration(
                              color: AppColors.brandOrange.withValues(
                                alpha: 0.3 + (ratio * 0.7),
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _shortLabel(e.key),
                            style: TextStyle(
                              fontSize: 8,
                              color: labelColor,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortLabel(String isoWeek) {
    final parts = isoWeek.split('-');
    if (parts.length < 2) return '';
    final weekNum = parts.last;
    return 'W$weekNum';
  }
}
