# Repository Guidelines

## Project Structure & Module Organization
- `lib/` holds app code: `core/` (theme, routing, utils), `domain/` (entities), `data/` (models), and `presentation/` (screens, widgets, Riverpod providers).
- `test/` contains Flutter tests (currently a widget test in `test/widget_test.dart`).
- Platform targets live in `android/` and `ios/`.
- Supporting docs live in `docs/` (see `docs/MOBILE_TESTING_GUIDE.md`).

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies.
- `flutter run` launches the app locally; use `flutter run -d <device-id>` for a specific device.
- `flutter analyze` runs static analysis (configured via `analysis_options.yaml`).
- `dart format lib/ test/` formats Dart source.
- `flutter test` runs all tests; `flutter test test/widget_test.dart` targets a single file.
- `flutter test --coverage` generates coverage output.
- `flutter build apk` / `flutter build appbundle` / `flutter build ios` create release artifacts.

## Coding Style & Naming Conventions
- Dart/Flutter style with `flutter_lints`; keep analyzer clean.
- Indentation: 2 spaces; prefer trailing commas for auto-formatting.
- Files: `lower_snake_case.dart`. Types: `UpperCamelCase`. Members: `lowerCamelCase`.
- Keep widgets small and composable; avoid business logic in `build()` methods.

## Testing Guidelines
- Framework: `flutter_test`.
- Test names should describe behavior (e.g., `renders home screen`).
- Add widget tests for UI flows and unit tests for game logic as the domain layer grows.

## Commit & Pull Request Guidelines
- Commit messages are short, imperative, and often include a clarifying clause (e.g., `Fix team rotation: Teams now alternate each round`).
- PRs should include: a concise summary, testing notes (`flutter test`/`flutter analyze`), and screenshots for UI changes.

## Configuration & Notes
- App configuration is in `pubspec.yaml`; keep dependency updates minimal and focused.
- State management uses Riverpod; prefer providers in `lib/presentation/state/` for new stateful features.
