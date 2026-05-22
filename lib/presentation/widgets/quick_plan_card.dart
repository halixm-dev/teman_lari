import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/training_plan.dart';
import '../providers/training_plan_provider.dart';

class QuickPlanCard extends ConsumerWidget {
  const QuickPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(trainingPlanProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Training Plan',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => context.go('/plan'),
                  child: const Text('View Full'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            planAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Text('Error generating plan'),
              data: (plan) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.goal,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${plan.days.where((d) => d.type != WorkoutType.rest).length} workouts this week',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
