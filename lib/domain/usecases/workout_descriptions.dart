import '../entities/return_context.dart';
import '../entities/run_walk_phase.dart';
import '../entities/running_stats.dart';

class WorkoutDescriptions {
  const WorkoutDescriptions();

  String easy() =>
      'Today\'s goal is active recovery. Keep a conversational pace throughout in strictly Zone 2. Focus on your running form rather than speed.';

  String intervals(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      return 'This workout boosts your VO2Max. Push hard during the 4 sets of 90-second Zone 5 intervals, and focus on catching your breath and maintaining form during the recovery jogs.';
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      return 'This workout boosts your VO2Max. Push hard during the 8 sets of 90-second Zone 5 intervals, and focus on catching your breath and maintaining form during the recovery jogs.';
    }
    return 'This workout boosts your VO2Max. Push hard during the 6 sets of 90-second Zone 5 intervals, and focus on catching your breath and maintaining form during the recovery jogs.';
  }

  String intervalsCycle(RunningStats stats, int weekInCycle) {
    if (weekInCycle >= 3) {
      return 'This is your deload week, so there are no intervals scheduled. Stick to easy running only.';
    }
    switch (weekInCycle) {
      case 0:
        return 'This session builds your aerobic power. Push through 5 sets of 1km at Threshold pace, and use the 2-minute jogs to recover fully.';
      case 1:
        return 'This session targets your maximum aerobic capacity. Hit your VO2max pace for 8 sets of 600m, and focus on quick recovery during the 90-second jogs.';
      case 2:
        return 'This is a high-intensity VO2max session. Push hard for 12 sets of 400m, and focus on catching your breath during the 90-second recovery jogs.';
      default:
        return intervals(stats);
    }
  }

  String tempo(int tempoWorkMin) =>
      'This session builds your lactate threshold. Run for $tempoWorkMin minutes at a comfortably hard Zone 4 pace where you can still speak in short sentences.';

  String longRun(int durationMinutes) {
    var desc =
        'This long, easy run is the most important session of your week. Stay strictly in Zone 2 to build endurance, and feel free to take walk breaks if needed.';
    if (durationMinutes >= 60) {
      desc +=
          ' Since you\'ll be out for a while, make sure to hydrate every 20-30 minutes.';
    }
    return desc;
  }

  String rest() =>
      'Today is a rest day. Let your body recover and absorb the training from previous days.';

  String crossTraining() =>
      'Today is for cross-training. Engage in a low-impact activity like cycling, swimming, or strength training to build resilience.';

  String beginnerRunWalk(RunWalkPhase phase) =>
      'This session uses intervals to safely build your running endurance. Follow the ${phase.label} structure and keep your effort easy.';

  String returningRamp(int rampWeek) =>
      'You are in week $rampWeek of your return ramp. We are safely rebuilding your base, so keep the pace very easy and listen closely to your body.';

  String deload() =>
      'This is a deload week. Volume is intentionally reduced and all paces should be kept easy to let your body recover fully.';

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
      return 'You are returning from a ${ctx?.category.name} break. We are safely ramping up your volume over the coming weeks. Your current form is slightly detrained, so focus on consistency rather than speed.';
    }

    if (weekInCycle == 3 && phase == CyclePhase.advanced) {
      return 'This is a Recovery & Consolidation week. We are focusing on reduced volume and easy efforts only to shed fatigue. Your current form indicates you are carrying high cumulative stress, so please prioritize rest.';
    }

    if (form < -15) {
      return 'This week is focused heavily on recovery. Your current form indicates you are Very Fatigued, so we have reduced volume and kept all efforts easy to prevent overtraining.';
    }

    if (phase == CyclePhase.baseBuilding) {
      return 'This is a Base Building week. We are focusing on gradually increasing your weekly volume. Your training load is well-balanced, so keep your easy runs strictly easy to build a solid aerobic foundation.';
    }

    if (phase == CyclePhase.advanced && weekInCycle >= 0) {
      return 'This is Week ${weekInCycle + 1} of your periodized block. Your form is peaking, so we are introducing challenging quality sessions to test your threshold and VO2Max.';
    }

    if (form > 10) {
      return 'You are Fresh and ready to push. This week includes challenging quality sessions designed to take your fitness to the next level while maintaining a strong aerobic base.';
    }

    return 'This is a balanced week combining an easy aerobic base, quality interval work, and a long run. Your form is Optimal and your training load is well-balanced to safely maintain and build your fitness.';
  }
}
