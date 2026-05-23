class TrainingPlanConfig {
  // --- Volume allocation fractions ---
  final double longRunFraction;
  final double easyFraction;
  final double tempoFraction;

  // --- Duration bounds ---
  final int minRunDuration;
  final int minEasyRunMinutes;
  final double longRunMultiplier;
  final int longRunMinCap;
  final int longRunMaxCap;

  // --- Weekly minute bounds ---
  final double minWeeklyMinutes;
  final double maxWeeklyMinutes;
  final double maxWeeklyMinutesScaleUp;

  // --- Form thresholds ---
  final double dangerTsbThreshold;
  final double fatiguedTsbThreshold;
  final double tiredTsbThreshold;
  final double optimalTsbThreshold;

  // --- ACWR ---
  final int minAcwrDays;

  // --- Interval duration thresholds ---
  final int beginnerRunCount;
  final int transitionRunCount;
  final int intermediateRunCount;
  final double beginnerWeeklyKm;
  final int advancedRunCount;
  final double advancedWeeklyKm;
  final int beginnerIntervalMin;
  final int intermediateIntervalMin;
  final int advancedIntervalMin;

  // --- Goal & description thresholds ---
  final int baseBuildingRunCount;
  final double aerobicFitnessScore;
  final double freshFormScore;

  // --- Gap threshold for return sequence ---
  final int returnGapDays;

  // --- Periodization (Advanced only) ---
  final int cycleLengthWeeks;
  final double deloadVolumeFraction;
  final double buildWeekVolumeIncrement;
  final double deloadLongRunFraction;

  // --- Beginner protocol ---
  final int beginnerMaxRunsPerWeek;
  final int beginnerMinEasyMinutes;
  final int beginnerWeeklyMinTarget;
  final int continuousRunThreshold;

  // --- Returning runner protocol ---
  final int shortGapDays;
  final int longGapDays;
  final int injuryGapDays;
  final int staleActivityDays;
  final double returnStartFraction;
  final double returnWeeklyIncreaseCap;
  final int returnEasyOnlyWeeks;
  final int returnRampWeeks;

  const TrainingPlanConfig({
    this.longRunFraction = 0.30,
    this.easyFraction = 0.20,
    this.tempoFraction = 0.15,
    this.minRunDuration = 10,
    this.minEasyRunMinutes = 20,
    this.longRunMultiplier = 1.5,
    this.longRunMinCap = 20,
    this.longRunMaxCap = 120,
    this.minWeeklyMinutes = 60.0,
    this.maxWeeklyMinutes = 600.0,
    this.maxWeeklyMinutesScaleUp = 900.0,
    this.dangerTsbThreshold = -20.0,
    this.fatiguedTsbThreshold = -15.0,
    this.tiredTsbThreshold = -10.0,
    this.optimalTsbThreshold = 5.0,
    this.minAcwrDays = 28,
    this.beginnerRunCount = 15,
    this.transitionRunCount = 15,
    this.intermediateRunCount = 23,
    this.beginnerWeeklyKm = 20.0,
    this.advancedRunCount = 50,
    this.advancedWeeklyKm = 50.0,
    this.beginnerIntervalMin = 30,
    this.intermediateIntervalMin = 36,
    this.advancedIntervalMin = 42,
    this.baseBuildingRunCount = 10,
    this.aerobicFitnessScore = 30.0,
    this.freshFormScore = 10.0,
    this.returnGapDays = 3,
    this.cycleLengthWeeks = 4,
    this.deloadVolumeFraction = 0.50,
    this.buildWeekVolumeIncrement = 0.10,
    this.deloadLongRunFraction = 0.50,
    this.beginnerMaxRunsPerWeek = 3,
    this.beginnerMinEasyMinutes = 10,
    this.beginnerWeeklyMinTarget = 45,
    this.continuousRunThreshold = 15,
    this.shortGapDays = 3,
    this.longGapDays = 7,
    this.injuryGapDays = 14,
    this.staleActivityDays = 90,
    this.returnStartFraction = 0.55,
    this.returnWeeklyIncreaseCap = 0.10,
    this.returnEasyOnlyWeeks = 1,
    this.returnRampWeeks = 3,
  });

  static const defaultConfig = TrainingPlanConfig();
}
