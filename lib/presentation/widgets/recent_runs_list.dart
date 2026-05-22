import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/activities_provider.dart';
import 'compact_activity_card.dart';

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
                  separatorBuilder: (_, _) => const Divider(height: 16),
                  itemBuilder: (context, i) {
                    final run = displayed[i];
                    return CompactActivityCard(run: run);
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
