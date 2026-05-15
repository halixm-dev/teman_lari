import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/activities_provider.dart';
import '../widgets/fitness_form_card.dart';
import '../widgets/stats_grid.dart';
import '../widgets/recent_runs_list.dart';
import '../widgets/quick_plan_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(runningStatsProvider);
    final activities = ref.watch(activitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Running'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(activitiesProvider.notifier).refresh(),
          ),
        ],
      ),
      body: activities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $e'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    ref.read(activitiesProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (_) => statsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (stats) => stats == null
              ? const Center(child: Text('No running activities found'))
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(activitiesProvider.notifier).refresh(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FitnessFormCard(stats: stats),
                        const SizedBox(height: 16),
                        StatsGrid(stats: stats),
                        const SizedBox(height: 16),
                        const RecentRunsList(),
                        const SizedBox(height: 16),
                        const QuickPlanCard(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
