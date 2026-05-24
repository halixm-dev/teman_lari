import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/utils/responsive.dart';
import '../theme/app_colors.dart';
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
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Data period information',
            onPressed: () => _showDataPeriodInfo(context),
          ),
        ],
      ),
      body: ConstrainedContent(
        child: RefreshIndicator(
          onRefresh: () => ref.read(activitiesProvider.notifier).refresh(),
          child: statsAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ).animate().fade().scale(),
            error: (err, _) => Center(
              child: Text('Error: $err'),
            ).animate().fade().slideY(begin: 0.1),
            data: (stats) => stats == null
                ? const Center(child: Text('No data')).animate().fade()
                : _AnalysisData(stats: stats),
          ),
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
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            [
                  const SizedBox(height: 16),
                  StatsGrid(stats: stats, showVo2Max: true),
                  const SizedBox(height: 16),
                  _PaceCard(stats: stats),
                  const SizedBox(height: 16),
                  _HrZoneCard(stats: stats),
                ]
                .animate(interval: 100.ms)
                .fade(duration: 400.ms)
                .slideY(begin: 0.05, curve: Curves.easeOutQuad),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pace Progression',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Heart Rate Zones',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            HrZoneDistributionChart(zoneDistribution: stats.heartRateZones),
          ],
        ),
      ),
    );
  }
}

void _showDataPeriodInfo(BuildContext context) {
  HapticFeedback.lightImpact();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      return SafeArea(
        child: Padding(
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
                    color: isDark
                        ? AppColors.surfaceTertiaryDark
                        : AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.brandOrange.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.brandOrange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Data Period',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Your performance metrics, target training paces, and heart rate zones are calibrated using the past 365 days of your Strava running history.',
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                'This provides a robust profile of your current aerobic capacity, ensuring your training plan recommendations are perfectly tailored to your current fitness level.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.gray700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ).animate().fade(duration: 250.ms).slideY(begin: 0.08, curve: Curves.easeOutCubic),
        ),
      );
    },
  );
}
