import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/responsive.dart';
import '../../domain/entities/running_stats.dart';
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
      appBar: AppBar(
        title: const Text('Analysis'),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () => _showDataPeriodInfo(context)),
        ],
      ),
      body: ConstrainedContent(
        child: statsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (stats) => stats == null ? const Center(child: Text('No data')) : _AnalysisData(stats: stats),
        ),
      ),
    );
  }
}

class _AnalysisData extends StatelessWidget {
  final RunningStats stats;
  const _AnalysisData({required this.stats});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          StatsGrid(stats: stats, showVo2Max: true),
          const SizedBox(height: 16),
          _PaceCard(stats: stats),
          const SizedBox(height: 16),
          _HrZoneCard(stats: stats),
        ],
      ),
    );
  }
}

class _PaceCard extends StatelessWidget {
  final RunningStats stats;
  const _PaceCard({required this.stats});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pace Progression', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            PaceProgressionChart(dataPoints: stats.paceProgression),
          ],
        ),
      ),
    );
  }
}

class _HrZoneCard extends StatelessWidget {
  final RunningStats stats;
  const _HrZoneCard({required this.stats});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Heart Rate Zones', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            HrZoneDistributionChart(zoneDistribution: stats.heartRateZones),
          ],
        ),
      ),
    );
  }
}

void _showDataPeriodInfo(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Data Period'),
      content: const Text(
        'Analysis based on 1 year of Strava data',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
