enum TrainingLoad { easy, moderate, hard, veryHard }

class RunActivity {
  final int id;
  final String name;
  final DateTime date;
  final double distanceKm;
  final Duration movingTime;
  final Duration pace;
  final double? avgHeartRate;
  final double? maxHeartRate;
  final double elevationGainM;
  final double? avgCadence;
  final int? sufferScore;
  final TrainingLoad trainingLoad;
  final List<double>? heartRateData;

  const RunActivity({
    required this.id,
    required this.name,
    required this.date,
    required this.distanceKm,
    required this.movingTime,
    required this.pace,
    required this.elevationGainM,
    required this.trainingLoad,
    this.avgHeartRate,
    this.maxHeartRate,
    this.avgCadence,
    this.sufferScore,
    this.heartRateData,
  });

  String get paceString {
    final totalSeconds = pace.inSeconds;
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')} /km';
  }
}
