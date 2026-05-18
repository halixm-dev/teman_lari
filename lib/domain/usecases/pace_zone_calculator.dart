import '../entities/run_activity.dart';
import '../entities/training_plan.dart';

class PaceZoneCalculator {
  static List<PaceZone> fromThresholdPace(int thresholdSecondsPerKm) {
    return [
      PaceZone(
        label: 'Zone 1 – Recovery',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.40).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 1.30).round()),
      ),
      PaceZone(
        label: 'Zone 2 – Easy Aerobic',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.30).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 1.15).round()),
      ),
      PaceZone(
        label: 'Zone 3 – Moderate',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.15).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 1.05).round()),
      ),
      PaceZone(
        label: 'Zone 4 – Threshold',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.05).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 0.98).round()),
      ),
      PaceZone(
        label: 'Zone 5 – VO2max',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 0.98).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 0.88).round()),
      ),
    ];
  }

  static int estimateThresholdPace(List<RunActivity> activities) {
    final candidates =
        activities
            .where(
              (a) =>
                  a.movingTime.inMinutes >= 20 && a.movingTime.inMinutes <= 35,
            )
            .toList()
          ..sort((a, b) => a.pace.inSeconds.compareTo(b.pace.inSeconds));

    if (candidates.isNotEmpty) {
      return (candidates.first.pace.inSeconds * 1.05).round();
    }

    final avgPaceSecondsPerKm =
        activities.fold<int>(0, (sum, a) => sum + a.movingTime.inSeconds) ~/
        activities.fold<double>(0, (sum, a) => sum + a.distanceKm).round();
    return (avgPace * 0.90).round();
  }
}
