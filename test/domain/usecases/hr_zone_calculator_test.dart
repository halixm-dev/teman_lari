import 'package:flutter_test/flutter_test.dart';
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

        expect(zones.length, 5);
        // With maxHr=190, restingHr=60 → HRR=130
        // Zone 1: 60 – 60+130*0.60=138
        // Zone 2: 138 – 60+130*0.70=151
        // Zone 3: 151 – 60+130*0.80=164
        // Zone 4: 164 – 60+130*0.90=177
        // Zone 5: 177 – 190
        expect(zones[0].minBpm, 60);
        expect(zones[0].maxBpm, 138);
        expect(zones[1].minBpm, 138);
        expect(zones[1].maxBpm, 151);
        expect(zones[2].minBpm, 151);
        expect(zones[2].maxBpm, 164);
        expect(zones[3].minBpm, 164);
        expect(zones[3].maxBpm, 177);
        expect(zones[4].minBpm, 177);
        expect(zones[4].maxBpm, 190);
      },
    );

    test('uses custom restingHr when provided', () {
      final zones = HrZoneCalculator.fromActivities([], restingHr: 50);

      // maxHr defaults to 190, restingHr=50 → HRR=140
      // Zone 1: 50 – 50+140*0.60=134
      expect(zones[0].minBpm, 50);
      expect(zones[0].maxBpm, 134);
      // Zone 5 max is always maxHr
      expect(zones[4].maxBpm, 190);
    });

    test('uses custom maxHr when provided', () {
      final zones = HrZoneCalculator.fromActivities([], maxHr: 200);

      // maxHr=200, restingHr=60 → HRR=140
      // Zone 1: 60 – 60+140*0.60=144
      expect(zones[0].minBpm, 60);
      expect(zones[0].maxBpm, 144);
      expect(zones[4].maxBpm, 200);
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
      expect(zones[0].minBpm, 45);
      expect(zones[0].maxBpm, 129);
      expect(zones[4].maxBpm, 185);
    });

    test('custom maxHr overrides observed max from activities', () {
      final activities = [_makeActivity(maxHeartRate: 195)];

      // Without custom maxHr, observed max = 195
      final zonesDefault = HrZoneCalculator.fromActivities(activities);
      expect(zonesDefault[4].maxBpm, 195);

      // With custom maxHr=180, it should override observed 195
      final zonesCustom = HrZoneCalculator.fromActivities(
        activities,
        maxHr: 180,
      );
      expect(zonesCustom[4].maxBpm, 180);
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
