import '../entities/return_context.dart';
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

  String goal(RunningStats stats, {int weekInCycle = -1}) {
    if (stats.returnContext?.isReturning == true &&
        stats.returnContext?.category != GapCategory.extended) {
      return 'Safely return to running';
    }

    if (stats.totalRuns < 10 ||
        stats.recommendedPhase == CyclePhase.beginner ||
        stats.returnContext?.category == GapCategory.extended) {
      return 'Build a consistent running base';
    }

    if (stats.recommendedPhase == CyclePhase.baseBuilding) {
      return 'Increase aerobic capacity & volume';
    }

    if (stats.formScore < -10 || weekInCycle == 3) {
      return 'Recovery & consolidation week';
    }

    if (stats.recommendedPhase == CyclePhase.advanced) {
      return 'Peak performance & race readiness';
    }

    return 'Improve threshold pace & endurance';
  }

  String planDescription(RunningStats stats, {int weekInCycle = -1}) {
    final form = stats.formScore;
    final phase = stats.recommendedPhase;
    final ctx = stats.returnContext;

    if (ctx?.isReturning == true && ctx?.category != GapCategory.extended) {
      return 'You are returning from a ${ctx?.category.name} break. We are ramping up your volume safely over the next few weeks to prevent injury.';
    }

    if (weekInCycle == 3 && phase == CyclePhase.advanced) {
      return 'This is your deload week. Volume is reduced to allow your body to absorb the training stress from the past 3 weeks.';
    }

    if (form < -15) {
      return 'Your fatigue is very high. This week focuses heavily on recovery with reduced volume and easy efforts only to prevent overtraining.';
    }

    if (phase == CyclePhase.baseBuilding) {
      return 'We are slowly increasing your weekly volume. Keep your easy runs strictly easy to build a solid aerobic foundation.';
    }

    if (phase == CyclePhase.advanced && weekInCycle >= 0) {
      return 'Week ${weekInCycle + 1} of your periodized block. Volume is peaking, and quality sessions will test your threshold and VO2Max.';
    }

    if (form > 10) {
      return 'You\'re fresh and ready. This week includes challenging quality sessions to build your fitness to the next level.';
    }

    return 'A balanced week combining an easy aerobic base, quality interval work, and a long run to maintain your fitness.';
  }
}
