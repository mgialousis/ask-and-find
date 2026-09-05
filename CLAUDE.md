# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"Ask & Find" (package name `pes_vres`) is a local, pass-and-play party trivia game in Flutter. 2–4 teams take turns: a team sees 10 answers drawn from a card and taps the ones it can name before the timer expires. Single device, offline-first; the only network calls are optional analytics (PostHog) and community card submissions through a separately deployed HTTPS API.

Bilingual EN/ES throughout — UI strings *and* card content.

## Commands

```bash
flutter pub get
flutter run                       # flutter run -d <device-id> for a specific device
flutter test                      # 120 tests, all passing
flutter test test/providers/game_state_provider_test.dart          # single file
flutter test --plain-name "toggleAnswer adds answer"               # single test
flutter test --coverage
flutter analyze                   # clean
dart format lib/ test/
flutter gen-l10n                  # regenerate localizations after editing .arb files
```

Builds — prefer the scripts, which forward explicitly supplied public configuration as `--dart-define`:

```bash
scripts/android_build.sh --release [--icons] [--submissions-endpoint <https-url>]
scripts/ios_deploy.sh --release [--submissions-endpoint <https-url>] <device-id>
flutter build appbundle --release                                      # Play Store (no script)
```

Both scripts run `flutter clean` first, so they are slow; use plain `flutter run` for iteration.

## Configuration and credential boundary

Client configuration uses `String.fromEnvironment` (`--dart-define`):
`SUBMISSIONS_ENDPOINT_URL`, `POSTHOG_API_KEY`, `POSTHOG_HOST`, and
`POSTHOG_ALLOW_DEBUG`. The endpoint must be HTTPS. These are public client
values; no service-account, database, or signing credential belongs in a
Flutter build.

The gitignored `.env` file is used only by maintainer-side Dart scripts that
administer or verify Google Sheets. It is not a Flutter asset, `main.dart` does
not load it, and the Android/iOS build scripts do not source it. See
`docs/SUBMISSION_API.md` for the backend contract and security requirements.

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

`assets/cards.json` holds 317 cards (81 easy / 153 medium / 83 hard). Each entry carries `promptEn`/`promptEs`, `answersEn`/`answersEs`, `difficulty`, `languageScope` (locales the card is playable in — locale-specific trivia is scoped out of the other language), `source`, and `answerPoints`.

**Scoring is per answer, not per card.** `CardItem.pointsForAnswer` returns the `answerPoints[answer]` value (clamped 1–5) when present and only falls back to `Difficulty.pointsPerAnswer` (easy 1 / medium 2 / hard 3) when it isn't. Every card currently in `cards.json` has explicit `answerPoints`, so the difficulty-based values are effectively a fallback for user-submitted cards. `answerDifficulties` is accepted as a legacy alias for `answerPoints` when parsing.

**`answerPoints` must be keyed by both the English and the Spanish answer string.** The lookup happens on the displayed answer, so a card missing its Spanish keys silently scores that answer at the difficulty default in Spanish only. `test/cards_asset_integrity_test.dart` guards this, along with the 10–15 answer range and EN/ES alignment — run it after editing `cards.json`.

### Submissions pipeline

`SubmissionsRepository` tries `SubmissionApiService` when online and configured; on failure or offline, it queues into `OfflineSubmissionsStorage` (SharedPreferences) and returns `savedLocally`. `SubmissionNotifier` subscribes to connectivity changes and drains the queue automatically. The client sends a versioned JSON envelope to an HTTPS endpoint; backend validation, rate limiting, idempotency, and persistence are specified in `docs/SUBMISSION_API.md`.

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

- `flutter analyze` is clean and the unit/widget suite contains 120 tests.
- **Android targets Java/Kotlin 1.8**, set in `android/build.gradle.kts` under `gradle.projectsEvaluated` for all subprojects (this overrides plugin defaults; it is what keeps `audioplayers_android` and `posthog_flutter` compiling consistently). The root build dir is redirected to `<repo>/build`.
- Release APKs are still signed with the debug keystore (`android/app/build.gradle.kts`).
- No tie-breaker/overtime rounds, though `initial-requrements.md` §2.4 specifies them; ties are simply announced on the results screen.

Further docs: `docs/RELEASE_GUIDE.md` (build/publish), `docs/MOBILE_TESTING_GUIDE.md` (device setup), `docs/SUBMISSION_API.md` (secure backend boundary), `docs/INTERNATIONALIZATION_PLAN.md`, and `initial-requrements.md` (original spec — predates several decisions above).
