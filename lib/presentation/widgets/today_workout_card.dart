import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/training_plan.dart';
import '../providers/activities_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class TodayWorkoutCard extends ConsumerWidget {
  const TodayWorkoutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(trainingPlanProvider);

    return planAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (plan) {
        final today = DateTime.now();
        final day = plan.days
            .where(
              (d) =>
                  d.date.year == today.year &&
                  d.date.month == today.month &&
                  d.date.day == today.day,
            )
            .firstOrNull;

        if (day == null) return const SizedBox.shrink();

        final isRest = day.type == WorkoutType.rest;

        return Card(
          child: Semantics(
            button: !isRest,
            label: isRest
                ? 'Rest day. No workout today.'
                : 'Start today\'s workout: ${_typeLabel(day.type)}',
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              onTap: isRest
                  ? null
                  : () => context.push('/run-session', extra: day),
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _typeIcon(day.type),
                          color: _typeColor(day.type),
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.space2),
                        Text(
                          "Today's Workout",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.space3),
                    Row(
                      children: [
                        _WorkoutTypeBadge(type: day.type),
                        if (!isRest && day.targetMinutes != null) ...[
                          const SizedBox(width: AppSpacing.space2),
                          Text(
                            '${day.targetMinutes} min',
                            style: AppTypography.statValue.copyWith(
                              fontSize: 18,
                              color: _typeColor(day.type),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (day.description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        day.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (!isRest) ...[
                      const SizedBox(height: AppSpacing.space3),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.push('/run-session', extra: day),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Start Workout'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.brandOrange,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Color _typeColor(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => Colors.green,
    WorkoutType.tempo => Colors.orange,
    WorkoutType.intervals => Colors.red,
    WorkoutType.longRun => Colors.blue,
    WorkoutType.rest => AppColors.gray500,
    WorkoutType.crossTraining => Colors.purple,
  };
}

IconData _typeIcon(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => Icons.directions_walk,
    WorkoutType.tempo => Icons.speed,
    WorkoutType.intervals => Icons.timer,
    WorkoutType.longRun => Icons.map,
    WorkoutType.rest => Icons.hotel,
    WorkoutType.crossTraining => Icons.fitness_center,
  };
}

String _typeLabel(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => 'Easy',
    WorkoutType.tempo => 'Tempo',
    WorkoutType.intervals => 'Intervals',
    WorkoutType.longRun => 'Long Run',
    WorkoutType.rest => 'Rest',
    WorkoutType.crossTraining => 'Cross Train',
  };
}

class _WorkoutTypeBadge extends StatelessWidget {
  final WorkoutType type;

  const _WorkoutTypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _typeColor(type).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _typeLabel(type),
        style: TextStyle(
          color: _typeColor(type),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
