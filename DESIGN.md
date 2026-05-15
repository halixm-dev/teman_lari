# Strava Design System

A design language inspired by Strava — built for athletes, powered by data, shaped by community.

---

## Brand Identity

**Mission**: Connect athletes to what motivates them — camaraderie, competition, and the pursuit of personal bests.

**Personality**:
- **Energetic** — Movement, momentum, forward drive
- **Social** — Community, shared achievement, encouragement
- **Data-driven** — Precision metrics, honest performance tracking
- **Motivating** — Celebrate every effort, from first 1k to ultramarathons

**Voice**: Direct, action-oriented, celebratory. Uses active verbs. Numbers are heroes.

---

## Color System

### Primary Palette

| Token | Hex | Usage |
|---|---|---|
| `--color-brand-orange` | `#FC4C02` | Primary CTA, achievements, PR badges |
| `--color-brand-orange-dark` | `#E03D00` | Hover states, pressed CTAs |
| `--color-brand-orange-light` | `#FF7A45` | Gradients, soft accents |
| `--color-brand-orange-tint` | `#FFF0EB` | Backgrounds on orange-related content |

### Neutral Palette

| Token | Hex | Usage |
|---|---|---|
| `--color-gray-900` | `#1A1A1A` | Primary text, headings |
| `--color-gray-700` | `#3D3D3D` | Secondary body text |
| `--color-gray-500` | `#707070` | Muted labels, metadata |
| `--color-gray-300` | `#B0B0B0` | Disabled states, dividers |
| `--color-gray-100` | `#F5F5F5` | Surface backgrounds |
| `--color-gray-50` | `#FAFAFA` | Page background |
| `--color-white` | `#FFFFFF` | Cards, modals |

### Semantic Colors

| Token | Hex | Meaning |
|---|---|---|
| `--color-kudos` | `#FC4C02` | Kudos / likes |
| `--color-pr` | `#8B5CF6` | Personal records |
| `--color-kom` | `#FFD700` | KOM / QOM trophies |
| `--color-run` | `#FC4C02` | Running sport type |
| `--color-ride` | `#0077B6` | Cycling sport type |
| `--color-swim` | `#00B4D8` | Swimming sport type |
| `--color-hike` | `#2D6A4F` | Hiking sport type |
| `--color-success` | `#22C55E` | Completion, positive delta |
| `--color-warning` | `#F59E0B` | Moderate alerts |
| `--color-danger` | `#EF4444` | Errors, missed goals |

### Dark Mode

Strava's dark mode uses deep charcoal surfaces, not pure black.

| Token | Dark Value |
|---|---|
| `--color-surface-primary` | `#1C1C1E` |
| `--color-surface-secondary` | `#2C2C2E` |
| `--color-surface-tertiary` | `#3A3A3C` |
| `--color-text-primary` | `#F2F2F7` |
| `--color-text-secondary` | `#AEAEB2` |
| `--color-text-tertiary` | `#636366` |
| `--color-divider` | `#38383A` |

---

## Typography

### Font Families

