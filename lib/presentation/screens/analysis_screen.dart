import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/responsive.dart';
import '../providers/activities_provider.dart';
import '../widgets/pace_chart.dart';
import '../widgets/hr_zone_chart.dart';
import '../widgets/stats_grid.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(runningStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis')),
      body: ConstrainedContent(
        child: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (stats) {
          if (stats == null) {
            return const Center(child: Text('No data available'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DataPeriodBanner(),
                const SizedBox(height: 16),
                StatsGrid(stats: stats, showVo2Max: true),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pace Progression',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        PaceProgressionChart(dataPoints: stats.paceProgression),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Heart Rate Zones',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        HrZoneDistributionChart(
                          zoneDistribution: stats.heartRateZones,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}

class _DataPeriodBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.blueGrey.shade800 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 14,
            color: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
          ),
          const SizedBox(width: 8),
          Text(
            'Analysis based on 1 year of Strava data',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.blue.shade200 : Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
