# Teman Lari Design System

A design language inspired by real movement — built for runners, powered by data, shaped by community.

---

## Brand Identity

**Mission**: Teman Lari is a Strava-integrated running companion app designed to connect runners to what motivates them — from 0 km beginners to advanced marathoners. We help you analyze runs, track fitness metrics, generate customized training plans based on your fitness level and goals, and track live sessions with GPS and real-time pace feedback.

**Personality**:
- **Energetic** — Movement, momentum, forward drive
- **Data-driven** — Precision metrics, honest performance tracking, and live GPS pace feedback
- **Motivating** — Celebrate every effort, providing customized training plans for everyone from 0 km runners to advanced athletes

**Voice**: Direct, action-oriented, celebratory. Uses active verbs. Numbers are heroes.

---

## Color System

Implemented in Flutter as a static `AppColors` class.

### Primary Palette

| Token | Hex | Usage |
|---|---|---|
| `AppColors.brandOrange` | `0xFFFC4C02` | Primary CTA, achievements, PR badges |
| `AppColors.brandOrangeDark` | `0xFFE03D00` | Pressed states |
| `AppColors.brandOrangeLight` | `0xFFFF7A45` | Gradients, soft accents |
| `AppColors.brandOrangeTint` | `0xFFFFF0EB` | Backgrounds on orange-related content |

### Neutral Palette

| Token | Hex | Usage |
|---|---|---|
| `AppColors.gray900` | `0xFF1A1A1A` | Primary text, headings |
| `AppColors.gray700` | `0xFF3D3D3D` | Secondary body text |
| `AppColors.gray500` | `0xFF707070` | Muted labels, metadata |
| `AppColors.gray300` | `0xFFB0B0B0` | Disabled states, dividers |
| `AppColors.gray100` | `0xFFF5F5F5` | Surface backgrounds |
| `AppColors.gray50` | `0xFFFAFAFA` | Page background |
| `AppColors.white` | `0xFFFFFFFF` | Cards, modals |

### Semantic Colors

| Token | Hex | Meaning |
|---|---|---|
| `AppColors.pr` | `0xFF8B5CF6` | Personal records |
| `AppColors.kom` | `0xFFFFD700` | KOM / QOM trophies |
| `AppColors.run` | `0xFFFC4C02` | Running sport type |
| `AppColors.success` | `0xFF22C55E` | Completion, positive delta |
| `AppColors.warning` | `0xFFF59E0B` | Moderate alerts |
| `AppColors.danger` | `0xFFEF4444` | Errors, missed goals |

### Dark Mode

Dark mode uses deep charcoal surfaces, not pure black.

| Token | Hex |
|---|---|
| `AppColors.surfacePrimaryDark` | `0xFF1C1C1E` |
| `AppColors.surfaceSecondaryDark` | `0xFF2C2C2E` |
| `AppColors.surfaceTertiaryDark` | `0xFF3A3A3C` |
| `AppColors.textPrimaryDark` | `0xFFF2F2F7` |
| `AppColors.textSecondaryDark` | `0xFFAEAEB2` |
| `AppColors.textTertiaryDark` | `0xFF636366` |
| `AppColors.dividerDark` | `0xFF38383A` |

---

## Typography

### Font Families

Implemented using `GoogleFonts` or local assets in Flutter.
- **Primary**: `Figtree` or `Inter` (used for all UI, headings, stats)
- **Monospace**: `JetBrains Mono` or `Fira Code` (used for pace, split data)

### Type Scale (AppTextStyles)

| Role | Size | Weight | Height | Usage |
|---|---|---|---|---|
| `displayXl` | 48.0 | `w800` | 1.1 | Hero numbers (distance, time) |
| `displayLg` | 36.0 | `w700` | 1.15 | Activity title |
| `displayMd` | 28.0 | `w700` | 1.2 | Section heroes |
| `headingLg` | 22.0 | `w600` | 1.3 | Card headings |
| `headingMd` | 18.0 | `w600` | 1.35 | Sub-headings |
| `headingSm` | 15.0 | `w600` | 1.4 | Labels, tabs |
| `bodyLg` | 16.0 | `w400` | 1.6 | Primary body |
| `bodyMd` | 14.0 | `w400` | 1.55 | Secondary content |
| `bodySm` | 13.0 | `w400` | 1.5 | Metadata, timestamps |
| `caption` | 11.0 | `w500` | 1.4 | Chart labels, badges |
| `statHero` | 42.0 | `w800` | 1.0 | Key metrics (pace, HR) |
| `statUnit` | 16.0 | `w500` | 1.0 | Units alongside stat heroes |