```css
/* Primary — used for all UI, headings, stats */
--font-primary: 'Figtree', 'Inter', sans-serif;

/* Monospace — used for pace, split data */
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

### Type Scale

| Role | Size | Weight | Line Height | Usage |
|---|---|---|---|---|
| `display-xl` | 48px | 800 | 1.1 | Hero numbers (distance, time) |
| `display-lg` | 36px | 700 | 1.15 | Activity title |
| `display-md` | 28px | 700 | 1.2 | Section heroes |
| `heading-lg` | 22px | 600 | 1.3 | Card headings |
| `heading-md` | 18px | 600 | 1.35 | Sub-headings |
| `heading-sm` | 15px | 600 | 1.4 | Labels, tabs |
| `body-lg` | 16px | 400 | 1.6 | Primary body |
| `body-md` | 14px | 400 | 1.55 | Secondary content |
| `body-sm` | 13px | 400 | 1.5 | Metadata, timestamps |
| `caption` | 11px | 500 | 1.4 | Chart labels, badges |
| `stat-hero` | 42px | 800 | 1.0 | Key metrics (pace, HR, watts) |
| `stat-unit` | 16px | 500 | 1.0 | Units alongside stat heroes |

### Typography Rules

- Stats and performance numbers use `--font-mono` for tabular alignment
- Pace format: always `MM:SS /km` or `MM:SS /mi`, monospaced
- Large numbers animate in on page load with a count-up
- PR (personal record) values are always styled in `--color-pr` purple
- Never use body text smaller than 11px

---

## Spacing System

Based on a 4px base unit.

| Token | Value | Usage |
|---|---|---|
| `--space-1` | 4px | Icon gaps, tight metadata |
| `--space-2` | 8px | Inner component padding |
| `--space-3` | 12px | Between related elements |
| `--space-4` | 16px | Standard card padding |
| `--space-5` | 20px | Between sections within a card |
| `--space-6` | 24px | Card margins, list item spacing |
| `--space-8` | 32px | Section gaps |
| `--space-10` | 40px | Large section separators |
| `--space-12` | 48px | Page-level top padding |
| `--space-16` | 64px | Hero section vertical rhythm |

---

## Border Radius

| Token | Value | Usage |
|---|---|---|
| `--radius-sm` | 4px | Badges, chips, tags |
| `--radius-md` | 8px | Buttons, inputs, small cards |
| `--radius-lg` | 12px | Cards, activity tiles |
| `--radius-xl` | 16px | Bottom sheets, modals |
| `--radius-2xl` | 24px | Map overlays, prominent cards |
| `--radius-full` | 9999px | Avatars, pill buttons, sport icons |

---

## Elevation & Shadows

Strava uses minimal, purposeful shadows — not decorative.

```css
--shadow-sm:  0 1px 2px rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.08);
--shadow-md:  0 4px 6px rgba(0,0,0,0.07), 0 2px 4px rgba(0,0,0,0.05);
--shadow-lg:  0 10px 15px rgba(0,0,0,0.08), 0 4px 6px rgba(0,0,0,0.05);
--shadow-xl:  0 20px 25px rgba(0,0,0,0.09), 0 10px 10px rgba(0,0,0,0.04);
```

| Level | Shadow | Usage |
|---|---|---|
| 0 | None | Flat list items |
| 1 | `sm` | Segment cards, stat tiles |
| 2 | `md` | Activity feed cards |
| 3 | `lg` | Map overlays, dropdowns |
| 4 | `xl` | Modals, bottom sheets |

---

## Iconography

### Icon Library
Strava uses a custom icon set. In implementation, use **Phosphor Icons** or **Lucide** as a close analog.

| Style | Weight | Usage |
|---|---|---|
| Regular | 1.5px stroke | Navigation, UI controls |
| Bold | 2px stroke | Active states, emphasis |
| Fill | Solid | Sport type icons, achievement badges |

### Sport Icons

Each sport has a dedicated icon + color pairing:

| Sport | Icon | Color Token |
|---|---|---|
| Run | `icon-run` | `--color-run` |
| Ride | `icon-bicycle` | `--color-ride` |
| Swim | `icon-waves` | `--color-swim` |
| Hike | `icon-mountain` | `--color-hike` |
| Yoga | `icon-lotus` | `#A78BFA` |
| Workout | `icon-dumbbell` | `#64748B` |
| Ski | `icon-snowflake` | `#60A5FA` |

Sport icon containers are always `--radius-full` circles, 40×40px (mobile) or 48×48px (desktop), with a 10% opacity tint of the sport color as background.

### Achievement Icons

| Badge | Visual | Trigger |
|---|---|---|
| PR | Lightning bolt, purple | Fastest segment or distance |
| KOM/QOM | Trophy, gold | Segment leader |
| Top 10 | Ribbon | Top 10 on any segment |
| Kudos | Thumbs up → flame | Social appreciation |
| Streak | Fire | Consecutive activity days |

---

## Components

### Activity Card

The core UI unit of Strava. Contains everything about a single workout.

**Anatomy:**
1. **Header row** — Avatar (40px) + Athlete name + timestamp + sport icon
2. **Activity title** — `heading-lg`, editable
3. **Map thumbnail** — 16:9 ratio, route trace in brand orange, dark map tiles
4. **Stats row** — 3 primary metrics (Distance / Moving Time / Elevation), arranged in a 3-column grid
5. **Kudos & comment bar** — Kudos count + thumbs up button + comment button + share
6. **Kudos names** — Up to 3 names, then "+ N others"

