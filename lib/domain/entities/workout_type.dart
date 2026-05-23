enum WorkoutType { easy, tempo, intervals, longRun, rest, crossTraining, walk }

enum IntervalPhaseType { work, recovery }

class IntervalPhase {
  final IntervalPhaseType type;
  final Duration duration;

  const IntervalPhase({required this.type, required this.duration});
}

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
