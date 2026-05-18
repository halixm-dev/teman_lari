# teman_lari - AGENTS.md

This document defines workflows, conventions, and best practices for working with this codebase.

## Project Overview

- **Type**: Flutter mobile/web app (Strava-integrated running companion)
- **State Management**: Riverpod with code generation (`riverpod_annotation`, `riverpod_generator`)
- **Architecture**: Clean Architecture with three layers
- **Code Generation**: Freezed for immutable models, `json_serializable` for JSON parsing
- **Navigation**: GoRouter for declarative routing
- **Linting**: Flutter lints (see `analysis_options.yaml`)

---

## Architecture Layers

```
lib/
├── core/           # Shared utilities, constants, errors, services
├── data/           # Models, datasources, repository implementations
├── domain/         # Entities, repository interfaces, use cases
└── presentation/   # Providers, screens, theme, widgets
```

**Layer Responsibilities:**
- `domain/` - Pure Dart, no dependencies on data or presentation layers
- `data/` - JSON serialization, API calls, local storage
- `presentation/` - Flutter widgets, Riverpod providers, theming

---

## Code Conventions

### File Naming
- `camelCase.dart` for all Dart files
- Generated files: `.g.dart` (json_serializable), `.freezed.dart` (freezed)
- Models: `*_model.dart`, Entities: `*_entity.dart`, Datasources: `*_datasource.dart`

### State Pattern
```dart
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  const AuthState.unknown() : ...;
  const AuthState.authenticated() : ...;
  const AuthState.error(String message) : ...;
}
```

### Provider Pattern
```dart
final authStateProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState.unknown();
  // ...
}
```

### Use Case Pattern
Business logic in `domain/usecases/` with clean input/output types. Use cases are injected via Riverpod.

---

## Code Generation Workflow

1. Edit model/usecase files (e.g., `activity_model.dart`)
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Commit generated files (`.g.dart`, `.freezed.dart`)

---

## Design System

Refer to `DESIGN.md` for complete design tokens:

- **Brand Orange**: `#FC4C02` (primary CTAs, achievements)
- **Fonts**: Figtree (primary), JetBrains Mono (stats/pace)
- **Spacing**: 4px base unit
- **Border Radius**: 4px (badges) → 24px (prominent cards)

### Theme Files
- `lib/presentation/theme/app_colors.dart`
- `lib/presentation/theme/app_typography.dart`
- `lib/presentation/theme/app_spacing.dart`
- `lib/presentation/theme/app_shadows.dart`
- `lib/presentation/theme/app_theme.dart`

---

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `riverpod_annotation` | Code generation for providers |
| `go_router` | Declarative navigation |
| `http` | API calls |
| `freezed` | Immutable data classes |
| `json_serializable` | JSON parsing |
| `hive_flutter`, `sqflite` | Local storage |
| `fl_chart` | Charts and data visualization |
| `geolocator` | GPS tracking |
| `phosphor_flutter` | Icons |

---

## Common Tasks

### Adding a new API endpoint
1. Add route constants to `core/constants/api_constants.dart`
2. Add method to `data/datasources/strava_activity_datasource.dart`
3. Create/use usecase in `domain/usecases/`
4. Expose via Riverpod provider in `presentation/providers/`

### Adding a new screen
1. Create in `lib/presentation/screens/`
2. Register route in `main.dart` with GoRouter
3. Add responsive layout using `MainNavigationScreen` pattern

### Running the app
```bash
flutter run                    # Default device
flutter run -d chrome         # Web
flutter run -d <device-id>    # Specific device
```

### Linting
```bash
flutter analyze
```

---

## Analysis Options

Custom analyzer settings in `analysis_options.yaml`:
- `invalid_annotation_target: ignore` (used by freezed/riverpod generators)
