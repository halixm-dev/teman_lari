import 'package:flutter/material.dart';

import '../../domain/entities/training_plan.dart';
import '../theme/app_colors.dart';

class WorkoutTypeBadge extends StatelessWidget {
  final WorkoutType type;

  const WorkoutTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: workoutTypeColor(type).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        workoutTypeLabel(type),
        style: TextStyle(
          color: workoutTypeColor(type),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Color workoutTypeColor(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => AppColors.success,
    WorkoutType.tempo => AppColors.warning,
    WorkoutType.intervals => AppColors.danger,
    WorkoutType.longRun => AppColors.info,
    WorkoutType.rest => AppColors.gray500,
    WorkoutType.crossTraining => AppColors.pr,
    WorkoutType.walk => AppColors.hike,
  };
}

IconData workoutTypeIcon(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => Icons.directions_run,
    WorkoutType.tempo => Icons.speed,
    WorkoutType.intervals => Icons.timer,
    WorkoutType.longRun => Icons.map,
    WorkoutType.rest => Icons.hotel,
    WorkoutType.crossTraining => Icons.fitness_center,
    WorkoutType.walk => Icons.directions_walk,
  };
}

String workoutTypeLabel(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => 'Easy',
    WorkoutType.tempo => 'Tempo',
    WorkoutType.intervals => 'Intervals',
    WorkoutType.longRun => 'Long Run',
    WorkoutType.rest => 'Rest',
    WorkoutType.crossTraining => 'Cross Train',
    WorkoutType.walk => 'Walk',
  };
}
