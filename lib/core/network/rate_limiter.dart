class RateLimiter {
  final _requestTimes = <DateTime>[];
  static const maxPer15Min = 95;

  Future<void> checkAndWait() async {
    final now = DateTime.now();
    final windowStart = now.subtract(const Duration(minutes: 15));
    _requestTimes.removeWhere((t) => t.isBefore(windowStart));

    if (_requestTimes.length >= maxPer15Min) {
      final oldestInWindow = _requestTimes.first;
      final waitUntil = oldestInWindow.add(const Duration(minutes: 15));
      final waitDuration = waitUntil.difference(now);
      if (waitDuration.isNegative == false) {
        await Future.delayed(waitDuration);
      }
    }

    _requestTimes.add(DateTime.now());
  }
}
