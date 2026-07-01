import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:teman_lari/data/datasources/local_activity_datasource.dart';
import 'package:teman_lari/data/models/activity_model.dart';

void main() {
  late LocalActivityDataSource dataSource;
  late Directory tempDir;

  setUp(() async {
    // Create a temporary directory for Hive testing
    tempDir = await Directory.systemTemp.createTemp('hive_test_dir');
    Hive.init(tempDir.path);
    dataSource = LocalActivityDataSource();
  });

  tearDown(() async {
    // Close all boxes and delete the directory
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  final mockActivities = [
    const ActivityModel(
      id: 101,
      name: 'Morning Run',
      type: 'Run',
      distance: 5000.0,
      movingTime: 1500,
      elapsedTime: 1600,
      totalElevationGain: 50.0,
      startDate: '2026-05-20T08:00:00Z',
      averageSpeed: 3.33,
      maxSpeed: 4.5,
      averageHeartrate: 150.0,
      maxHeartrate: 170.0,
      averageCadence: 85.0,
      sufferScore: 25,
      hasHeartrate: true,
    ),
    const ActivityModel(
      id: 102,
      name: 'Evening Jog',
      type: 'Run',
      distance: 8000.0,
      movingTime: 2400,
      elapsedTime: 2500,
      totalElevationGain: 80.0,
      startDate: '2026-05-20T18:00:00Z',
      averageSpeed: 3.33,
      maxSpeed: 4.2,
      averageHeartrate: 145.0,
      maxHeartrate: 165.0,
      averageCadence: 82.0,
      sufferScore: 30,
      hasHeartrate: true,
    ),
  ];

  group('LocalActivityDataSource - Hive Refactor Tests', () {
    test(
      'saveActivities and getCachedActivities returns activities in descending ID order',
      () async {
        await dataSource.saveActivities(mockActivities);

        final cached = await dataSource.getCachedActivities();
        check(cached).isNotNull();
        check(cached!.length).equals(2);
        // Should be sorted by ID DESC: 102 first, then 101
        check(cached[0].id).equals(102);
        check(cached[1].id).equals(101);
      },
    );

    test(
      'getCachedActivities returns null if cache is older than 1 hour',
      () async {
        // Open the box directly to inject a stale entry
        final box = await dataSource.activitiesBox;
        final oneHourAndFiveMinutesAgo = DateTime.now()
            .subtract(const Duration(minutes: 65))
            .millisecondsSinceEpoch;

        await box.put(101, {
          'id': 101,
          'data': jsonEncode(mockActivities[0].toJson()),
          'synced_at': oneHourAndFiveMinutesAgo,
        });

        final cached = await dataSource.getCachedActivities();
        check(cached).isNull();
      },
    );

    test(
      'saveHeartRateStream and getCachedHeartRateStreams caches and retrieves streams',
      () async {
        final streamData = [140.0, 142.0, 145.0, 148.0, 150.0];
        await dataSource.saveHeartRateStream(101, streamData);

        final cached = await dataSource.getCachedHeartRateStreams();
        check(cached).containsKey(101);
        check(cached[101]!).deepEquals(streamData);
      },
    );

    test(
      'getCachedHeartRateStreams filters out streams older than 1 hour',
      () async {
        final box = await dataSource.hrStreamsBox;
        final oneHourAndFiveMinutesAgo = DateTime.now()
            .subtract(const Duration(minutes: 65))
            .millisecondsSinceEpoch;

        final streamData = [140.0, 142.0, 145.0, 148.0, 150.0];
        await box.put(101, {
          'activity_id': 101,
          'data': jsonEncode(streamData),
          'synced_at': oneHourAndFiveMinutesAgo,
        });

        final cached = await dataSource.getCachedHeartRateStreams();
        check(cached).not((it) => it.containsKey(101));
      },
    );

    test('clearCache removes all cached data', () async {
      await dataSource.saveActivities(mockActivities);
      await dataSource.saveHeartRateStream(101, [140.0, 142.0]);

      await dataSource.clearCache();

      // Check boxes directly or via dataSource
      final cachedActivities = await dataSource.getCachedActivities();
      check(cachedActivities).isNull();

      final cachedStreams = await dataSource.getCachedHeartRateStreams();
      check(cachedStreams).isEmpty();
    });
  });
}
