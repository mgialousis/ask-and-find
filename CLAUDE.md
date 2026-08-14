# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"Ask & Find" (package name `pes_vres`) is a local, pass-and-play party trivia game in Flutter. 2–4 teams take turns: a team sees 10 answers drawn from a card and taps the ones it can name before the timer expires. Single device, offline-first; the only network calls are optional analytics (PostHog) and community card submissions (Google Sheets).

Bilingual EN/ES throughout — UI strings *and* card content.

## Commands

```bash
flutter pub get
flutter run                       # flutter run -d <device-id> for a specific device
flutter test                      # 108 tests, all passing
flutter test test/providers/game_state_provider_test.dart          # single file
flutter test --plain-name "toggleAnswer adds answer"               # single test
flutter test --coverage
flutter analyze                   # see "Analyzer baseline" below — not clean
dart format lib/ test/
flutter gen-l10n                  # regenerate localizations after editing .arb files
```

Builds — prefer the scripts, which source `.env` and forward PostHog values as `--dart-define`:

```bash
scripts/android_build.sh --release [--icons] [--no-tree-shake-icons]   # → build/app/outputs/flutter-apk/
scripts/ios_deploy.sh --release <device-id>                            # pod install + flutter run
flutter build appbundle --release                                      # Play Store (no script)
```

Both scripts run `flutter clean` first, so they are slow; use plain `flutter run` for iteration.

## Configuration: `.env`

`.env` is **gitignored but declared as a Flutter asset in `pubspec.yaml`** — builds fail if the file is absent. A fresh clone must `cp .env.example .env` even if all values stay empty.

`main.dart` loads it with `dotenv.load(isOptional: true)`; every config value is read through `AnalyticsConfig` / `SheetsConfig`, which check `.env` first and fall back to `String.fromEnvironment` (`--dart-define`). Keys: `SHEETS_SPREADSHEET_ID`, `SHEETS_CREDENTIALS_JSON` (service-account JSON on one line), `POSTHOG_API_KEY`, `POSTHOG_HOST`, `POSTHOG_ALLOW_DEBUG`.

Since `.env` ships inside the app bundle, anything put there is distributed with the binary.

## Architecture

Layers under `lib/`: `core/` (theme, routing, config, analytics), `domain/entities/` (pure models), `data/` (repositories + sources), `presentation/` (screens, widgets, `state/` providers). Riverpod (`StateNotifierProvider`) is the only state mechanism; `go_router` the only navigation.

### Provider graph

State is split across providers that read each other via `Ref`, so changing one usually means checking its consumers:

- `gameSetupProvider` — teams, colors, **and live team scores**, plus `GameConfig` (rounds, duration, `Set<Difficulty>`). Scores live here, not in game state, and survive across rounds; `resetScores()` is what "Play Again" calls.
- `gameStateProvider` — the active round: phase, current card, the 10 selected answers, found answers, used-card sets. Reads `gameSetupProvider`, `cardsProvider`, `localeProvider`, `timerProvider`; writes scores back through `gameSetupProvider.notifier.updateTeamScore`.
- `timerProvider` — countdown only. `GameScreen` bridges it to game state: a `ref.listenManual` in `initState` plays tick sounds under 10s and calls `endRound()` when it hits 0.
- `cardsProvider` — `FutureProvider` that parses `assets/cards.json` once.
- `settingsProvider`, `localeProvider` — SharedPreferences-backed; keys in `core/config/preferences_keys.dart`.
- `submissionProvider` + `submissionsRepositoryProvider`; form state in `newCardFormProvider` / `correctionFormProvider`.

### Game loop

Four phases in `GamePhase`: `ready` (pass-device handoff) → `preview` (question shown, timer not started, "refresh card" available) → `playing` → `roundEnd`. `roundEnd` renders the playing UI underneath a modal dialog rather than its own screen.

Round mechanics worth knowing before touching `game_state_provider.dart`:

- `startRound()` picks a card excluding `usedCardIdsInRound ∪ usedCardIdsInGame`, filtered by the configured difficulty **set** and by the current locale (see `languageScope`), then shuffles the card's 10–15 answers down to exactly 10.
- The round does **not** auto-end when all answers are found — only timer expiry or the End Turn button ends it, so players can review selections.
- `toggleAnswer` is allowed in both `playing` and `roundEnd`, which is how the results dialog lets teams fix mis-taps and adjust the score after the fact.
- Team rotation happens *within* a round: every team plays before `currentRound` increments, and `usedCardIdsInRound` clears at that boundary (so all teams in a round see distinct cards, and no card repeats in a game).

### Cards and scoring

`assets/cards.json` holds 243 cards (49 easy / 123 medium / 71 hard). Each entry carries `promptEn`/`promptEs`, `answersEn`/`answersEs`, `difficulty`, `languageScope` (locales the card is playable in — locale-specific trivia is scoped out of the other language), `source`, and `answerPoints`.