**Behavior:**
- Map animates route trace on hover (desktop)
- Kudos button: tap → orange fill + haptic feedback + count increments
- Double-tap anywhere on card = kudos (Instagram-style)
- Cards support swipe-left to reveal quick actions on mobile

**Spec:**
```
Background: --color-white
Border: 1px solid rgba(0,0,0,0.08)
Border-radius: --radius-lg
Padding: --space-4
Shadow: --shadow-md
Map height: 160px (mobile), 200px (desktop)
Stat value: 24px / 700
Stat label: 11px / 500 / --color-gray-500 / uppercase / letter-spacing: 0.05em
```

---

### Segment Leaderboard Row

```
[Rank #] [Avatar 32px] [Athlete Name] [Elapsed Time] [Date] [Trophy? ▶ button]
```

- Top 3 get gold/silver/bronze rank badges
- Current user's row gets a subtle `--color-brand-orange-tint` background
- KOM row has a gold left-border accent (4px)

---

### Stat Tile

Used in activity detail views.

```
┌────────────────────┐
│  2:34 /km          │ ← stat-hero, monospace
│  Avg Pace          │ ← caption, uppercase, muted
│  ▲ 0:08 vs last   │ ← delta indicator, green/red
└────────────────────┘
```

- Grid of 4–6 tiles on activity detail
- Tap any tile → expands to full chart of that metric over time
- PR values render with a purple ⚡ prefix

---

### Map Component

Strava's map is a first-class UI element, not a widget.

**Base layer options:**
- **Standard** — Muted gray-green, roads white/light gray
- **Satellite** — Full imagery with semi-transparent route overlay
- **Dark** — Charcoal map, high-contrast route trace

**Route trace:**
- Default: `--color-brand-orange`, 3px stroke, rounded line cap
- Gradient by elevation: blue (low) → orange → red (high)
- Gradient by pace: green (fast) → yellow → red (slow)
- Gradient by heart rate: zone-color segments

**Overlays:**
- Start: green filled circle, 10px
- End: red filled circle, 10px  
- PR segment: highlighted in purple, with ⚡ label
- Lap markers: vertical dashes with lap number

**Controls:**
- Zoom in/out: bottom-right corner, pill button pair
- Layer toggle: top-right, map-type selector
- Full-screen: top-left, expand icon

---

### Navigation

#### Mobile Bottom Tab Bar

```
[Feed] [Explore] [⊕ Record] [Groups] [Profile]
```

- Record button: `--color-brand-orange` filled circle, 56px, elevated
- Active tab: icon turns orange + label shows
- Inactive: icon gray, label hidden
- Height: 56px safe area + device insets

#### Desktop Top Nav

```
[Strava Logo] [Dashboard] [Training] [Explore] [Challenges]   [Notifications🔔] [Profile Avatar]
```

- Logo: wordmark in `--color-gray-900` (light) or `--color-white` (dark)
- Active item: orange underline 2px
- `position: sticky; top: 0; backdrop-filter: blur(12px);`

---

### Buttons

#### Hierarchy

| Variant | Background | Text | Border | Usage |
|---|---|---|---|---|
| Primary | `--color-brand-orange` | White | None | Record, Save activity, Subscribe |
| Secondary | White | `--color-brand-orange` | 2px orange | Kudos, Follow, Edit |
| Ghost | Transparent | `--color-gray-700` | 1px gray | Cancel, Dismiss |
| Danger | `--color-danger` | White | None | Delete, Unfollow |
| Disabled | `--color-gray-100` | `--color-gray-300` | None | — |

#### Sizes

| Size | Height | Padding | Font | Radius |
|---|---|---|---|---|
| `sm` | 32px | 0 12px | 13px / 500 | --radius-md |
| `md` | 40px | 0 16px | 14px / 600 | --radius-md |
| `lg` | 48px | 0 24px | 16px / 600 | --radius-md |
| `xl` | 56px | 0 32px | 18px / 700 | --radius-lg |

**States:**
- Hover: `brightness(0.92)` + `translateY(-1px)` + shadow upgrade
- Active/Press: `brightness(0.88)` + `scale(0.97)` + shadow remove
- Loading: spinner replaces label, button width locked

---

### Kudos Button

Strava's most recognizable micro-interaction.

**States:**
1. **Default** — Outlined thumbs-up, gray
2. **Hover** — Orange tint background fills in
3. **Active** — Thumb fills orange, count increments with a +1 animation floating up
4. **Double-tap** — Full-screen kudos burst (confetti-style thumbs up emojis)

