import '../entities/run_walk_phase.dart';
import '../entities/running_stats.dart';

class WorkoutDescriptions {
  const WorkoutDescriptions();

  String easy() =>
      'Easy recovery run. Conversational pace throughout. '
      'Focus on form, not speed.';

  String intervals(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      return '10 min warm-up @ Zone 2, then 4x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      return '10 min warm-up @ Zone 2, then 8x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
    }
    return '10 min warm-up @ Zone 2, then 6x90s @ Zone 5 with 90s recovery jogs, 10 min cool-down.';
  }

  String intervalsCycle(RunningStats stats, int weekInCycle) {
    if (weekInCycle >= 3) {
      return 'No intervals — deload week. Easy running only.';
    }
    switch (weekInCycle) {
      case 0:
        return '10 min warm-up, then 5x1km @ Threshold pace with 2 min jog recovery, 10 min cool-down.';
      case 1:
        return '10 min warm-up, then 8x600m @ VO2max pace with 90s jog recovery, 10 min cool-down.';
      case 2:
        return '10 min warm-up, then 12x400m @ VO2max pace with 90s jog recovery, 10 min cool-down.';
      default:
        return intervals(stats);
    }
  }

  String tempo(int tempoWorkMin) =>
      '10 min warm-up, $tempoWorkMin min @ '
      'threshold pace (Zone 4), 10 min cool-down. '
      'Comfortably hard - you can speak in short sentences.';

  String longRun() =>
      'Long easy run - the most important run of the week. '
      'Stay strictly in Zone 2. Walk breaks are fine. '
      'Hydrate every 20-30 min.';

  String rest() => 'Rest day. Let your body recover.';

  String crossTraining() => 'Cross-training day.';

  String beginnerRunWalk(RunWalkPhase phase) =>
      '${phase.label}. Repeat for ${phase.totalDurationMinutes} min. '
      'Focus on form, keep it easy.';

  String returningRamp(int rampWeek) =>
      'Week $rampWeek of your return ramp. '
      'Rebuilding base — keep it easy, listen to your body.';

  String deload() =>
      'Deload week — reduced volume and easy pace only. '
      'Let your body absorb the training.';

  String goal(RunningStats stats) {
    if (stats.totalRuns < 10) {
      return 'Build a consistent running base';
    }
    if (stats.fitnessScore < 30) return 'Develop aerobic fitness';
    if (stats.formScore < -10) return 'Recovery & consolidation week';
    return 'Improve threshold pace & race readiness';
  }

  String planDescription(RunningStats stats) {
    final form = stats.formScore;
    if (form < -10) {
      return 'You\'re currently fatigued. This week focuses on recovery with reduced volume and easy effort.';
    }
    if (form > 10) {
      return 'You\'re fresh and ready. This week includes a quality session to build fitness.';
    }
    return 'Balanced week combining easy aerobic base, quality work, and a long run.';
  }
}