# AGENTS.md

## Tooling

- Codegen: `dart run build_runner build --delete-conflicting-outputs`
- Lint: `flutter analyze`

## Non-Obvious Rules

- `invalid_annotation_target: ignore` in `analysis_options.yaml` — required for freezed/riverpod generators
- Web build requires Strava env vars passed via `--dart-define`: `STRAVA_CLIENT_ID`, `STRAVA_CLIENT_SECRET`, `STRAVA_REDIRECT_URI`, `STRAVA_ACCESS_TOKEN`, `STRAVA_REFRESH_TOKEN` (see `build.sh`)

## Project-Specific Patterns

- Design tokens in `DESIGN.md` — refer there, don't duplicate
- File naming: `*_model.dart`, `*_entity.dart`, `*_datasource.dart`; generated: `.g.dart`, `.freezed.dart`
