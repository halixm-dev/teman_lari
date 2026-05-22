import 'package:flutter_test/flutter_test.dart';
import 'package:teman_lari/domain/entities/activity.dart';
import 'package:teman_lari/domain/usecases/training_load_calculator.dart';

void main() {
  group('TrainingLoadCalculator', () {
    late TrainingLoadCalculator calculator;

    setUp(() {
      calculator = TrainingLoadCalculator();
    });

    test('should return empty list when no activities', () {
      final result = calculator.computeLoadHistory(
        [],
        maxHr: 190,
        restingHr: 60,
      );
      expect(result, isEmpty);
    });

    test(
      'should calculate CTL, ATL, and TSB correctly using standard Coggan decay',
      () {
        // Let's create an activity on Monday, 3 days ago relative to now.
        final now = DateTime.now();
        final monday = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 3));

        final activity = Activity(
          type: ActivityType.run,
          id: 1,
          name: 'Monday Run',
          date: monday,
          distanceKm: 5.0,
          movingTime: const Duration(
            minutes: 34,
          ), // 34 minutes, no HR means TSS = 34 * 0.5 = 17
          pace: const Duration(minutes: 6, seconds: 48),
          elevationGainM: 10,
          trainingLoad: TrainingLoad.moderate,
        );

        final result = calculator.computeLoadHistory(
          [activity],
          maxHr: 190,
          restingHr: 60,
        );

        // Verify history has points for each day up to today
        expect(result.length, equals(4));

        // Day 0: Monday (run day)
        // Standard Coggan decay factor is 1/42 for CTL and 1/7 for ATL.
        // Day 0 (Monday):
        // CTL = 17 * (1/42) = 0.4047...
        // ATL = 17 * (1/7) = 2.4285...
        // Form = CTL - ATL = 0.4047 - 2.4285 = -2.0238...
        expect(result[0].fitness, closeTo(0.4048, 0.01));
        expect(result[0].fatigue, closeTo(2.4285, 0.01));

        // Day 1: Tuesday (decay day)
        // CTL = 0.4047 * (41/42) = 0.3951...
        // ATL = 2.4285 * (6/7) = 2.0816...
        expect(result[1].fitness, closeTo(0.3951, 0.01));
        expect(result[1].fatigue, closeTo(2.0816, 0.01));

        // Day 2: Wednesday (decay day)
        // CTL = 0.3951 * (41/42) = 0.3857...
        // ATL = 2.0816 * (6/7) = 1.7842...
        expect(result[2].fitness, closeTo(0.3857, 0.01));
        expect(result[2].fatigue, closeTo(1.7842, 0.01));

        // Day 3: Thursday (decay day - today)
        // CTL = 0.3857 * (41/42) = 0.3765...
        // ATL = 1.7842 * (6/7) = 1.5293...
        // Form = CTL - ATL = 0.3765 - 1.5293 = -1.1528...
        expect(result[3].fitness, closeTo(0.3765, 0.01));
        expect(result[3].fatigue, closeTo(1.5293, 0.01));
      },
    );
  });
}