### Typography Rules

- Stats and performance numbers use monospace fonts for tabular alignment
- Pace format: always `MM:SS /km` or `MM:SS /mi`, monospaced
- Large numbers animate in on page load with a count-up
- PR (personal record) values are always styled in `AppColors.pr`
- Never use body text smaller than 11px

---

## Spacing System

Based on a 4.0 base unit. Implemented as constants (e.g., `AppSpacing.s16`) or `SizedBox` extensions.

| Token | Value | Usage |
|---|---|---|
| `AppSpacing.s4` | 4.0 | Icon gaps, tight metadata |
| `AppSpacing.s8` | 8.0 | Inner component padding |
| `AppSpacing.s12` | 12.0 | Between related elements |
| `AppSpacing.s16` | 16.0 | Standard card padding |
| `AppSpacing.s20` | 20.0 | Between sections within a card |
| `AppSpacing.s24` | 24.0 | Card margins, list item spacing |
| `AppSpacing.s32` | 32.0 | Section gaps |
| `AppSpacing.s40` | 40.0 | Large section separators |
| `AppSpacing.s48` | 48.0 | Page-level top padding |
| `AppSpacing.s64` | 64.0 | Hero section vertical rhythm |

---

## Border Radius

| Token | Value | Usage |
|---|---|---|
| `AppRadius.sm` | 4.0 | Badges, chips, tags |
| `AppRadius.md` | 8.0 | Buttons, inputs, small cards |
| `AppRadius.lg` | 12.0 | Cards, activity tiles |
| `AppRadius.xl` | 16.0 | Bottom sheets, modals |
| `AppRadius.xxl` | 24.0 | Map overlays, prominent cards |
| `AppRadius.full` | 9999.0 | Avatars, pill buttons, sport icons |

---

## Elevation & Shadows

Minimal, purposeful shadows using Flutter's `BoxShadow`.

| Level | Token | Usage |
|---|---|---|
| 0 | None | Flat list items |
| 1 | `AppShadows.sm` | Segment cards, stat tiles |
| 2 | `AppShadows.md` | Activity feed cards |
| 3 | `AppShadows.lg` | Map overlays, dropdowns |
| 4 | `AppShadows.xl` | Modals, bottom sheets |

---

## Iconography

### Icon Library
Use `PhosphorIcons` or `Lucide` packages for Flutter.

| Style | Weight | Usage |
|---|---|---|
| Regular | 1.5px stroke | Navigation, UI controls |
| Bold | 2px stroke | Active states, emphasis |
| Fill | Solid | Sport type icons, achievement badges |

### Sport Icons

Focused exclusively on Running.

| Sport | Icon | Color |
|---|---|---|
| Run | `Icons.directions_run` | `AppColors.run` |

Sport icon containers are always `AppRadius.full` circles, 40×40px, with a 10% opacity tint of the sport color as background.

### Achievement Icons

| Badge | Visual | Trigger |
|---|---|---|
| PR | Lightning bolt, purple | Fastest segment or distance |
| KOM/QOM | Trophy, gold | Segment leader |
| Top 10 | Ribbon | Top 10 on any segment |
| Streak | Fire | Consecutive activity days |

---

## Components

### Activity Card

The core UI unit. Contains everything about a single run.

**Anatomy:**
1. **Header row** — Avatar (40px) + Athlete name + timestamp + sport icon
2. **Activity title** — `headingLg`, editable
3. **Map thumbnail** — 16:9 ratio, route trace in brand orange, dark map tiles
4. **Stats row** — 3 primary metrics (Distance / Pace / Time), arranged in a 3-column grid