**Animation spec:**
```
transition: all 0.15s cubic-bezier(0.34, 1.56, 0.64, 1)
Count float: translateY(-20px), opacity 0→1→0, 600ms
Scale on press: 1 → 0.85 → 1.15 → 1.0, 300ms
```

---

### Progress Rings & Streak Indicators

Used in Goals and Training Plans.

- SVG circles, stroke-dasharray animated on load
- Orange fill for progress, gray track
- Inner label: current / target
- Completion: ring glows orange (box-shadow pulse)
- Streak counter: flame icon, count in bold, color intensifies with streak length (amber → orange → red)

---

### Charts & Data Visualization

#### Elevation Profile
- Area chart, filled with gradient (orange at line, transparent at base)
- X-axis: distance in km/mi
- Y-axis: elevation in m/ft
- Hover scrubber: vertical rule + tooltip (distance, elevation, grade%)
- Grade shading: color-coded segments (green < 4%, yellow 4–8%, red > 8%)

#### Heart Rate Zone Chart
- Horizontal stacked bar per lap or time segment
- Zone 1–5 color scale: blue → green → yellow → orange → red
- Legend inline, compact

#### Weekly Training Load
- Bar chart, bars colored by sport type
- Trend line overlay (7-day rolling average)
- Rest day indicators: small dash, no bar

#### Pace/Power Curve
- Logarithmic X-axis (1s to 4hr)
- Best effort = orange line
- 90-day PR = dashed purple line
- Click any point → shows the activity that set it

**Chart Common Rules:**
- Grid lines: `rgba(0,0,0,0.06)`, horizontal only
- Axis labels: `caption` style, `--color-gray-500`
- No chart borders or backgrounds
- Tooltips: dark pill `rgba(0,0,0,0.85)`, white text, 8px radius, no arrow

---

### Feed

The main social surface.

**Post Types (in order of visual weight):**
1. Activity with map → full card
2. Activity without GPS → icon + stats card
3. Challenge joined/completed → achievement card (orange/gold)
4. Group join → social card
5. Photo post → image-first card

**Feed Sorting:**
- Chronological by default
- "You may have missed" section: collapsed, tap to expand

---

## Motion & Animation

### Principles

- **Physics-based**: Spring curves, not linear or ease-in-out
- **Purposeful**: Every animation conveys state or direction
- **Fast**: UI animations < 300ms. Celebrations up to 800ms.
- **Respectful**: Honor `prefers-reduced-motion`

### Easing Curves

```css
--ease-spring:    cubic-bezier(0.34, 1.56, 0.64, 1);   /* Bouncy, for kudos/PR */
--ease-enter:     cubic-bezier(0.0, 0.0, 0.2, 1.0);    /* Decelerate in */
--ease-exit:      cubic-bezier(0.4, 0.0, 1.0, 1.0);    /* Accelerate out */
--ease-standard:  cubic-bezier(0.4, 0.0, 0.2, 1.0);    /* Standard UI */
```

### Duration Scale

| Token | Duration | Usage |
|---|---|---|
| `--duration-instant` | 80ms | Hover fills, checkbox toggle |
| `--duration-fast` | 150ms | Button press, icon swap |
| `--duration-normal` | 250ms | Card expand, tooltip show |
| `--duration-slow` | 350ms | Page transitions, modal enter |
| `--duration-celebrate` | 600–800ms | PR reveal, kudos burst |

### Signature Animations

**Route Trace Draw-on:**
```
SVG stroke-dashoffset from total-length → 0
Duration: 1200ms, ease-enter
Trigger: map becomes visible in viewport
```

**Stat Count-Up:**
```
Number animates from 0 to final value
Duration: 800ms, ease-enter
Stagger: each stat +100ms delay
```

**Kudos Burst:**
```
12 thumbs-up icons radiate from button
Scale: 0.5 → 1.2 → 0, random angles
Duration: 600ms per icon, staggered 30ms
```

**PR Badge Reveal:**
```
⚡ badge slides in from right
Spring scale: 0 → 1.2 → 1.0
Purple glow pulse: 2 cycles at 400ms each
```

**Activity Card Entrance (Feed):**
```
translateY(16px) + opacity(0) → final position
Duration: 250ms, ease-enter
Stagger: each card 80ms after previous
```

