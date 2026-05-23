# Palette's Journal

## 2026-05-24 - [Accessible Icon Buttons]
Learning: In Flutter, `IconButton` widgets without text labels are completely invisible to screen readers unless they are wrapped in `Semantics` or provided a `tooltip` property. Using the `tooltip` property is a quick, built-in way to add both a visual hover hint and a semantic label for TalkBack/VoiceOver simultaneously.
Action: Added `tooltip` properties to icon-only app bar actions and close buttons across `DashboardScreen`, `AnalysisScreen`, `PlanScreen`, and `RunSessionScreen` to ensure these critical actions are identifiable by assistive technologies.
