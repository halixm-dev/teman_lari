# AGENTS.md

## Tooling

- Codegen: `dart run build_runner build --delete-conflicting-outputs`
- Lint: `flutter analyze`

## Non-Obvious Rules

- `invalid_annotation_target: ignore` in `analysis_options.yaml` — required for freezed/riverpod generators
- Web build requires Strava env vars passed via `--dart-define`: `STRAVA_CLIENT_ID`, `STRAVA_CLIENT_SECRET`, `STRAVA_REDIRECT_URI`, `STRAVA_ACCESS_TOKEN`, `STRAVA_REFRESH_TOKEN` (see `build.sh`)

## Project-Specific Patterns

- Design tokens in `DESIGN.md` — refer there, don't duplicate
- File naming: `*_model.dart`, `*_entity.dart`, `*_datasource.dart`; generated: `.g.dart`, `.freezed.dart`

## Training Plan Architecture (Design Decisions)

### User Segmentation
- 3 segments: Beginner (<15 runs), Intermediate (15-49), Advanced (50+ runs & 50+ km/wk)
- Segmentation determines workout types, volume, and periodization
- Ref: `GeneratePlanUseCase`, `DynamicWorkoutSequenceStrategy`

### Beginner Protocol (totalRuns < 15)
- No tempo or interval workouts — hard-locked at strategy level (`WorkoutSequenceStrategy`)
- Walk/run ratios: Phase 1 (runs 1-4): 1min run / 2min walk; Phase 2 (5-9): 2/1; Phase 3 (10-14): 4/1; Phase 4 (15+): continuous
- Max 3 running days per week; `minEasyRunMinutes = 10`; `weeklyMinTarget = 45`
- Ref: `RunWalkPhase.fromTotalRuns()`

### Returning Runner Protocol
- Gap categories: short (3-6d), long (7-13d), injury (14-29d), extended (≥30d)
- Pre-gap data >90 days old → treated as extended (beginner reset)
- Ramp schedule: varies by category, start at 55-85% pre-gap volume
- Ramp weeks: 1 (short) to 3 (injury); week-over-week cap = 10%
- Mid-ramp interruption: restart ramp if gap >7 days within ramp window
- Ref: `ReturnContext`, `detectReturnContext()`, `_returnRampSequence()`

### Periodization (Advanced only)
- 4-week cycle: Build 1 (90% vol), Build 2 (100%), Build 3 (110%), Deload (50%)
- Deload: forced, no skip; easy only + 50% long run at Zone 1
- Long run: linear +10% per build week
- Intervals: 5×1km (build 1) → 8×600m (build 2) → 12×400m (build 3) → none (deload)
- Cycle boundary: relative to `cycleStartDate` (persisted), not calendar-aligned

### Volume Calculation Priority
1. Extended return → beginner volume target (45 min/wk)
2. Active return ramp → fraction of pre-gap volume (55-85%)
3. Periodized advanced build/deload → cycle-adjusted
4. Normal → form-based (fatigued 80%, slightly fatigued 95%, fresh 110%)
- Max week-over-week increase: 15% regardless of form score

### Week-in-Cycle State Management
- `weekInCycleProvider` (Riverpod `StateNotifier`) persisted to `PreferencesStorage`
- Incremented when `now - cycleStartDate >= 7 days`
- Resets to 0 after deload (week 3 → 0 = new cycle)
- Ref: `WeekInCycleNotifier` in `activities_provider.dart`