---

## Iconography — Sport Type System

Each sport has a complete visual identity:

```
Sport Icon Circle
├── Size: 48×48px (desktop), 40×40px (mobile)
├── Shape: --radius-full
├── Background: sport color at 12% opacity
└── Icon: sport icon, sport color, 24px

Sport Activity Badge
├── Compact: 28×28px circle inline with text
├── Used in: leaderboards, search results, followers list
└── Color-coded by sport

Sport Filter Chip
├── Height: 32px, --radius-full
├── Default: gray outline + icon + label
├── Selected: solid sport-color fill, white text
└── Used in: feed filter, segment search
```

---

## Accessibility

- All interactive elements: minimum 44×44px touch target
- Color is never the only differentiator — icons or labels always accompany
- Focus ring: 2px `--color-brand-orange` offset 2px, on all interactive elements
- PR / achievement indicators: include `aria-label` describing the achievement, not just visual badge
- Map: keyboard navigable, pinch/zoom gestures have button equivalents
- Animations: wrap all non-essential animations in `@media (prefers-reduced-motion: no-preference)`
- Contrast: all body text ≥ 4.5:1, all large text ≥ 3:1

---

## Responsive Breakpoints

| Breakpoint | Token | Value | Context |
|---|---|---|---|
| Mobile S | `xs` | 375px | iPhone SE |
| Mobile | `sm` | 390px | Standard mobile |
| Mobile L | `md` | 430px | Max mobile |
| Tablet | `lg` | 768px | iPad portrait |
| Desktop S | `xl` | 1024px | iPad landscape, small laptop |
| Desktop | `2xl` | 1280px | Standard desktop |
| Desktop L | `3xl` | 1440px | Large display |

**Mobile-first approach.** Feed is single-column on mobile, 2-column on tablet, and limited to ~680px max-width centered on desktop (with sidebar at 1280px+).

---

## Data Formatting

### Distance
- < 1km: show in meters (e.g. `850 m`)
- ≥ 1km: show with 2 decimals (e.g. `5.32 km`)
- Imperial: miles with 2 decimals (e.g. `3.31 mi`)

### Pace
- Always `MM:SS /km` or `MM:SS /mi`
- Never convert to decimal (not `6.5 min/km`)
- Monospaced font for alignment in lists

### Time / Duration
- < 1hr: `MM:SS`
- ≥ 1hr: `H:MM:SS`
- Elapsed (including pauses): shown in parens where relevant

### Elevation
- Metric: whole meters (e.g. `342 m`)
- Imperial: whole feet (e.g. `1,122 ft`)

### Date / Timestamp
- Today: `Today at 6:42 AM`
- This week: `Wednesday at 6:42 AM`
- This year: `March 5 at 6:42 AM`
- Older: `March 5, 2023`

### Numbers
- Always use locale-aware separators (1,000 not 1000 for 4+ digits)
- Calories: whole numbers only
- Watts: whole numbers only, abbreviated `W`
- Speed: 1 decimal for km/h, mph; 0 decimals for pace

---

## Design Dos and Don'ts

### ✅ Do
- Lead with the athlete's data — their numbers are the heroes
- Celebrate every finish, regardless of pace
- Use orange sparingly — high-value moments only
- Show routes on maps whenever GPS data exists
- Make the kudos interaction feel deeply satisfying
- Design for one-handed mobile use — all primary actions reachable with thumb
- Support dark mode natively

### ❌ Don't
- Use more than 2 sport colors on the same screen
- Show empty states without a motivating call-to-action
- Use rounded rectangles for map tiles or full-bleed images
- Put more than 3 primary metrics in the main stat row
- Animate more than 2–3 elements simultaneously in the feed
- Use gradients on text
- Truncate PR or time data — always show complete values

---

## File Naming Conventions

```
Components:     ActivityCard.tsx, KudosButton.tsx, RouteMap.tsx
Screens:        FeedScreen.tsx, ActivityDetailScreen.tsx
Icons:          icon-run.svg, icon-ride.svg, icon-pr-badge.svg
Assets:         map-dark-tile.png, achievement-kom.svg
Tokens:         colors.ts, spacing.ts, typography.ts, motion.ts
```

---

*Strava Design System — Inspired by real movement, designed for every athlete.*
