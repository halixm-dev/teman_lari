import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:strava_run_analyzer/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: StravaRunAnalyzerApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
