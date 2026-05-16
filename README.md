# Teman Lari

A Strava-integrated running companion app that helps you analyze your runs, track fitness metrics, and generate personalized training plans.

## Features

- **Strava Integration** - Connect your Strava account to import running activities
- **Activity Analysis** - View detailed metrics including pace, heart rate zones, and elevation
- **Training Plans** - Generate customized training plans based on your fitness level and goals
- **Run Sessions** - Track live running sessions with GPS and real-time pace feedback
- **Fitness Dashboard** - Monitor your progress with charts and statistics

## Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Charts**: FL Chart
- **Local Storage**: Hive, SQLite
- **Architecture**: Clean Architecture (Data / Domain / Presentation layers)

## Project Structure

```
lib/
├── main.dart
├── data/
│   ├── datasources/      # Local and remote data sources
│   ├── models/           # Data models with serialization
│   └── repositories/     # Repository implementations
├── domain/
│   ├── entities/         # Business entities
│   ├── repositories/     # Repository interfaces
│   └── usecases/        # Business logic
└── presentation/
    ├── providers/       # Riverpod providers
    ├── screens/         # App screens
    ├── theme/           # Design system (colors, typography, spacing)
    └── widgets/         # Reusable UI components
```

## Setup

### Prerequisites

- Flutter SDK 3.x
- Dart 3.x
- A Strava API application (create at [strava.com/settings/api](https://www.strava.com/settings/api))

### Environment Variables

Create a `.env` file or configure your Strava credentials:

```
STRAVA_CLIENT_ID=your_client_id
STRAVA_CLIENT_SECRET=your_client_secret
STRAVA_REDIRECT_URI=your_redirect_uri
```

### Installation

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running

```bash
flutter run
```

### Building

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Strava API Setup

1. Go to [Strava Developers](https://www.strava.com/settings/api) and create an application
2. Set the **Authorization Callback Domain** to your app's domain
3. Add the required scopes: `read`, `activity:read`
4. Configure your redirect URI in both Strava settings and your app

For local development, use `http://localhost` as the redirect URI.

## Dependencies

| Package | Purpose |
|---------|---------|
| flutter_riverpod | State management |
| go_router | Declarative routing |
| freezed | Immutable data classes |
| json_serializable | JSON serialization |
| fl_chart | Data visualization |
| geolocator | GPS location tracking |
| flutter_secure_storage | Secure token storage |
| strava_flutter | Strava API integration |

## Deployment (Vercel + GitHub)

This app is configured for automatic deployment via [Vercel](https://vercel.com) + GitHub.

### One-time Setup

1. Push this repo to GitHub
2. Go to [vercel.com](https://vercel.com), click **Add New → Project**, and import your GitHub repo
3. Vercel will auto-detect `vercel.json` and run `bash build.sh`
4. In Vercel dashboard → your project → **Settings → Environment Variables**, add:
   - `STRAVA_CLIENT_ID`
   - `STRAVA_CLIENT_SECRET`
   - `STRAVA_REDIRECT_URI` — set to `https://your-app.vercel.app`
5. Update your [Strava API app](https://www.strava.com/settings/api) callback domain to match your Vercel domain
6. Update `STRAVA_REDIRECT_URI` in `lib/data/datasources/strava_auth_datasource.dart` line 16 from `http://localhost:62789` to your production URL

### How it Works

- Every push to `main` (or PR branch) triggers a Vercel deployment
- `build.sh` installs Flutter SDK, passes Vercel env vars via `--dart-define`, and runs `flutter build web --release`
- Output from `build/web` is deployed with SPA rewrites for client-side routing

### Build Locally

```bash
flutter build web --release \
  --dart-define=STRAVA_CLIENT_ID=... \
  --dart-define=STRAVA_CLIENT_SECRET=... \
  --dart-define=STRAVA_REDIRECT_URI=...
npx vercel --prod
```

## License

MIT
