# Palette's Journal

## 2026-05-24 - [Accessible Icon Buttons]
Learning: In Flutter, `IconButton` widgets without text labels are completely invisible to screen readers unless they are wrapped in `Semantics` or provided a `tooltip` property. Using the `tooltip` property is a quick, built-in way to add both a visual hover hint and a semantic label for TalkBack/VoiceOver simultaneously.
Action: Added `tooltip` properties to icon-only app bar actions and close buttons across `DashboardScreen`, `AnalysisScreen`, `PlanScreen`, and `RunSessionScreen` to ensure these critical actions are identifiable by assistive technologies.

## 2026-05-24 - [Premium Unified Color Accents & Refactoring]
Learning: Consolidating styling helpers across screens ensures visual consistency and prevents accidental color drift. Using unified semantic color tokens (like AppColors) rather than hardcoded Material colors makes the application look cohesive and premium, meeting our brand guidelines.
Action: 
- Consolidated private and duplicated workout type widgets and helpers in `PlanScreen` to import and reuse `WorkoutTypeBadge` and its unified helper functions.
- Updated `WorkoutTypeBadge` to use premium design system colors from `AppColors` rather than basic Material colors (e.g. `Colors.green`, `Colors.orange`, etc.).
- Refactored `StatsGrid` on the Analysis screen to use semantic brand and sport colors (`AppColors.run`, `AppColors.success`, `AppColors.warning`, `AppColors.pr`) instead of generic blue, green, orange, and purple.
- Harmonized run session timer phase coloring (including recovery phase color cleanup in `RunSessionScreen` and `RunTimerDisplay`) to use the centralized `AppColors` tokens for better brand alignment.
- Harmonized heart rate zones preview in `SettingsScreen` with semantic colors from `AppColors` (`AppColors.info`, `AppColors.success`, `AppColors.warning`, `AppColors.brandOrange`, `AppColors.danger`) instead of basic Material colors.
- Upgraded `ZonesPreviewCard` to dynamically color-code each training zone's bpm range text with its matching color token rather than using a hardcoded brand orange, yielding a highly scannable, sports-pro dashboard aesthetic.

## 2026-05-24 - [Interactive Kudos Button & Dark Mode Visual Polish]
Learning: Designing micro-interactions that feel "alive" requires combining visual, motion, and tactile feedback. Bouncy scale animations, floating counters, and haptics turn a static interface into a high-fidelity experience. Additionally, dark mode designs must use theme-aware border and disabled state colors to avoid high-contrast white border visual bugs.
Action:
- **Interactive Kudos Button**: Implemented a stateful `KudosButton` widget with light haptic feedback, a spring-based scale pop animation (1.0 -> 0.85 -> 1.15 -> 1.0), and a floating `+1` vertical translation animation. Integrated it into `CompactActivityCard` in the recent activities feed with mock initial counts.
- **Dark Mode Card Border Fixes**: Updated `_PlanDayCard` and all Settings screen cards (`HeartRateCard`, `ZonesPreviewCard`, `DisconnectStravaCard`, `AboutCard`) to use dynamic theme-aware border colors (`AppColors.surfaceTertiaryDark` in dark mode) instead of a hardcoded bright light-gray (`AppColors.gray200`).
- **Dark Mode SettingsSaveButton Fix**: Programmed dynamic disabled background (`AppColors.surfaceTertiaryDark`) and text (`AppColors.textTertiaryDark`) colors to replace hardcoded light-gray styling when the save changes button is disabled.
- **Pace Formatting & Spacing Polish**: Appended ` /km` to `Avg Pace` in `StatsGrid` for design system compliance. Harmonized margins and added scroll bottom-padding to the Settings screen to eliminate layout gaps.

## 2026-05-24 - [Tactile Haptics, Interactive Landing, & Staggered Dashboard Animations]
Learning: Delivering a premier athlete UX requires orchestrating motion, feedback, and structure into a seamless flow. Using entrance physics on loading/login screens creates a powerful first impression, while tactile haptic responses validate navigational intent physically. Additionally, applying staggered page entries makes large content views feel lighter and dynamically constructed as they render in front of the athlete.
Action:
- **Interactive Landing & Onboarding Polish**: Redesigned `LoginScreen` with beautiful landing animations (logo pop, staggered fade-and-slide entry for headlines and description text, and a smooth slide-in for the CTAs). Added a dynamic shake physics sequence on the login error container and custom `AppColors.brandOrange` styling with responsive layout padding.
- **Tactile Haptic Feedback (Physical UX Delight)**: Integrated high-fidelity tactile feedback using `HapticFeedback.lightImpact()` (and medium impact for high-weight actions like Strava connections) across workout start interaction points (both the card click and "Start Workout" button on the `TodayWorkoutCard`) as well as the calendar day selections on the `PlanScreen`.
- **Staggered Dashboard Entrance**: Enhanced the feed layout in `DashboardScreen` to use staggered fade and slide animations (`.animate(interval: 80.ms)`) as cards render, harmonizing its entrance behavior with the premium visual aesthetics of the `AnalysisScreen`.

## 2026-05-24 - [Interactive Play/Pause Haptic Warning & Control Tooltips]
Learning: Preventing accidental action triggers during high-intensity sports (like running) is key for athlete UX. When using high-intent mechanics (like long-press hold to pause), providing a tap-action feedback warning (via haptics and manual tooltip visibility) prevents the UI from feeling broken or unresponsive. Furthermore, wrapping all secondary icon-only buttons in explicit tooltips completes their accessibility profile for screen readers and cursor hovers.
Action:
- **Play/Pause Tap Haptic & Visual Warning**: Upgraded the Play/Pause button in `RunControls` to trigger a medium haptic impact and programmatically reveal a manual 'Hold to Pause' Tooltip when the athlete accidentally quick-taps it while the run session is active.
- **Control Tooltips**: Integrated dynamic and semantic tooltips ('Unlock Screen' / 'Lock Screen' and 'Mute Coach' / 'Unmute Coach') to the lock and audio controls in `RunControls`, ensuring complete clarity and assistive compatibility.

