import '../entities/run_activity.dart';
import '../entities/training_plan.dart';

class HrZoneCalculator {
  static const _defaultMaxHr = 190;
  static const _defaultRestingHr = 60;
  static const _minHr = 100;
  static const _maxHrCap = 230;
  static const _minRestingHr = 35;

  static const _zoneBoundaries = [0.60, 0.70, 0.80, 0.90];
  static const _zoneLabels = [
    'Zone 1 - Recovery',
    'Zone 2 - Aerobic Base',
    'Zone 3 - Tempo',
    'Zone 4 - Threshold',
    'Zone 5 - VO2max',
  ];

  static List<HrZone> fromActivities(
    List<RunActivity> activities, {
    int? restingHr,
    int? maxHr,
  }) {
    final observedMax = maxHr ?? _observedMaxHr(activities);
    final actualMax = observedMax.clamp(_minHr, _maxHrCap);
    final actualResting = (restingHr ?? _defaultRestingHr).clamp(
      _minRestingHr,
      actualMax - 20,
    );
    final hrr = actualMax - actualResting;

    return List.generate(5, (i) {
      final minBpm = i == 0
          ? actualResting
          : (actualResting + hrr * _zoneBoundaries[i - 1]).round();
      final maxBpm = i == 4
          ? actualMax
          : (actualResting + hrr * _zoneBoundaries[i]).round();
      return HrZone(
        zoneNumber: i + 1,
        label: _zoneLabels[i],
        minBpm: minBpm,
        maxBpm: maxBpm,
      );
    });
  }

  static int _observedMaxHr(List<RunActivity> activities) {
    return activities
            .map((a) => a.maxHeartRate)
            .whereType<double>()
            .fold<double?>(
              null,
              (max, hr) => max == null ? hr : (hr > max ? hr : max),
            )
            ?.round() ??
        _defaultMaxHr;
  }
}
