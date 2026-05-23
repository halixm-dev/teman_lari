enum TsbState { danger, fatigued, tired, optimal, fresh }

extension TsbStateResolver on TsbState {
  static TsbState fromFormScore(
    double formScore, {
    double dangerThreshold = -20.0,
    double fatiguedThreshold = -15.0,
    double tiredThreshold = -10.0,
    double optimalThreshold = 5.0,
  }) {
    if (formScore < dangerThreshold) return TsbState.danger;
    if (formScore < fatiguedThreshold) return TsbState.fatigued;
    if (formScore < tiredThreshold) return TsbState.tired;
    if (formScore <= optimalThreshold) return TsbState.optimal;
    return TsbState.fresh;
  }
}
