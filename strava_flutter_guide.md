# Strava Running Analyzer — Flutter Developer Guide

A complete guide to building a Flutter app that connects to the Strava API, analyzes your running history, and generates personalized training plans with pace and heart rate targets.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture Overview](#2-architecture-overview)
3. [Prerequisites & Setup](#3-prerequisites--setup)
4. [Strava API Integration](#4-strava-api-integration)
5. [Data Models](#5-data-models)
6. [State Management](#6-state-management)
7. [Core Features: Analysis Engine](#7-core-features-analysis-engine)
8. [Training Plan Generator](#8-training-plan-generator)
9. [UI Screens](#9-ui-screens)
10. [Charts & Visualizations](#10-charts--visualizations)
11. [Local Storage & Caching](#11-local-storage--caching)
12. [Testing Strategy](#12-testing-strategy)
13. [Recommended Packages](#13-recommended-packages)
14. [Deployment Checklist](#14-deployment-checklist)

---

## 1. Project Overview

### What the App Does

- **Authenticates** with Strava via OAuth 2.0
- **Fetches** the user's full running activity history
- **Analyzes** performance trends: pace, heart rate, cadence, elevation, training load
- **Generates** a next-week training plan with specific pace zones and heart rate targets
- **Displays** charts and insights to track progress over time

### User Flow

```
Launch App
    ↓
Strava OAuth Login
    ↓
Fetch Activity History (last 6–12 months)
    ↓
Dashboard: Key Stats & Trends
    ↓
Analysis: Pace Zones, HR Zones, Weekly Volume
    ↓
Plan Generator: Next Training Cycle
    ↓
Plan Detail: Day-by-Day Schedule with Targets
```

---

## 2. Architecture Overview

Use **Clean Architecture** with three layers:

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── utils/
├── data/
│   ├── datasources/       # Strava API, local DB
│   ├── models/            # JSON serialization
│   └── repositories/      # Implementations
├── domain/
│   ├── entities/          # Pure Dart classes
│   ├── repositories/      # Interfaces
│   └── usecases/          # Business logic
└── presentation/
    ├── providers/          # Riverpod providers
    ├── screens/
    ├── widgets/
    └── theme/
```

**State Management:** Riverpod (recommended for this use case — supports async data, caching, and testability).

**Data Flow:**
```
Strava API → RemoteDataSource → Repository → UseCase → Provider → UI
                                     ↕
                              LocalDataSource (SQLite / Hive)
```

---

## 3. Prerequisites & Setup

### 3.1 Flutter Setup

Requires Flutter 3.13+ and Dart 3.1+.

```bash
flutter create teman_lari --org com.yourname
cd teman_lari
```

### 3.2 Strava Developer Account

1. Go to [https://developers.strava.com](https://developers.strava.com) and create an app.
2. Set **Authorization Callback Domain** to `localhost` (or your preferred domain, ensuring the `redirect_uri` host matches it).
3. Note your **Client ID** and **Client Secret**.

### 3.3 Environment Config

Never hardcode secrets. Use `--dart-define` or `flutter_dotenv`:

```dart
// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String stravaClientId =
      String.fromEnvironment('STRAVA_CLIENT_ID');
  static const String stravaClientSecret =
      String.fromEnvironment('STRAVA_CLIENT_SECRET');
  static const String stravaRedirectUri =
      String.fromEnvironment('STRAVA_REDIRECT_URI');
  static const String stravaBaseUrl = 'https://www.strava.com/api/v3';
  static const String stravaAuthUrl = 'https://www.strava.com/oauth/authorize';
  static const String stravaTokenUrl = 'https://www.strava.com/oauth/token';
}
```

Run with:
```bash
flutter run \
  --dart-define=STRAVA_CLIENT_ID=your_id \
  --dart-define=STRAVA_CLIENT_SECRET=your_secret \
  --dart-define=STRAVA_REDIRECT_URI=com.yourname.temanLari://callback
```

### 3.4 Android Setup

`android/app/src/main/AndroidManifest.xml` — add inside `<activity>`:
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW"/>
  <category android:name="android.intent.category.DEFAULT"/>
  <category android:name="android.intent.category.BROWSABLE"/>
  <data android:scheme="com.yourname.temanLari" android:host="callback"/>
</intent-filter>
```

### 3.5 iOS Setup

`ios/Runner/Info.plist` — add:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.yourname.temanLari</string>
    </array>
  </dict>
</array>
```

---

## 4. Strava API Integration

### 4.1 OAuth 2.0 Authentication

Use `flutter_web_auth_2` to handle the browser-based OAuth flow:

```dart
// lib/data/datasources/strava_auth_datasource.dart
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StravaAuthDataSource {
  Future<StravaTokens> authenticate() async {
    // Step 1: Open Strava login in browser
    final authUrl = Uri.https('www.strava.com', '/oauth/authorize', {
      'client_id': ApiConstants.stravaClientId,
      'redirect_uri': ApiConstants.stravaRedirectUri,
      'response_type': 'code',
      'scope': 'activity:read_all',
      'approval_prompt': 'auto',
    });

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: 'com.yourname.temanLari',
    );

    final code = Uri.parse(result).queryParameters['code']!;

    // Step 2: Exchange code for tokens
    final response = await http.post(
      Uri.parse(ApiConstants.stravaTokenUrl),
      body: {
        'client_id': ApiConstants.stravaClientId,
        'client_secret': ApiConstants.stravaClientSecret,
        'code': code,
        'grant_type': 'authorization_code',
      },
    );

    final json = jsonDecode(response.body);
    return StravaTokens.fromJson(json);
  }

  Future<StravaTokens> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse(ApiConstants.stravaTokenUrl),
      body: {
        'client_id': ApiConstants.stravaClientId,
        'client_secret': ApiConstants.stravaClientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
    );
    return StravaTokens.fromJson(jsonDecode(response.body));
  }
}
```

### 4.2 Token Storage

Store tokens securely with `flutter_secure_storage`:

```dart
// lib/data/datasources/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(StravaTokens tokens) async {
    await _storage.write(key: 'access_token', value: tokens.accessToken);
    await _storage.write(key: 'refresh_token', value: tokens.refreshToken);
    await _storage.write(
        key: 'expires_at', value: tokens.expiresAt.toString());
  }

  Future<StravaTokens?> getTokens() async {
    final accessToken = await _storage.read(key: 'access_token');
    final refreshToken = await _storage.read(key: 'refresh_token');
    final expiresAt = await _storage.read(key: 'expires_at');
    if (accessToken == null) return null;
    return StravaTokens(
      accessToken: accessToken,
      refreshToken: refreshToken!,
      expiresAt: int.parse(expiresAt!),
    );
  }

  Future<void> clearTokens() async => _storage.deleteAll();
}
```

### 4.3 API Client with Auto Refresh

```dart
// lib/core/network/strava_api_client.dart
class StravaApiClient {
  final TokenStorage _tokenStorage;
  final StravaAuthDataSource _authDataSource;
  final http.Client _httpClient;

  StravaApiClient(this._tokenStorage, this._authDataSource, this._httpClient);

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? params}) async {
    final token = await _getValidToken();
    final uri = Uri.https('www.strava.com', '/api/v3/$endpoint', params);

    final response = await _httpClient.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw StravaApiException(response.statusCode, response.body);
  }

  Future<List<dynamic>> getList(String endpoint,
      {Map<String, String>? params}) async {
    final token = await _getValidToken();
    final uri = Uri.https('www.strava.com', '/api/v3/$endpoint', params);

    final response = await _httpClient.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    throw StravaApiException(response.statusCode, response.body);
  }

  Future<String> _getValidToken() async {
    var tokens = await _tokenStorage.getTokens();
    if (tokens == null) throw UnauthenticatedException();

    // Refresh if expiring within 60 seconds
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (tokens.expiresAt - now < 60) {
      tokens = await _authDataSource.refreshToken(tokens.refreshToken);
      await _tokenStorage.saveTokens(tokens);
    }

    return tokens.accessToken;
  }
}
```

### 4.4 Activity Data Source

```dart
// lib/data/datasources/strava_activity_datasource.dart
class StravaActivityDataSource {
  final StravaApiClient _client;

  StravaActivityDataSource(this._client);

  /// Fetches all running activities with pagination
  Future<List<ActivityModel>> getAllRunningActivities({
    int monthsBack = 12,
  }) async {
    final allActivities = <ActivityModel>[];
    final after = DateTime.now()
        .subtract(Duration(days: 30 * monthsBack))
        .millisecondsSinceEpoch ~/
        1000;

    int page = 1;
    while (true) {
      final data = await _client.getList(
        'athlete/activities',
        params: {
          'after': after.toString(),
          'per_page': '200',
          'page': page.toString(),
        },
      );

      if (data.isEmpty) break;

      final runningActivities = data
          .map((a) => ActivityModel.fromJson(a))
          .where((a) => a.type == 'Run')
          .toList();

      allActivities.addAll(runningActivities);

      if (data.length < 200) break;
      page++;
    }

    return allActivities;
  }

  /// Fetches detailed streams for a single activity (HR, cadence, etc.)
  Future<ActivityStreams> getActivityStreams(int activityId) async {
    final data = await _client.get(
      'activities/$activityId/streams',
      params: {
        'keys': 'time,heartrate,cadence,velocity_smooth,altitude',
        'key_by_type': 'true',
      },
    );
    return ActivityStreams.fromJson(data);
  }

  /// Fetch athlete's max HR and other profile data
  Future<AthleteModel> getAthlete() async {
    final data = await _client.get('athlete');
    return AthleteModel.fromJson(data);
  }
}
```

---

## 5. Data Models

### 5.1 Activity Model

```dart
// lib/data/models/activity_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_model.freezed.dart';
part 'activity_model.g.dart';

@freezed
class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required int id,
    required String name,
    required String type,
    required double distance,           // meters
    required int movingTime,            // seconds
    required int elapsedTime,           // seconds
    required double totalElevationGain, // meters
    required String startDate,
    @JsonKey(name: 'average_speed') required double averageSpeed,     // m/s
    @JsonKey(name: 'max_speed') required double maxSpeed,             // m/s
    @JsonKey(name: 'average_heartrate') double? averageHeartrate,
    @JsonKey(name: 'max_heartrate') double? maxHeartrate,
    @JsonKey(name: 'average_cadence') double? averageCadence,
    @JsonKey(name: 'suffer_score') int? sufferScore,
    @JsonKey(name: 'has_heartrate') @Default(false) bool hasHeartrate,
    @JsonKey(name: 'workout_type') int? workoutType,
    @JsonKey(name: 'perceived_exertion') double? perceivedExertion,
  }) = _ActivityModel;

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
}
```

### 5.2 Domain Entity

```dart
// lib/domain/entities/run_activity.dart
class RunActivity {
  final int id;
  final String name;
  final DateTime date;
  final double distanceKm;
  final Duration movingTime;
  final Duration pace;           // per km
  final double? avgHeartRate;
  final double? maxHeartRate;
  final double elevationGainM;
  final double? avgCadence;
  final int? sufferScore;
  final TrainingLoad trainingLoad;

  const RunActivity({
    required this.id,
    required this.name,
    required this.date,
    required this.distanceKm,
    required this.movingTime,
    required this.pace,
    required this.elevationGainM,
    required this.trainingLoad,
    this.avgHeartRate,
    this.maxHeartRate,
    this.avgCadence,
    this.sufferScore,
  });

  /// Minutes per kilometer as readable string
  String get paceString {
    final totalSeconds = pace.inSeconds;
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')} /km';
  }
}

enum TrainingLoad { easy, moderate, hard, veryHard }
```

### 5.3 Training Plan Entity

```dart
// lib/domain/entities/training_plan.dart
class TrainingPlan {
  final DateTime startDate;
  final List<TrainingDay> days;
  final String goal;
  final String description;

  const TrainingPlan({
    required this.startDate,
    required this.days,
    required this.goal,
    required this.description,
  });
}

class TrainingDay {
  final DateTime date;
  final WorkoutType type;
  final double? targetDistanceKm;
  final double? warmUpCoolDownKm;  // walk/jog portion (warm-up + cool-down)
  final PaceZone? paceTarget;
  final HrZone? heartRateTarget;
  final String description;
  final Duration? estimatedDuration;

  const TrainingDay({
    required this.date,
    required this.type,
    required this.description,
    this.targetDistanceKm,
    this.warmUpCoolDownKm,
    this.paceTarget,
    this.heartRateTarget,
    this.estimatedDuration,
  });

  /// Running portion of the day (total minus warm-up/cool-down)
  double? get workDistanceKm {
    if (targetDistanceKm == null || warmUpCoolDownKm == null) return null;
    return targetDistanceKm! - warmUpCoolDownKm!;
  }
}

enum WorkoutType { easy, tempo, intervals, longRun, rest, crossTraining }

class PaceZone {
  final Duration slowestPace; // slower bound (per km), e.g. 5:36
  final Duration fastestPace; // faster bound (per km), e.g. 5:12
  final String label;         // e.g., "Easy", "Tempo", "5K pace"

  const PaceZone({
    required this.slowestPace,
    required this.fastestPace,
    required this.label,
  });
}

class HrZone {
  final int minBpm;
  final int maxBpm;
  final int zoneNumber; // 1–5
  final String label;  // e.g., "Zone 2 – Aerobic Base"

  const HrZone({
    required this.minBpm,
    required this.maxBpm,
    required this.zoneNumber,
    required this.label,
  });
}
```

---

## 6. State Management

### 6.1 Riverpod Provider Structure

```dart
// lib/presentation/providers/auth_provider.dart
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(stravaAuthUseCaseProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final StravaAuthUseCase _authUseCase;

  AuthNotifier(this._authUseCase) : super(const AuthState.unknown()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final result = await _authUseCase.checkAuthStatus();
    state = result ? const AuthState.authenticated() : const AuthState.unauthenticated();
  }

  Future<void> login() async {
    state = const AuthState.loading();
    try {
      await _authUseCase.authenticate();
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    await _authUseCase.logout();
    state = const AuthState.unauthenticated();
  }
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState.unknown() = _Unknown;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}
```

```dart
// lib/presentation/providers/activities_provider.dart
final activitiesProvider = AsyncNotifierProvider<ActivitiesNotifier,
    List<RunActivity>>(() => ActivitiesNotifier());

class ActivitiesNotifier extends AsyncNotifier<List<RunActivity>> {
  @override
  Future<List<RunActivity>> build() async {
    return ref.read(getActivitiesUseCaseProvider).execute(monthsBack: 12);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(getActivitiesUseCaseProvider).execute(monthsBack: 12));
  }
}

final runningStatsProvider = Provider<RunningStats?>((ref) {
  final activities = ref.watch(activitiesProvider);
  return activities.whenOrNull(
    data: (data) => ref.read(analyzeRunsUseCaseProvider).compute(data),
  );
});

final trainingPlanProvider = FutureProvider<TrainingPlan>((ref) async {
  final activities = await ref.watch(activitiesProvider.future);
  return ref.read(generatePlanUseCaseProvider).generate(activities);
});
```

---

## 7. Core Features: Analysis Engine

### 7.1 Running Statistics Computation

```dart
// lib/domain/usecases/analyze_runs_usecase.dart
class AnalyzeRunsUseCase {
  RunningStats compute(List<RunActivity> activities,
      {int? maxHr, int? restingHr}) {
    if (activities.isEmpty) return RunningStats.empty();

    final sortedByDate = [...activities]
      ..sort((a, b) => a.date.compareTo(b.date));

    final actualMaxHr = maxHr ?? _resolveMaxHr(activities) ?? 190;
    final actualRestingHr = restingHr ?? _resolveRestingHr(activities) ?? 60;

    return RunningStats(
      totalRuns: activities.length,
      totalDistanceKm: _totalDistance(activities),
      weeklyVolume: _weeklyVolume(activities),
      averagePace: _averagePace(activities),
      paceProgression: _paceProgression(sortedByDate),
      heartRateZones: _hrZoneDistribution(activities,
          maxHr: actualMaxHr, restingHr: actualRestingHr),
      trainingLoadHistory: _trainingLoadHistory(sortedByDate,
          maxHr: actualMaxHr, restingHr: actualRestingHr),
      vo2MaxEstimate: _estimateVo2Max(activities),
      fitnessScore: _fitnessScore(activities,
          maxHr: actualMaxHr, restingHr: actualRestingHr),
      fatigueScore: _fatigueScore(activities,
          maxHr: actualMaxHr, restingHr: actualRestingHr),
      formScore: _formScore(activities,
          maxHr: actualMaxHr, restingHr: actualRestingHr),
    );
  }

  /// Chronic Training Load (CTL) — 42-day rolling average of TSS
  double _fitnessScore(List<RunActivity> activities,
      {int maxHr = 190, int restingHr = 60}) {
    return _exponentialMovingAverage(activities,
        decayDays: 42, maxHr: maxHr, restingHr: restingHr);
  }

  /// Acute Training Load (ATL) — 7-day rolling average of TSS
  double _fatigueScore(List<RunActivity> activities,
      {int maxHr = 190, int restingHr = 60}) {
    return _exponentialMovingAverage(activities,
        decayDays: 7, maxHr: maxHr, restingHr: restingHr);
  }

  /// Form = CTL - ATL. Positive = fresh, negative = fatigued
  double _formScore(List<RunActivity> activities,
      {int maxHr = 190, int restingHr = 60}) {
    return _fitnessScore(activities, maxHr: maxHr, restingHr: restingHr) -
        _fatigueScore(activities, maxHr: maxHr, restingHr: restingHr);
  }

  double _exponentialMovingAverage(List<RunActivity> activities,
      {required int decayDays, int maxHr = 190, int restingHr = 60}) {
    if (activities.isEmpty) return 0;
    final decay = 2 / (decayDays + 1);
    double ema = 0;
    for (final activity in activities) {
      final tss = _trainingStressScore(activity,
          maxHr: maxHr, restingHr: restingHr);
      ema = tss * decay + ema * (1 - decay);
    }
    return ema;
  }

  /// Training Stress Score based on HR and duration
  double _trainingStressScore(RunActivity activity,
      {int maxHr = 190, int restingHr = 60}) {
    if (activity.avgHeartRate == null) {
      // Estimate from pace if no HR
      return activity.movingTime.inMinutes * 0.5;
    }
    // TSS using heart rate reserve (Karvonen formula)
    final hrReserve = (activity.avgHeartRate! - restingHr) / (maxHr - restingHr);
    final durationHours = activity.movingTime.inMinutes / 60.0;
    return hrReserve * hrReserve * durationHours * 100;
  }

  /// Pace trend across time — returns list of (date, secondsPerKm)
  List<PaceDataPoint> _paceProgression(List<RunActivity> sorted) {
    return sorted
        .where((a) => a.distanceKm > 3)
        .map((a) => PaceDataPoint(
              date: a.date,
              paceSecondsPerKm: a.pace.inSeconds,
              distanceKm: a.distanceKm,
            ))
        .toList();
  }

  /// Heart rate zone distribution (Zones 1–5) using HR reserve method
  Map<int, double> _hrZoneDistribution(List<RunActivity> activities,
      {int maxHr = 190, int restingHr = 60}) {
    final withHr = activities.where((a) => a.avgHeartRate != null);
    if (withHr.isEmpty) return {};

    final actualMax = _resolveMaxHr(activities) ?? maxHr;
    final actualResting = _resolveRestingHr(activities) ?? restingHr;

    final zoneTotals = <int, double>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    double totalMinutes = 0;

    for (final activity in withHr) {
      final zone = _hrToZone(activity.avgHeartRate!,
          maxHr: actualMax, restingHr: actualResting);
      final minutes = activity.movingTime.inMinutes.toDouble();
      zoneTotals[zone] = (zoneTotals[zone] ?? 0) + minutes;
      totalMinutes += minutes;
    }

    return zoneTotals.map((k, v) => MapEntry(k, v / totalMinutes));
  }

  int? _resolveMaxHr(List<RunActivity> activities) {
    final values = activities
        .where((a) => a.maxHeartRate != null)
        .map((a) => a.maxHeartRate!);
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a > b ? a : b).round();
  }

  int? _resolveRestingHr(List<RunActivity> activities) {
    final values = activities
        .where((a) => a.avgHeartRate != null)
        .map((a) => a.avgHeartRate!);
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a < b ? a : b).round();
  }

  /// HR to zone using Karvonen (HR reserve) formula
  int _hrToZone(double hr, {required int maxHr, int restingHr = 60}) {
    final hrr = maxHr - restingHr;
    final hrAboveResting = hr - restingHr;
    final pct = hrr > 0 ? hrAboveResting / hrr : 0;
    if (pct < 0.60) return 1;
    if (pct < 0.70) return 2;
    if (pct < 0.80) return 3;
    if (pct < 0.90) return 4;
    return 5;
  }

  /// VO2 max estimate using Daniels formula from race performance
  double? _estimateVo2Max(List<RunActivity> activities) {
    // Use best 5K-equivalent effort
    final candidates = activities.where((a) =>
        a.distanceKm >= 4.5 && a.distanceKm <= 5.5);
    if (candidates.isEmpty) return null;

    final best = candidates.reduce((a, b) =>
        a.pace.inSeconds < b.pace.inSeconds ? a : b);

    // Jack Daniels VDOT formula (simplified)
    final paceMinKm = best.pace.inSeconds / 60.0;
    return 29.54 + (5.000663 / paceMinKm) + (0.007546 / (paceMinKm * paceMinKm));
  }

  Map<String, double> _weeklyVolume(List<RunActivity> activities) {
    final weekly = <String, double>{};
    for (final activity in activities) {
      final weekKey = _isoWeekKey(activity.date);
      weekly[weekKey] = (weekly[weekKey] ?? 0) + activity.distanceKm;
    }
    return weekly;
  }

  String _isoWeekKey(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-W${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  double _totalDistance(List<RunActivity> activities) =>
      activities.fold(0, (sum, a) => sum + a.distanceKm);

  Duration _averagePace(List<RunActivity> activities) {
    final totalSeconds =
        activities.fold<int>(0, (sum, a) => sum + a.pace.inSeconds);
    return Duration(seconds: totalSeconds ~/ activities.length);
  }

  List<TrainingLoadPoint> _trainingLoadHistory(List<RunActivity> sorted,
      {int maxHr = 190, int restingHr = 60}) {
    double fitness = 0, fatigue = 0;
    return sorted.map((activity) {
      final tss = _trainingStressScore(activity,
          maxHr: maxHr, restingHr: restingHr);
      fitness = tss * (2 / 43) + fitness * (41 / 43);
      fatigue = tss * (2 / 8) + fatigue * (6 / 8);
      return TrainingLoadPoint(
        date: activity.date,
        fitness: fitness,
        fatigue: fatigue,
        form: fitness - fatigue,
      );
    }).toList();
  }
}
```

### 7.2 Pace Zone Calculator

```dart
// lib/domain/usecases/pace_zone_calculator.dart
class PaceZoneCalculator {
  /// Calculates 5 pace zones from a threshold pace (lactate threshold pace)
  /// Input: threshold pace in seconds per km
  static List<PaceZone> fromThresholdPace(int thresholdSecondsPerKm) {
    return [
      PaceZone(
        label: 'Zone 1 – Recovery',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.40).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 1.30).round()),
      ),
      PaceZone(
        label: 'Zone 2 – Easy Aerobic',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.30).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 1.15).round()),
      ),
      PaceZone(
        label: 'Zone 3 – Moderate',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.15).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 1.05).round()),
      ),
      PaceZone(
        label: 'Zone 4 – Threshold',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 1.05).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 0.98).round()),
      ),
      PaceZone(
        label: 'Zone 5 – VO2max',
        slowestPace: Duration(seconds: (thresholdSecondsPerKm * 0.98).round()),
        fastestPace: Duration(seconds: (thresholdSecondsPerKm * 0.88).round()),
      ),
    ];
  }

  /// Estimate threshold pace from best recent 20–30 min effort
  static int estimateThresholdPace(List<RunActivity> activities) {
    // Look for efforts between 20–35 minutes
    final candidates = activities
        .where((a) =>
            a.movingTime.inMinutes >= 20 && a.movingTime.inMinutes <= 35)
        .toList()
      ..sort((a, b) => a.pace.inSeconds.compareTo(b.pace.inSeconds));

    if (candidates.isNotEmpty) {
      // Threshold is ~95% of best 20–35 min pace
      return (candidates.first.pace.inSeconds * 1.05).round();
    }

    // Fallback: use average pace of all runs
    final avgPace = activities
        .fold<int>(0, (sum, a) => sum + a.pace.inSeconds) ~/
        activities.length;
    return (avgPace * 0.90).round();
  }
}
```

---

## 8. Training Plan Generator

```dart
// lib/domain/usecases/generate_plan_usecase.dart
class GeneratePlanUseCase {
  final AnalyzeRunsUseCase _analyzeRuns;

