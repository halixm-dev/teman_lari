import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/entities/run_activity.dart';
import '../providers/activities_provider.dart';

class RecentRunsList extends ConsumerWidget {
  const RecentRunsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activitiesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Runs', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            activities.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Text('Error loading runs'),
              data: (runs) {
                final recent = runs.where((a) => a.distanceKm > 0).toList()
                  ..sort((a, b) => b.date.compareTo(a.date));
                final displayed = recent.take(5).toList();

                if (displayed.isEmpty) {
                  return const Text('No runs found');
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayed.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, i) {
                    final run = displayed[i];
                    return _RunTile(run: run);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RunTile extends StatelessWidget {
  final RunActivity run;

  const _RunTile({required this.run});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  run.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  AppDateUtils.formatDate(run.date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${run.distanceKm.toStringAsFixed(2)} km'),
              Text(
                run.paceString,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
