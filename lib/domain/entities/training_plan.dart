enum WorkoutType { easy, tempo, intervals, longRun, rest, crossTraining }

class PaceZone {
  final Duration slowestPace;
  final Duration fastestPace;
  final String label;

  const PaceZone({
    required this.slowestPace,
    required this.fastestPace,
    required this.label,
  });
}

class HrZone {
  final int minBpm;
  final int maxBpm;
  final int zoneNumber;
  final String label;

  const HrZone({
    required this.minBpm,
    required this.maxBpm,
    required this.zoneNumber,
    required this.label,
  });
}

class TrainingDay {
  final DateTime date;
  final WorkoutType type;
  final double? targetDistanceKm;
  final double? warmUpCoolDownKm;
  final PaceZone? paceTarget;
  final HrZone? heartRateTarget;
  final String description;
  final Duration? estimatedDuration;

  const TrainingDay({
    required this.date,
    required this.type,
    required this.description,
    this.targetDistanceKm,
    this.warmUpCoolDownKm,
    this.paceTarget,
    this.heartRateTarget,
    this.estimatedDuration,
  });

  double? get workDistanceKm {
    if (targetDistanceKm == null || warmUpCoolDownKm == null) return null;
    return targetDistanceKm! - warmUpCoolDownKm!;
  }
}

class TrainingPlan {
  final DateTime startDate;
  final List<TrainingDay> days;
  final String goal;
  final String description;

  const TrainingPlan({
    required this.startDate,
    required this.days,
    required this.goal,
    required this.description,
  });

  factory TrainingPlan.empty() {
    return TrainingPlan(
      startDate: DateTime.now(),
      days: [],
      goal: 'No data available',
      description: 'Connect Strava and complete some runs to generate a plan.',
    );
  }
}
