import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';
import 'package:teman_lari/domain/entities/activity.dart';
import 'package:teman_lari/domain/usecases/hr_zone_calculator.dart';

Activity _makeActivity({required double maxHeartRate, Duration? movingTime}) {
  return Activity(
    type: ActivityType.run,
    id: 1,
    name: 'Test Run',
    date: DateTime.now(),
    distanceKm: 5.0,
    movingTime: movingTime ?? const Duration(minutes: 30),
    pace: const Duration(minutes: 6),
    elevationGainM: 10,
    trainingLoad: TrainingLoad.moderate,
    maxHeartRate: maxHeartRate,
    avgHeartRate: maxHeartRate - 20,
  );
}

void main() {
  group('HrZoneCalculator', () {
    test(
      'uses default restingHr=60 and default maxHr=190 with empty activities',
      () {
        final zones = HrZoneCalculator.fromActivities([]);

        check(zones.length).equals(5);
        // With maxHr=190, restingHr=60 → HRR=130
        // Zone 1: 60 – 60+130*0.60=138
        // Zone 2: 138 – 60+130*0.70=151
        // Zone 3: 151 – 60+130*0.80=164
        // Zone 4: 164 – 60+130*0.90=177
        // Zone 5: 177 – 190
        check(zones[0].minBpm).equals(60);
        check(zones[0].maxBpm).equals(138);
        check(zones[1].minBpm).equals(138);
        check(zones[1].maxBpm).equals(151);
        check(zones[2].minBpm).equals(151);
        check(zones[2].maxBpm).equals(164);
        check(zones[3].minBpm).equals(164);
        check(zones[3].maxBpm).equals(177);
        check(zones[4].minBpm).equals(177);
        check(zones[4].maxBpm).equals(190);
      },
    );

    test('uses custom restingHr when provided', () {
      final zones = HrZoneCalculator.fromActivities([], restingHr: 50);

      // maxHr defaults to 190, restingHr=50 → HRR=140
      // Zone 1: 50 – 50+140*0.60=134
      check(zones[0].minBpm).equals(50);
      check(zones[0].maxBpm).equals(134);
      // Zone 5 max is always maxHr
      check(zones[4].maxBpm).equals(190);
    });

    test('uses custom maxHr when provided', () {
      final zones = HrZoneCalculator.fromActivities([], maxHr: 200);

      // maxHr=200, restingHr=60 → HRR=140
      // Zone 1: 60 – 60+140*0.60=144
      check(zones[0].minBpm).equals(60);
      check(zones[0].maxBpm).equals(144);
      check(zones[4].maxBpm).equals(200);
    });

    test('custom maxHr and restingHr both override defaults', () {
      final zones = HrZoneCalculator.fromActivities(
        [],
        maxHr: 185,
        restingHr: 45,
      );

      // maxHr=185, restingHr=45 → HRR=140
      // Zone 1: 45 – 45+140*0.60=129
      // Zone 5: ... – 185
      check(zones[0].minBpm).equals(45);
      check(zones[0].maxBpm).equals(129);
      check(zones[4].maxBpm).equals(185);
    });

    test('custom maxHr overrides observed max from activities', () {
      final activities = [_makeActivity(maxHeartRate: 195)];

      // Without custom maxHr, observed max = 195
      final zonesDefault = HrZoneCalculator.fromActivities(activities);
      check(zonesDefault[4].maxBpm).equals(195);

      // With custom maxHr=180, it should override observed 195
      final zonesCustom = HrZoneCalculator.fromActivities(
        activities,
        maxHr: 180,
      );
      check(zonesCustom[4].maxBpm).equals(180);
    });

    test('zones are contiguous (each zone max == next zone min)', () {
      final zones = HrZoneCalculator.fromActivities(
        [],
        maxHr: 190,
        restingHr: 60,
      );

      for (int i = 0; i < zones.length - 1; i++) {
        expect(
          zones[i].maxBpm,
          zones[i + 1].minBpm,
          reason: 'Zone ${i + 1} max should equal Zone ${i + 2} min',
        );
      }
    });

    test('zone numbers are 1 through 5', () {
      final zones = HrZoneCalculator.fromActivities([]);
      for (int i = 0; i < 5; i++) {
        expect(zones[i].zoneNumber, i + 1);
      }
    });
  });
}
