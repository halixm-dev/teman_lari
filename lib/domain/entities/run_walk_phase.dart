enum RunWalkPhaseType {
  phase1,
  phase2,
  phase3,
  phase4,
  phase5,
  phase6,
  continuous,
}

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
    if (totalRuns < 3 || daysSinceFirstRun < 7) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.phase1,
        runSeconds: 60,
        walkSeconds: 120,
        totalDurationMinutes: 16,
        label: 'Run 1 min, Walk 2 min (6x)',
      );
    }
    if (totalRuns < 6 || daysSinceFirstRun < 14) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.phase2,
        runSeconds: 120,
        walkSeconds: 60,
        totalDurationMinutes: 17,
        label: 'Run 2 min, Walk 1 min (6x)',
      );
    }
    if (totalRuns < 9 || daysSinceFirstRun < 21) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.phase3,
        runSeconds: 240,
        walkSeconds: 60,
        totalDurationMinutes: 19,
        label: 'Run 4 min, Walk 1 min (4x)',
      );
    }
    if (totalRuns < 12 || daysSinceFirstRun < 28) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.phase4,
        runSeconds: 360,
        walkSeconds: 120,
        totalDurationMinutes: 22,
        label: 'Run 6 min, Walk 2 min (3x)',
      );
    }
    if (totalRuns < 15 || daysSinceFirstRun < 35) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.phase5,
        runSeconds: 480,
        walkSeconds: 120,
        totalDurationMinutes: 18,
        label: 'Run 8 min, Walk 2 min (2x)',
      );
    }
    if (totalRuns < 18 || daysSinceFirstRun < 42) {
      return const RunWalkPhase(
        type: RunWalkPhaseType.phase6,
        runSeconds: 720,
        walkSeconds: 120,
        totalDurationMinutes: 26,
        label: 'Run 12 min, Walk 2 min (2x)',
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
