Strava running analyzer with training plan generation (Flutter/Dart).

## Setup

- Flutter 3.41.9
- `flutter pub get` — install deps
- `flutter run` — local dev

## Tooling

- Codegen: `dart run build_runner build --delete-conflicting-outputs`
- Test: `flutter test`
- Lint: `flutter analyze`

## Architecture

Clean Architecture:
- `lib/domain/` — entities, repositories, usecases
- `lib/data/` — datasources, models, repository impls
- `lib/presentation/` — providers, screens, theme, widgets
- `lib/core/` — constants, errors, network, services, utils

## File Naming

- Domain: `*_entity.dart`, `*_usecase.dart`
- Data: `*_model.dart`, `*_datasource.dart`, `*_repository_impl.dart`
- Generated: `.g.dart`, `.freezed.dart`

## Non-Obvious Rules

- `invalid_annotation_target: ignore` in `analysis_options.yaml` — required for freezed/riverpod generators
- Web build: Strava env vars via `--dart-define` (see `build.sh`)

## Domain-Specific Docs

- Design tokens: `DESIGN.md` — refer there, don't duplicate
- Training plan architecture: `docs/TRAINING_PLAN_AGENTS.md`
- Flutter rules: `docs/flutter_rules.md`
