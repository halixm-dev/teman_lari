enum RunWalkPhaseType { initiation, development, endurance, continuous }

class RunWalkPhase {
  final RunWalkPhaseType type;
  final int runSeconds;
  final int walkSeconds;
  final int totalDurationMinutes;
  final String label;

  const RunWalkPhase({
    required this.type,
    required this.runSeconds,
    required this.walkSeconds,
    required this.totalDurationMinutes,
    required this.label,
  });

  bool get isContinuous => type == RunWalkPhaseType.continuous;

  static RunWalkPhase fromStats(int totalRuns, int daysSinceFirstRun) {
    if (totalRuns < 5 || daysSinceFirstRun < 14) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.initiation,
        runSeconds: 60,
        walkSeconds: 120,
        totalDurationMinutes: 15,
        label: 'Run 1 min, Walk 2 min',
      );
    }
    if (totalRuns < 10 || daysSinceFirstRun < 28) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.development,
        runSeconds: 120,
        walkSeconds: 60,
        totalDurationMinutes: 20,
        label: 'Run 2 min, Walk 1 min',
      );
    }
    if (totalRuns < 15 || daysSinceFirstRun < 49) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.endurance,
        runSeconds: 240,
        walkSeconds: 60,
        totalDurationMinutes: 25,
        label: 'Run 4 min, Walk 1 min',
      );
    }
    return const RunWalkPhase(
      type: RunWalkPhaseType.continuous,
      runSeconds: 0,
      walkSeconds: 0,
      totalDurationMinutes: 30,
      label: 'Continuous run',
    );
  }
}
