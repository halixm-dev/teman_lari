# Training Plan Architecture

As an expert running coach and product manager, this architecture balances rigorous exercise physiology (TSS, Load, Form) with practical app constraints to deliver dynamic, personalized, and safe training plans.

## Core Training Metrics & Physiology

To safely progress runners and prevent injury, the system quantifies workout stress and tracks cumulative fatigue using industry-standard physiological models.

### 1. Thresholds (Pace & Heart Rate)
Thresholds anchor all intensity zones and load calculations.
- **Functional Threshold Pace (FTPa):** The fastest pace a runner can sustain for 60 minutes.
- **Lactate Threshold Heart Rate (LTHR):** The heart rate corresponding to the anaerobic threshold.
- **Estimation Method:** Calculated via user onboarding input (e.g., recent 5K time), an explicit 20-minute field test, or auto-detected from peak historical efforts in the app.
- **Implementation:** Used to establish the 5-zone model (Z1 Recovery, Z2 Aerobic, Z3 Tempo, Z4 Threshold, Z5 VO2Max).

### 2. Training Stress Score (TSS) & Intensity Factor (IF)
Every completed run generates a TSS, which quantifies the physiological toll of the session.
- **Intensity Factor (IF):** Measures how hard a workout was relative to threshold. 
  - **Pace Formula:** `IF = Threshold Pace (sec/km) / Normalized Graded Pace (sec/km)`
  - **HR Formula:** `IF = Average HR / LTHR`
- **TSS Formula:** `TSS = (Duration in seconds × IF² × 100) / 3600`
- **Session Guidelines:**
  - **< 50 TSS:** Easy / Recovery Run
  - **50 - 100 TSS:** Medium (Base aerobic / Daily volume)
  - **100 - 150 TSS:** High (Long run or tough interval session)
  - **> 150 TSS:** Epic (Race day or extreme long runs)

### 3. Training Load (Fitness, Fatigue, Form)
We track daily TSS over time to model the runner's state using a Banister-style Impulse-Response model.
- **Chronic Training Load (CTL - Fitness):** A 42-day Exponentially Weighted Moving Average (EWMA) of TSS. Represents the runner's baseline fitness and long-term adaptations.
  - **Formula:** `CTL_today = CTL_yesterday + (TSS_today - CTL_yesterday) × (1 - e^(-1/42))`
  - *(Simplified standard TrainingPeaks constant is often computed as `k = 1/42` instead of `1 - e^(-1/42)`)*
- **Acute Training Load (ATL - Fatigue):** A 7-day EWMA of TSS. Represents short-term cumulative fatigue.
  - **Formula:** `ATL_today = ATL_yesterday + (TSS_today - ATL_yesterday) × (1 - e^(-1/7))`
  - *(Simplified constant `k = 1/7`)*
- **Training Stress Balance (TSB - Form):** 
  - **Formula:** `TSB_today = CTL_yesterday - ATL_yesterday`
  - *Fresh (`TSB > +5`):* Ready for a race, time trial, or heavy peak block.
  - *Optimal (`-10 to +5`):* Productive, sustainable training block.
  - *Tired (`-15 to -10`):* Accumulating fatigue, scaling back volume (0.90x).
  - *Fatigued (`-20 to -15`):* High fatigue, cutting back volume (0.85x) and limiting intensity.
  - *Overtrained / Danger (`TSB < -20`):* The plan engine automatically triggers a deload or mandates rest days.

### 4. Acute-to-Chronic Workload Ratio (ACWR)
A primary injury-prevention metric used alongside the Form score, heavily favored for newer runners whose CTL might be non-existent or unreliable.
- **Formula:** `ACWR = Sum(TSS past 7 days) / (Sum(TSS past 28 days) / 4)`
- **Application:** The plan generator targets a "Sweet Spot" of `0.8 - 1.3`. It acts as the highest priority ceiling constraint before applying any other rules.

### 5. Polarized Training (80/20 Rule)
- 80% of the weekly time (or TSS) is allocated to Low Intensity (Z1/Z2).
- 20% is allocated to Moderate/High Intensity (Z3+).
- **Rule:** Strict enforcement for Intermediate and Advanced users. Beginners remain at 100% Low Intensity.

---

## User Segmentation

3 segments: Beginner (<15 runs), Intermediate (15-49), Advanced (50+ runs & 50+ km/wk). Determines workout types, volume, periodization.

Ref: `GeneratePlanUseCase`, `DynamicWorkoutSequenceStrategy`

