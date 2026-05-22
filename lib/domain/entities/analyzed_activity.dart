import 'package:equatable/equatable.dart';

import 'activity.dart';
import 'workout_type.dart';

class AnalyzedActivity extends Equatable {
  final Activity activity;
  final WorkoutType type;

  const AnalyzedActivity({required this.activity, required this.type});

  @override
  List<Object?> get props => [activity, type];
}