**Scoring is per answer, not per card.** `CardItem.pointsForAnswer` returns the `answerPoints[answer]` value (clamped 1–5) when present and only falls back to `Difficulty.pointsPerAnswer` (easy 1 / medium 2 / hard 3) when it isn't. Every card currently in `cards.json` has explicit `answerPoints`, so the difficulty-based values are effectively a fallback for user-submitted cards. `answerDifficulties` is accepted as a legacy alias for `answerPoints` when parsing.

**`answerPoints` must be keyed by both the English and the Spanish answer string.** The lookup happens on the displayed answer, so a card missing its Spanish keys silently scores that answer at the difficulty default in Spanish only. `test/cards_asset_integrity_test.dart` guards this, along with the 10–15 answer range and EN/ES alignment — run it after editing `cards.json`.

### Submissions pipeline

`SubmissionsRepository` → tries `GoogleSheetsService` when online *and* configured; on failure or offline, queues into `OfflineSubmissionsStorage` (SharedPreferences) and returns `savedLocally`. `SubmissionNotifier` subscribes to the connectivity stream and drains the queue automatically when the device reconnects. Two worksheets — "New Card Submissions" and "Card Corrections" — with column orders fixed by `SheetsConfig.newCardHeaders` / `correctionHeaders`; changing the sheet layout means changing those lists.

New-card validation (`CardSubmission.isValidNewCard`): prompt 10–200 chars, **exactly 10** answers. Corrections need a 20–1000 char description.

### Analytics

`AnalyticsService` is a singleton initialized in `main()` before `runApp`. Capture is gated on four conditions: initialized, non-empty API key, `kReleaseMode || POSTHOG_ALLOW_DEBUG`, and the user's `settingsProvider.analyticsEnabled` opt-out. Identity is an anonymous UUID in SharedPreferences — no PII, no card content, no team names. Events are fired inline from notifiers (`round_started`, `round_ended`, `answer_toggled`, `settings_changed`, …), usually via `unawaited(...)`.

### Localization

`.arb` sources and the *generated* `app_localizations*.dart` both live in `lib/l10n/` and are **both committed**. After editing an `.arb`, run `flutter gen-l10n` and commit the regenerated Dart. Screens read strings via `AppLocalizations.of(context)`; card text is selected by locale through `CardItem.getPrompt(locale)` / `getAnswers(locale)`, never by looking at `promptEn` directly.

### Theme, sharing, and launch UI

`settingsProvider.darkModeEnabled` now drives `MaterialApp.themeMode`. `AppTheme.darkTheme` supplies the Material component theme, while widgets that need explicit surface or text colours use `context.palette` from `AppPaletteContext`; keep `AppColors` for brand, semantic, and team colours.

The results screen shares standings through the native `share_plus` sheet. iPad calls require a non-empty `sharePositionOrigin`; failures are logged and fall back to a dialog containing the share text.

Android and iOS use branded launch images. Android's density-specific `drawable-*/splash_logo.png` files are shown by `launch_background.xml`, with light/dark splash colours in `values/colors.xml` and `values-night/colors.xml`. iOS uses the three images in `LaunchImage.imageset` from `LaunchScreen.storyboard`.

## Conventions

- No business logic, storage, or network access inside widgets or `build()`; put it in a provider or repository.
- Small composable widgets, flexible layouts (`Expanded`, `LayoutBuilder`, `MediaQuery`); tablet breakpoint is 600dp via `ResponsiveLayout`. Avoid hard-coded pixel sizes.
- Logging: `import 'dart:developer' show log;` then `log('msg', name: 'ComponentName')`.
- Files `lower_snake_case.dart`, types `UpperCamelCase`, 2-space indent, trailing commas.
- Card content must be original — do not copy prompts, answers, or assets from "Πες Βρες".

## Current state / known gaps

- **Analyzer baseline is not clean:** 31 infos and warnings as of 2026-08-14. In addition to the existing deprecated `Radio` API, unused imports/local, and 19 `unnecessary_underscores` infos, the latest changes add an unnecessary null check in `results_screen.dart` and an unused Riverpod import in `dark_mode_test.dart`. `flutter analyze` exits non-zero.
- **iOS asset-symbol setting needs correction:** the Debug and Release project configurations set the boolean `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` to `AppIcon` instead of `YES`; Profile still uses `YES`. The separate Runner target setting `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon` is already correct.
- **Android targets Java/Kotlin 1.8**, set in `android/build.gradle.kts` under `gradle.projectsEvaluated` for all subprojects (this overrides plugin defaults; it is what keeps `audioplayers_android` and `posthog_flutter` compiling consistently). The root build dir is redirected to `<repo>/build`.
- Release APKs are still signed with the debug keystore (`android/app/build.gradle.kts`).
- No tie-breaker/overtime rounds, though `initial-requrements.md` §2.4 specifies them; ties are simply announced on the results screen.

Further docs: `docs/RELEASE_GUIDE.md` (build/publish), `docs/MOBILE_TESTING_GUIDE.md` (device setup), `docs/INTERNATIONALIZATION_PLAN.md`, `initial-requrements.md` (original spec — predates several decisions above).