  GeneratePlanUseCase({AnalyzeRunsUseCase? analyzeRuns})
      : _analyzeRuns = analyzeRuns ?? AnalyzeRunsUseCase();

  TrainingPlan generate(List<RunActivity> activities) {
    if (activities.isEmpty) return TrainingPlan.empty();

    final stats = _analyzeRuns.compute(activities);
    final thresholdPace = PaceZoneCalculator.estimateThresholdPace(activities);
    final paceZones = PaceZoneCalculator.fromThresholdPace(thresholdPace);
    final hrZones = _calculateHrZones(activities);
    final weeklyKm = _targetWeeklyVolume(stats);
    final startDate = _startDate(activities);

    return TrainingPlan(
      startDate: startDate,
      goal: _determineGoal(stats),
      description: _planDescription(stats),
      days: _buildWeek(
        startDate: startDate,
        weeklyKm: weeklyKm,
        paceZones: paceZones,
        hrZones: hrZones,
        stats: stats,
      ),
    );
  }

  List<TrainingDay> _buildWeek({
    required DateTime startDate,
    required double weeklyKm,
    required List<PaceZone> paceZones,
    required List<HrZone> hrZones,
    required RunningStats stats,
  }) {
    // Classic 80/20 training distribution:
    // 80% easy aerobic + 20% quality (tempo/intervals)
    // Typical 5-day plan: Easy, Intervals, Easy, Tempo, Long

    final longRunKm = weeklyKm * 0.30;
    final easyKm = weeklyKm * 0.20;
    final tempoKm = weeklyKm * 0.15;

    return [
      TrainingDay(
        date: startDate,
        type: WorkoutType.easy,
        targetDistanceKm: easyKm,
        paceTarget: paceZones[1], // Zone 2
        heartRateTarget: hrZones[1], // Zone 2
        estimatedDuration: _estimateDuration(easyKm, paceZones[1]),
        description: 'Easy recovery run. Conversational pace throughout. '
            'Focus on form, not speed.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 1)),
        type: WorkoutType.intervals,
        targetDistanceKm: _intervalDistance(stats),
        warmUpCoolDownKm: 4.0,  // 2km warm-up + 2km cool-down
        paceTarget: paceZones[4], // Zone 5 during intervals
        heartRateTarget: hrZones[4],
        estimatedDuration: _estimateDuration(_intervalDistance(stats), paceZones[4]),
        description: _intervalDescription(stats),
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 2)),
        type: WorkoutType.rest,
        description: 'Rest or 20–30 min easy walk. Let your body absorb '
            'yesterday\'s interval session.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 3)),
        type: WorkoutType.easy,
        targetDistanceKm: easyKm,
        paceTarget: paceZones[1],
        heartRateTarget: hrZones[1],
        estimatedDuration: _estimateDuration(easyKm, paceZones[1]),
        description: 'Easy aerobic run. Stay in Zone 2 the entire run. '
            'Great day for strides at the end (4×100m).',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 4)),
        type: WorkoutType.tempo,
        targetDistanceKm: tempoKm + 2,
        warmUpCoolDownKm: 2.0,  // 1km warm-up + 1km cool-down
        paceTarget: paceZones[3], // Zone 4 during tempo
        heartRateTarget: hrZones[3],
        estimatedDuration: _estimateDuration(tempoKm + 2, paceZones[3]),
        description: '1km warm-up, ${tempoKm.toStringAsFixed(1)}km @ '
            'threshold pace (Zone 4), 1km cool-down. '
            'Comfortably hard — you can speak in short sentences.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 5)),
        type: WorkoutType.rest,
        description: 'Full rest day before long run.',
      ),
      TrainingDay(
        date: startDate.add(const Duration(days: 6)),
        type: WorkoutType.longRun,
        targetDistanceKm: longRunKm,
        paceTarget: paceZones[1], // Easy Zone 2
        heartRateTarget: hrZones[1],
        estimatedDuration: _estimateDuration(longRunKm, paceZones[1]),
        description: 'Long easy run — the most important run of the week. '
            'Stay strictly in Zone 2. Walk breaks are fine. '
            'Hydrate every 20–30 min.',
      ),
    ];
  }

  Duration _estimateDuration(double distanceKm, PaceZone zone) {
    final avgPaceSeconds = (zone.slowestPace.inSeconds + zone.fastestPace.inSeconds) ~/ 2;
    return Duration(seconds: (distanceKm * avgPaceSeconds).round());
  }

  double _targetWeeklyVolume(RunningStats stats) {
    final recentVolume = stats.recentWeeklyAvgKm;
    if (recentVolume <= 0) return 15;
    // Reduce volume when fatigued, increase when fresh
    if (stats.formScore < -10) return (recentVolume * 0.80).clamp(10, 200);
    if (stats.formScore < -5) return (recentVolume * 0.95).clamp(10, 200);
    return (recentVolume * 1.10).clamp(10, 300);
  }

  double _intervalDistance(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      // 2km warm-up + 4×400m (1.6km) + 3 recovery jogs (0.75km) + 2km cool-down
      return 6.4;
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      // 2km warm-up + 8×400m (3.2km) + 7 recovery jogs (1.75km) + 2km cool-down
      return 9.0;
    }
    // 2km warm-up + 6×400m (2.4km) + 5 recovery jogs (1.25km) + 2km cool-down
    return 7.7;
  }

  String _intervalDescription(RunningStats stats) {
    final totalRuns = stats.totalRuns;
    final weeklyKm = stats.recentWeeklyAvgKm;
    if (totalRuns < 15 || weeklyKm < 20) {
      return '2km warm-up @ Zone 2, then 4×400m @ Zone 5 with 90s recovery jogs, 2km cool-down.';
    }
    if (totalRuns > 50 || weeklyKm > 50) {
      return '2km warm-up @ Zone 2, then 8×400m @ Zone 5 with 90s recovery jogs, 2km cool-down.';
    }
    return '2km warm-up @ Zone 2, then 6×400m @ Zone 5 with 90s recovery jogs, 2km cool-down.';
  }

  String _determineGoal(RunningStats stats) {
    if (stats.totalRuns < 10) return 'Build a consistent running base';
    if (stats.fitnessScore < 30) return 'Develop aerobic fitness';
    if (stats.formScore < -10) return 'Recovery & consolidation week';
    return 'Improve threshold pace & race readiness';
  }

  List<HrZone> _calculateHrZones(List<RunActivity> activities) {
    final maxHr = activities
            .where((a) => a.maxHeartRate != null)
            .map((a) => a.maxHeartRate!)
            .fold<double?>(null, (max, hr) => max == null ? hr : (hr > max ? hr : max))
            ?.round() ??
        190;
    final restingHr = activities
            .where((a) => a.avgHeartRate != null)
            .map((a) => a.avgHeartRate!)
            .fold<double?>(null, (min, hr) => min == null ? hr : (hr < min ? hr : min))
            ?.round() ??
        60;
    final actualMax = maxHr.clamp(100, 230);
    final actualResting = restingHr.clamp(35, actualMax - 20);
    final hrr = actualMax - actualResting;

    return [
      HrZone(zoneNumber: 1, label: 'Zone 1 – Recovery',
          minBpm: actualResting, maxBpm: (actualResting + hrr * 0.60).round()),
      HrZone(zoneNumber: 2, label: 'Zone 2 – Aerobic Base',
          minBpm: (actualResting + hrr * 0.60).round(),
          maxBpm: (actualResting + hrr * 0.70).round()),
      HrZone(zoneNumber: 3, label: 'Zone 3 – Tempo',
          minBpm: (actualResting + hrr * 0.70).round(),
          maxBpm: (actualResting + hrr * 0.80).round()),
      HrZone(zoneNumber: 4, label: 'Zone 4 – Threshold',
          minBpm: (actualResting + hrr * 0.80).round(),
          maxBpm: (actualResting + hrr * 0.90).round()),
      HrZone(zoneNumber: 5, label: 'Zone 5 – VO2max',
          minBpm: (actualResting + hrr * 0.90).round(), maxBpm: actualMax),
    ];
  }

  DateTime _startDate(List<RunActivity> activities) {
    final today = DateTime.now();
    final hasRunToday = activities.any((a) =>
        a.date.year == today.year &&
        a.date.month == today.month &&
        a.date.day == today.day);
    if (!hasRunToday) return today;
    return today.add(const Duration(days: 1));
  }

  String _planDescription(RunningStats stats) {
    final form = stats.formScore;
    if (form < -10) return 'You\'re currently fatigued. This week focuses on recovery with reduced volume and easy effort.';
    if (form > 10) return 'You\'re fresh and ready. This week includes a quality session to build fitness.';
    return 'Balanced week combining easy aerobic base, quality work, and a long run.';
  }
}
```

---

## 9. UI Screens

### 9.1 Screen List

| Screen | Route | Purpose |
|---|---|---|
| `SplashScreen` | `/` | Check auth, route accordingly |
| `LoginScreen` | `/login` | Strava OAuth trigger |
| `DashboardScreen` | `/dashboard` | Summary stats, quick insights |
| `AnalysisScreen` | `/analysis` | Charts, trends, zone breakdown |
| `PlanScreen` | `/plan` | Generated weekly plan |
| `PlanDayScreen` | `/plan/day` | Single day workout detail |
| `SettingsScreen` | `/settings` | HR max, preferences |

### 9.2 Dashboard Screen

```dart
// lib/presentation/screens/dashboard_screen.dart
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(runningStatsProvider);
    final activities = ref.watch(activitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Running'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(activitiesProvider.notifier).refresh(),
          ),
        ],
      ),
      body: activities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(message: e.toString()),
        data: (_) => stats == null
            ? const EmptyState()
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(activitiesProvider.notifier).refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FitnessFormCard(stats: stats),
                      const SizedBox(height: 16),
                      _StatsGrid(stats: stats),
                      const SizedBox(height: 16),
                      _RecentRunsList(),
                      const SizedBox(height: 16),
                      _QuickPlanCard(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _FitnessFormCard extends StatelessWidget {
  final RunningStats stats;

  const _FitnessFormCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final formColor = stats.formScore > 5
        ? Colors.green
        : stats.formScore < -5
            ? Colors.red
            : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Training Status',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MetricChip(
                    label: 'Fitness',
                    value: stats.fitnessScore.toStringAsFixed(0),
                    color: Colors.blue),
                _MetricChip(
                    label: 'Fatigue',
                    value: stats.fatigueSCore.toStringAsFixed(0),
                    color: Colors.red),
                _MetricChip(
                    label: 'Form',
                    value: stats.formScore.toStringAsFixed(0),
                    color: formColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 9.3 Plan Screen

```dart
// lib/presentation/screens/plan_screen.dart
class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(trainingPlanProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Training Plan')),
      body: plan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Could not generate your training plan.\n'
                'Make sure you\'re connected to Strava and have completed some runs.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (plan) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PlanHeader(plan: plan),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: plan.days.length,
                itemBuilder: (context, i) => _PlanDayCard(day: plan.days[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanDayCard extends StatelessWidget {
  final TrainingDay day;
  const _PlanDayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final isRest = day.type == WorkoutType.rest;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: typeColor(day.type).withOpacity(0.15),
          child: Icon(typeIcon(day.type), color: typeColor(day.type)),
        ),
        title: Row(
          children: [
            Text(_dayLabel(day.date),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            _WorkoutTypeBadge(type: day.type),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (!isRest && day.targetDistanceKm != null)
              day.warmUpCoolDownKm != null
                  ? Text(
                      'Walk ${day.warmUpCoolDownKm!.toStringAsFixed(1)} km + '
                      'Run ${(day.targetDistanceKm! - day.warmUpCoolDownKm!).toStringAsFixed(1)} km')
                  : Text('${day.targetDistanceKm!.toStringAsFixed(1)} km'),
            if (day.paceTarget != null)
              Text(
                '${_paceStr(day.paceTarget!.fastestPace)} – '
                '${_paceStr(day.paceTarget!.slowestPace)} /km',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            if (day.heartRateTarget != null)
              Text(
                  '♡ ${day.heartRateTarget!.minBpm}–${day.heartRateTarget!.maxBpm} bpm'),
            const SizedBox(height: 4),
            Text(day.description,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        trailing: isRest ? null : const Icon(Icons.chevron_right),
        onTap: isRest
            ? null
            : () => Navigator.pushNamed(context, '/plan/day',
                arguments: day),
      ),
    );
  }

  String _dayLabel(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _paceStr(Duration pace) {
    final m = pace.inSeconds ~/ 60;
    final s = pace.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

// Top-level helpers shared across plan widgets (no duplication)
Color typeColor(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => Colors.green,
    WorkoutType.tempo => Colors.orange,
    WorkoutType.intervals => Colors.red,
    WorkoutType.longRun => Colors.blue,
    WorkoutType.rest => Colors.grey,
    WorkoutType.crossTraining => Colors.purple,
  };
}

IconData typeIcon(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => Icons.directions_walk,
    WorkoutType.tempo => Icons.speed,
    WorkoutType.intervals => Icons.timer,
    WorkoutType.longRun => Icons.map,
    WorkoutType.rest => Icons.hotel,
    WorkoutType.crossTraining => Icons.fitness_center,
  };
}

String typeLabel(WorkoutType type) {
  return switch (type) {
    WorkoutType.easy => 'Easy',
    WorkoutType.tempo => 'Tempo',
    WorkoutType.intervals => 'Intervals',
    WorkoutType.longRun => 'Long Run',
    WorkoutType.rest => 'Rest',
    WorkoutType.crossTraining => 'Cross Train',
  };
}
```

---

## 10. Charts & Visualizations

Use `fl_chart` for all charts:

### 10.1 Pace Progression Chart

```dart
// lib/presentation/widgets/pace_chart.dart
class PaceProgressionChart extends StatelessWidget {
  final List<PaceDataPoint> dataPoints;
  const PaceProgressionChart({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) return const SizedBox.shrink();

    final spots = dataPoints.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.paceSecondsPerKm.toDouble());
    }).toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minY: spots.map((s) => s.y).reduce(min) - 30,
          maxY: spots.map((s) => s.y).reduce(max) + 30,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final mins = value.toInt() ~/ 60;
                  final secs = value.toInt() % 60;
                  return Text('$mins:${secs.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
```

### 10.2 Heart Rate Zone Pie Chart

```dart
// lib/presentation/widgets/hr_zone_chart.dart
class HrZoneDistributionChart extends StatelessWidget {
  final Map<int, double> zoneDistribution;
  const HrZoneDistributionChart({super.key, required this.zoneDistribution});

  static const zoneColors = [
    Colors.grey,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  @override
  Widget build(BuildContext context) {
    final sections = zoneDistribution.entries.map((e) {
      final zoneIndex = e.key - 1;
      return PieChartSectionData(
        value: e.value * 100,
        color: zoneColors[zoneIndex],
        title: 'Z${e.key}\n${(e.value * 100).toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
        radius: 60,
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 30,
        ),
      ),
    );
  }
}
```

---

## 11. Local Storage & Caching

Cache fetched activities locally with `hive_flutter` to reduce API calls, enable offline viewing, and support cross-platform caching (including Flutter Web).

```dart
// lib/data/datasources/local_activity_datasource.dart
class LocalActivityDataSource {
  static const _activitiesBoxName = 'activities';
  static const _hrStreamsBoxName = 'hr_streams';

  Box? _activitiesBox;
  Box? _hrStreamsBox;

  Future<Box> get activitiesBox async {
    _activitiesBox ??= await Hive.openBox(_activitiesBoxName);
    return _activitiesBox!;
  }

  Future<void> saveActivities(List<ActivityModel> activities) async {
    try {
      final box = await activitiesBox;
      final Map<int, Map<String, dynamic>> entries = {};
      for (final activity in activities) {
        entries[activity.id] = {
          'id': activity.id,
          'data': jsonEncode(activity.toJson()),
          'synced_at': DateTime.now().millisecondsSinceEpoch,
        };
      }
      await box.putAll(entries);
    } catch (_) {}
  }

  Future<List<ActivityModel>?> getCachedActivities() async {
    try {
      final box = await activitiesBox;
      if (box.isEmpty) return null;

      final values = box.values.cast<Map>();
      final sortedList = values.toList()
        ..sort((a, b) {
          final idA = a['id'] as int;
          final idB = b['id'] as int;
          return idB.compareTo(idA);
        });

      // Invalidate cache after 1 hour
      final oldest = sortedList.last['synced_at'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - oldest;
      if (age > 3600 * 1000) return null;

      return sortedList
          .map((r) => ActivityModel.fromJson(jsonDecode(r['data'] as String)))
          .toList();
    } catch (_) {
      return null;
    }
  }
}
```

---

## 12. Testing Strategy

### 12.1 Unit Tests — Analysis Engine

```dart
// test/domain/analyze_runs_usecase_test.dart
void main() {
  group('AnalyzeRunsUseCase', () {
    late AnalyzeRunsUseCase useCase;

    setUp(() => useCase = AnalyzeRunsUseCase());

    test('returns empty stats for empty list', () {
      final result = useCase.compute([]);
      expect(result.totalRuns, 0);
    });

    test('correctly computes average pace', () {
      final activities = [
        _mockRun(paceSec: 300), // 5:00 /km
        _mockRun(paceSec: 360), // 6:00 /km
      ];
      final result = useCase.compute(activities);
      expect(result.averagePace.inSeconds, 330); // 5:30 /km
    });

    test('form is positive when fitness > fatigue', () {
      // Simulate a rested athlete with strong fitness base
      final activities = List.generate(
          20, (i) => _mockRun(paceSec: 300, dayOffset: -(i * 3)));
      final result = useCase.compute(activities);
      expect(result.formScore, greaterThan(0));
    });
  });
}

RunActivity _mockRun({required int paceSec, int dayOffset = 0}) {
  return RunActivity(
    id: DateTime.now().millisecondsSinceEpoch,
    name: 'Test Run',
    date: DateTime.now().add(Duration(days: dayOffset)),
    distanceKm: 10,
    movingTime: const Duration(minutes: 50),
    pace: Duration(seconds: paceSec),
    elevationGainM: 50,
    trainingLoad: TrainingLoad.moderate,
  );
}
```

### 12.2 Widget Tests

```dart
// test/presentation/plan_day_card_test.dart
void main() {
  testWidgets('PlanDayCard shows rest on rest day', (tester) async {
    final day = TrainingDay(
      date: DateTime.now(),
      type: WorkoutType.rest,
      description: 'Full rest day.',
    );
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: _PlanDayCard(day: day))));
    expect(find.text('Full rest day.'), findsOneWidget);
    expect(find.byIcon(Icons.hotel), findsOneWidget);
  });
}
```

---

## 13. Recommended Packages

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter

  # Networking & Auth
  http: ^1.2.0
  flutter_web_auth_2: ^3.1.0
  flutter_secure_storage: ^9.0.0

  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # Data & Serialization
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

  # Local Storage
  hive_flutter: ^1.1.0   # for platform-agnostic key-value data & caching

  # Charts
  fl_chart: ^0.67.0

  # Navigation
  go_router: ^13.0.0

  # Utils
  intl: ^0.19.0           # date/number formatting
  equatable: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
  mockito: ^5.4.0
  flutter_lints: ^3.0.0
```

---

## 14. Deployment Checklist

### Before Release

- [ ] All `--dart-define` secrets set in CI/CD (GitHub Actions / Bitrise / Codemagic)
- [ ] Strava API app: add both debug and release redirect URIs
- [ ] Android: set `minSdkVersion 21` in `build.gradle`
- [ ] iOS: set `Minimum Deployments` to iOS 13+
- [ ] Handle Strava rate limits: 100 requests/15 min, 1000/day — implement retry with backoff
- [ ] Enable ProGuard/R8 for Android release build
- [ ] Test OAuth flow on physical device (not just simulator)
- [ ] Add analytics (e.g., Firebase) to track `plan_generated`, `sync_completed` events
- [ ] Accessibility: ensure all charts have semantic labels

### Strava API Rate Limit Strategy

```dart
// lib/core/network/rate_limiter.dart
class RateLimiter {
  final _requestTimes = <DateTime>[];
  static const maxPer15Min = 95; // leave 5 as buffer

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
```

---

## Quick Start Summary

1. **Register** your app on Strava Developers and get `CLIENT_ID` + `CLIENT_SECRET`
2. **Configure** deep link scheme on both platforms (Android `intent-filter`, iOS `CFBundleURLSchemes`)
3. **Run** `flutter pub get` and `flutter pub run build_runner build`
4. **Implement** auth flow → fetch activities → run analysis → generate plan
5. **Test** OAuth on a physical device before anything else — simulator behavior differs
6. **Cache** locally from day one — Strava's API has strict daily rate limits

---

*Built with Flutter 3.13+ · Riverpod 2 · Strava API v3*
