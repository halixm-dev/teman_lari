import '../entities/return_context.dart';
import '../entities/activity.dart';
import 'training_plan_config.dart';

class ReturnContextDetector {
  static const int _extendedGapDays = 30;

  ReturnContext detect(List<Activity> activities, TrainingPlanConfig config) {
    if (activities.isEmpty) return ReturnContext.empty();

    final sortedDesc = [...activities]
      ..sort((a, b) => b.date.compareTo(a.date));

    final now = DateTime.now();
    final daysSinceLastRun = now.difference(sortedDesc.first.date).inDays;

    if (daysSinceLastRun < config.shortGapDays) {
      return ReturnContext.empty();
    }

    int? gapSplitIndex;
    for (int i = 1; i < sortedDesc.length; i++) {
      final gap = sortedDesc[i - 1].date.difference(sortedDesc[i].date).inDays;
      if (gap >= config.shortGapDays) {
        gapSplitIndex = i;
        break;
      }
    }

    final preGapActivities = gapSplitIndex != null
        ? sortedDesc.sublist(gapSplitIndex)
        : sortedDesc;

    final bool isStale;
    final double preGapAvgKm;
    final double preGapAvgMin;

    if (preGapActivities.isNotEmpty) {
      final newestPreGap = preGapActivities.first.date;
      isStale = now.difference(newestPreGap).inDays >= config.staleActivityDays;

      if (isStale) {
        preGapAvgKm = 0;
        preGapAvgMin = 0;
      } else {
        preGapAvgKm = _recentWeeklyAvg(preGapActivities, byDistance: true);
        preGapAvgMin = _recentWeeklyAvg(preGapActivities, byDistance: false);
      }
    } else {
      isStale = true;
      preGapAvgKm = 0;
      preGapAvgMin = 0;
    }

    return ReturnContext(
      gapDays: daysSinceLastRun,
      category: _categorizeGap(daysSinceLastRun, config, isStale),
      preGapAvgKm: preGapAvgKm,
      preGapAvgMin: preGapAvgMin,
      lastActivityDate: sortedDesc.first.date,
      isStale: isStale,
    );
  }

  GapCategory _categorizeGap(
    int gapDays,
    TrainingPlanConfig config,
    bool preGapStale,
  ) {
    if (preGapStale) return GapCategory.extended;
    if (gapDays >= _extendedGapDays) return GapCategory.extended;
    if (gapDays >= config.injuryGapDays) return GapCategory.injury;
    if (gapDays >= config.longGapDays) return GapCategory.long;
    if (gapDays >= config.shortGapDays) return GapCategory.short;
    return GapCategory.none;
  }

  double _recentWeeklyAvg(
    List<Activity> activities, {
    required bool byDistance,
  }) {
    if (activities.isEmpty) return 0;
    final weekly = <String, double>{};
    for (final activity in activities) {
      final weekKey = _weekCommencingKey(activity.date);
      weekly[weekKey] =
          (weekly[weekKey] ?? 0) +
          (byDistance
              ? activity.distanceKm
              : activity.movingTime.inMinutes.toDouble());
    }
    final values = weekly.values.toList();
    final recentCount = values.length > 4 ? 4 : values.length;
    final recent = values.sublist(values.length - recentCount);

    if (values.length < 2) {
      return recent.isNotEmpty ? recent.reduce((a, b) => a + b) / recent.length : 0;
    }

    final priorCount = values.length > 12 ? 12 : values.length;
    final prior = values.sublist(values.length - priorCount);
    final sortedPrior = List<double>.from(prior)..sort();
    final median = sortedPrior[sortedPrior.length ~/ 2];

    final validRecent = recent.where((v) => v >= median * 0.5 && v <= median * 1.5).toList();
    if (validRecent.isEmpty) {
      final sortedRecent = List<double>.from(recent)..sort();
      return sortedRecent[sortedRecent.length ~/ 2];
    }
    validRecent.sort();
    return validRecent[validRecent.length ~/ 2];
  }

  String _weekCommencingKey(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }
}