**Behavior:**
- Cards support swipe-left to reveal quick actions

### Stat Tile

Used in activity detail views.

```text
┌────────────────────┐
│  5:34 /km          │ ← statHero, monospace
│  Avg Pace          │ ← caption, uppercase, muted
│  ▲ 0:08 vs last    │ ← delta indicator, green/red
└────────────────────┘
```

- Grid of 4–6 tiles on activity detail
- Tap any tile → expands to full chart of that metric over time
- PR values render with a purple ⚡ prefix

### Map Component

**Base layer options:**
- **Standard** — Muted gray-green, roads white/light gray
- **Satellite** — Full imagery with semi-transparent route overlay
- **Dark** — Charcoal map, high-contrast route trace

**Route trace:**
- Default: `AppColors.brandOrange`, 3.0 stroke, `StrokeCap.round`
- Gradient by pace: green (fast) → yellow → red (slow)
- Gradient by heart rate: zone-color segments

**Overlays:**
- Start: green filled circle, 10.0
- End: red filled circle, 10.0  
- Lap markers: vertical dashes with lap number

### Navigation

#### Mobile Bottom Tab Bar (NavigationBar)

```text
[Dashboard] [Analysis] [Plan] [Settings]
```

- **Implementation**: Uses Material 3 `NavigationBar` and `NavigationDestination`.
- **Primary Action**: "Record Run" is handled via a Floating Action Button (FAB) or a dedicated recording route (`/run-session`).
- **Active Tab**: Icon and label highlight to indicate the current section.
- **Responsive Adaptation**: On larger screens (tablets/desktop), this seamlessly transitions to a `NavigationRail` on the left side.

### Buttons

#### Hierarchy

| Variant | Background | Text | Border | Usage |
|---|---|---|---|---|
| Primary | `AppColors.brandOrange` | White | None | Record, Save activity |
| Secondary | White | `AppColors.brandOrange` | 2px orange | Edit, Share |
| Ghost | Transparent | `AppColors.gray700` | 1px gray | Cancel, Dismiss |
| Danger | `AppColors.danger` | White | None | Delete, Unfollow |
| Disabled | `AppColors.gray100` | `AppColors.gray300` | None | — |

**States:**
- Active/Press: Use Flutter's `SplashFactory` or scale down slightly (`0.97`) on tap down
- Loading: `CircularProgressIndicator` replaces label, button width locked

---

## Motion & Animation

### Principles

- **Physics-based**: Use Flutter's `SpringSimulation` or `Curves.easeOutBack`
- **Purposeful**: Every animation conveys state or direction
- **Fast**: UI animations < 300ms. Celebrations up to 800ms.

### Easing Curves

- **Spring**: `Curves.elasticOut` or custom spring (bouncy, for PR)
- **Enter**: `Curves.easeOut` (Decelerate in)
- **Exit**: `Curves.easeIn` (Accelerate out)

---

## Accessibility

- All interactive elements: minimum 48×48px touch target (`IconButton` default)
- Color is never the only differentiator — icons or labels always accompany
- `Semantics` widget for screen readers:
  - PR / achievement indicators: include `label` describing the achievement
  - Map: double-tap/swipe gestures have button equivalents
- Contrast: all body text ≥ 4.5:1, all large text ≥ 3:1

---

## Data Formatting

### Distance
- < 1km: show in meters (e.g. `850 m`)
- ≥ 1km: show with 2 decimals (e.g. `5.32 km`)

### Pace
- Always `MM:SS /km`
- Monospaced font for alignment

### Time / Duration
- < 1hr: `MM:SS`
- ≥ 1hr: `H:MM:SS`

---

## File Naming Conventions

All files should use `snake_case.dart` as per Dart conventions.

```text
Components:     activity_card.dart, route_map.dart
Screens:        feed_screen.dart, activity_detail_screen.dart
Tokens:         app_colors.dart, app_spacing.dart, app_text_styles.dart
```

---

*Teman Lari Design System — Inspired by real movement, designed for runners.*
