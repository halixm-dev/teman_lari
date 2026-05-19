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
  final double fatiguedThreshold;
  final double slightlyFatiguedThreshold;

  // --- Interval duration thresholds ---
  final int beginnerRunCount;
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
    this.fatiguedThreshold = -10.0,
    this.slightlyFatiguedThreshold = -5.0,
    this.beginnerRunCount = 15,
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
  });

  static const defaultConfig = TrainingPlanConfig();
}
