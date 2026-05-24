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

## 2026-05-24 - [Double-Tap to Kudos Social Micro-Interaction]
Learning: Designing delightful social platforms requires rewarding natural, intuitive behaviors with visual feedback. The "double-tap to like" (or kudos) pattern pioneered by popular social networks can be beautifully translated to an athlete's feed. Implementing an elastic thumbs-up icon burst overlay with medium haptic feedback makes the feed feel responsive, high-fidelity, and celebratory.
Action:
- **Stateful Activity Cards**: Converted `CompactActivityCard` from a `StatelessWidget` to a `StatefulWidget` to maintain local double-tap animation state and support key-based interaction.
- **Double-Tap Gesture Detector**: Wrapped `CompactActivityCard` in a `GestureDetector` that intercepts `onDoubleTap`, triggering a medium haptic impact and programmatically firing `externalKudos()` on the child `KudosButtonState` using a `GlobalKey`.
- **Elastic Thumbs-Up Burst Overlay**: Programmed a beautiful, orange thumbs-up icon overlay using `flutter_animate` that springs into view with elastic scale physics (`Curves.elasticOut`) and fades away smoothly when an athlete double-taps anywhere on the activity card.

## 2026-05-24 - [Tactile Bottom Sheets, Shimmer Success, & VO2 Max Range Visuals]
Learning: Replacing default system alert dialogs with highly tailored modal bottom sheets significantly improves phone-friendly, single-handed ergonomics. Combining these sheets with micro-animations (like staggered fade-ins and scale entries) and tactile haptics (varying by action severity: light for options, medium for warnings, heavy for destructive commands) forms an elegant, elite-grade athletic design signature. Furthermore, adding spring scale-ups followed by shimmer swipe effects on button success states converts an ordinary configuration save into a small moment of victory and reassurance.
Action:
- **Redesigned Plan & Analysis Sheets**: Elevated the training info sheet in `PlanScreen` and the data period sheet in `AnalysisScreen` from basic text popups to highly polished modal bottom sheets with drag handles, brand accent icon badges, bold structured typography, and clear "Got it" buttons. Integrated `flutter_animate` for staggered fade and slide entries, and light haptics on opens/closes.
- **Warning-Aware Disconnect Sheet**: Transformed the basic Strava disconnect dialog in `SettingsScreen` into a warning bottom sheet with danger semantic styling (`AppColors.danger`), caution highlights on lost analytics/plan calibrations, a medium haptic warning on open, and a heavy haptic trigger on confirmation execution.
- **Shimmering Settings Save**: Upgraded the save success state in `SettingsSaveButton` with a spring scale-up and a white shimmering shine sweep. Connected a satisfying medium haptic impact trigger inside `SettingsScreen` when settings are committed successfully.
- **Haptic Stats Grid & High-Fidelity VO2 Max Sheet**: Added tactile light haptics on taps to any interactive stat card in the `StatsGrid`. Completely overhauled the VO2 Max estimation sheet with an outstanding summary card, colored category status pills (Excellent, Good, Fair, Needs Work), dynamic ranges (with color-coded dots), and spring-loaded animations.

## 2026-05-24 - [Premium Settings Refresh: Cascading Staircase Zones & High-Fidelity Custom About Cards]
Learning: A premium athlete dashboard must carry visual delight all the way into utility views like settings. Static text and generic list tiles should be replaced with custom, micro-animated widgets that offer visual context and complete access safety. Physiological progression, such as heart rate zones, becomes instantly understandable when presented as an ascending, intensity-scaled cascading staircase that animates into view. Additionally, embedding rich details like real-time connection status indicators, local sandbox data security labels, and interactive modal-based policies with physical haptics transforms utility pages into a memorable extension of the brand experience.
Action:
- **Cascading Staircase Zones**: Redesigned `ZonesPreviewCard` to render dynamic intensity-scaled progress bars (from 20% to 100% width factor) matching Zone 1 to Zone 5 physiological load levels. Added a cascading entrance build animation (`flutter_animate` staggered horizontal scale-out) that plays beautifully upon rendering.
- **High-Fidelity Custom About Card**: Completely replaced `AboutCard` with a premium sports-brand design featuring a spring-scaling run icon, structured code and secure-data labels, active connection status indicators (with success green dots), and interactive text-links with hover highlights.
- **Local Policy Sheets**: Wired the "Privacy Policy" and "Terms of Service" links to launch customized modal bottom sheets with smooth entrances, satisfying tactile haptics, and concise local sandbox descriptions.
- **Accessible Disconnect Tile**: Upgraded `DisconnectStravaCard` with semantic button wrappers, screen-reader accessibility hints, custom spacing, a themed red logout container (`AppColors.danger`), and trailing navigation indicators.