## Beginner Protocol (totalRuns < 15)

No tempo or interval workouts — hard-locked at `WorkoutSequenceStrategy` to Z1/Z2 only.

Walk/run ratios use time-gates alongside run counts: Phase 1 (runs 1-4): 1min run / 2min walk; Phase 2 (5-9 & >2 wks): 2/1; Phase 3 (10-14 & >4 wks): 4/1; Phase 4 (15+ & >6 wks): continuous.

Max 3 running days/week; `minEasyRunMinutes = 10`; `weeklyMinTarget = 45`.

Ref: `RunWalkPhase.fromTotalRuns()`

## Returning Runner Protocol

Gap categories: short (3-6d), long (7-13d), injury (14-29d), extended (≥30d).

Gap >90 days old → treated as extended (beginner reset).

Pre-gap baseline uses a 4-week median, excluding outliers (values outside 50%-150% of the prior 8-week median) for stability.
Ramp schedule by category, start at 55-85% pre-gap volume. Ramp weeks: 1 (short) to 3 (injury); week-over-week cap = 10%.

Mid-ramp interruption: restart ramp if gap >7 days within ramp window.

Ref: `ReturnContextDetector`, `_returnRampSequence()`

## Periodization & Cycles

**Intermediate (3-week cycle):** Week A (Base 100%), Week B (Build 105%), Week C (Recover 80%).
**Advanced (4-week cycle):** Build 1 (90% vol), Build 2 (100%), Build 3 (110%), Deload (50%).
**Transition:** Dedicated recovery phase limiting athletes to 3 days/week with easy runs and rest only.

Deload: forced, no skip; easy only + 50% long run at Zone 1.

Long run: linear +10% per build week.

Intervals: 5×1km (B1) → 8×600m (B2) → 12×400m (B3) → none (deload).

Cycle boundary relative to `cycleStartDate` (persisted), not calendar-aligned.

## Weekly Plan Generation Algorithm

The plan generator executes a deterministic sequence each week to establish the targeted load and distribute it across workouts.

### Step 1: Establish Base Volume Target (Duration or TSS)
The engine determines the baseline target for the upcoming week based on priority:
1. **Extended Return:** Defaults to beginner baseline (45 min/wk).
2. **Active Return Ramp:** Applies a fraction to the pre-gap volume (55-85% depending on gap length).
3. **Periodized Cycle:** Applies cycle multiplier (e.g. Build 110%, Deload 50%) based on the phase (Intermediate or Advanced).
4. **Normal Progression:** Uses Form (TSB) to scale recent average volume:
   - Fresh (TSB > +5): `Target = Last Week × 1.10`
   - Optimal (TSB -10 to +5): `Target = Last Week × 1.05`
   - Tired (TSB -15 to -10): `Target = Last Week × 0.90`
   - Fatigued (TSB -20 to -15): `Target = Last Week × 0.85`
   - Danger (TSB < -20): `Target = Last Week × 0.50`

### Step 2: Enforce Strict Constraint Hierarchy
Physical constraints are applied top-down:
1. **ACWR Cap:** Target is clamped to ensure ACWR `≤ 1.3` (highest priority).
2. **Weekly Volume Cap:** Hard cap at `+15%` above the recent weekly average, applied to the ACWR-clamped target.
3. **Long Run Cap:** The long run is capped at `+10%` over the longest recent run length, evaluated after the weekly total is set.
4. **Long Run Allocation:** Distributes 25-35% of the *final, clamped weekly volume* to the long run, recalculated last to guarantee it stays in bounds.

### Step 3: Distribute Workouts (80/20 & Periodization Rules)
The total weekly target is divided into specific sessions:
1. **Long Run:** Assigned based on the Allocation and Cap constraints from Step 2.
2. **Quality Session (Interval/Tempo):** (Intermediate/Advanced only). Allocated up to 20% of the weekly TSS. Workouts are selected based on the periodization block.
3. **Base/Recovery Runs:** The remaining weekly volume is evenly distributed across 2-4 easy aerobic runs. If TSB is highly negative (`< -15`), these are forced to strict Zone 1 Recovery.

## Week-in-Cycle State Management

`weekInCycleProvider` (Riverpod `StateNotifier`) persisted to `PreferencesStorage`.

Derived idempotently from the difference between `DateTime.now()` and `cycleStartDate` (`daysSinceStart ~/ 7`). 
Resets and handles phase cycles seamlessly without side-effect iterations.

Ref: `WeekInCycleNotifier` in `activities_provider.dart`
