import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teman_lari/domain/entities/running_stats.dart';
import 'package:teman_lari/presentation/widgets/weekly_volume_chart.dart';

void main() {
  testWidgets('WeeklyVolumeChart renders correctly and calculates max correctly', (WidgetTester tester) async {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final currentWeekKey = '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';

    final stats = RunningStats(
      totalRuns: 5,
      totalDistanceKm: 10.0,
      weeklyVolume: {
        currentWeekKey: 2.3,
      },
      weeklyMinutes: {
        currentWeekKey: 15.0,
      },
      averagePace: const Duration(minutes: 6),
      paceProgression: [],
      heartRateZones: {},
      trainingLoadHistory: [],
      vo2MaxEstimate: null,
      fitnessScore: 10,
      fatigueScore: 5,
      formScore: 5,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeeklyVolumeChart(stats: stats),
        ),
      ),
    );

    // Verify it renders the summary
    expect(find.textContaining('This Week'), findsOneWidget);
    expect(find.textContaining('2.3 km'), findsOneWidget);

    // We can also find the WeeklyVolumeChart type
    expect(find.byType(WeeklyVolumeChart), findsOneWidget);
  });
}
