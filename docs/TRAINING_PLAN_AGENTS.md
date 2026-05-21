# Training Plan Architecture

## User Segmentation

3 segments: Beginner (<15 runs), Intermediate (15-49), Advanced (50+ runs & 50+ km/wk). Determines workout types, volume, periodization.

Ref: `GeneratePlanUseCase`, `DynamicWorkoutSequenceStrategy`

## Beginner Protocol (totalRuns < 15)

No tempo or interval workouts — hard-locked at `WorkoutSequenceStrategy`.

Walk/run ratios: Phase 1 (runs 1-4): 1min run / 2min walk; Phase 2 (5-9): 2/1; Phase 3 (10-14): 4/1; Phase 4 (15+): continuous.

Max 3 running days/week; `minEasyRunMinutes = 10`; `weeklyMinTarget = 45`.

Ref: `RunWalkPhase.fromTotalRuns()`

## Returning Runner Protocol

Gap categories: short (3-6d), long (7-13d), injury (14-29d), extended (≥30d).

Gap >90 days old → treated as extended (beginner reset).

Ramp schedule by category, start at 55-85% pre-gap volume. Ramp weeks: 1 (short) to 3 (injury); week-over-week cap = 10%.

Mid-ramp interruption: restart ramp if gap >7 days within ramp window.

Ref: `ReturnContext`, `detectReturnContext()`, `_returnRampSequence()`

## Periodization (Advanced only)

4-week cycle: Build 1 (90% vol), Build 2 (100%), Build 3 (110%), Deload (50%).

Deload: forced, no skip; easy only + 50% long run at Zone 1.

Long run: linear +10% per build week.

Intervals: 5×1km (B1) → 8×600m (B2) → 12×400m (B3) → none (deload).

Cycle boundary relative to `cycleStartDate` (persisted), not calendar-aligned.

## Volume Calculation Priority

1. Extended return → beginner target (45 min/wk)
2. Active return ramp → fraction of pre-gap volume (55-85%)
3. Periodized advanced build/deload → cycle-adjusted
4. Normal → form-based (fatigued 80%, slightly fatigued 95%, fresh 110%)

Max week-over-week increase: 15% regardless of form score.

## Week-in-Cycle State Management

`weekInCycleProvider` (Riverpod `StateNotifier`) persisted to `PreferencesStorage`.

Incremented when `now - cycleStartDate >= 7 days`. Resets to 0 after deload (week 3 → 0 = new cycle).

Ref: `WeekInCycleNotifier` in `activities_provider.dart`
