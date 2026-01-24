# Say & Find - Project Status

**Last Updated:** 2026-01-23

## Quick Summary

- **Phase:** Phase 4+ (Polish, Internationalization, Submissions, Analytics)
- **Progress:** Feature-complete core game loop with content and submission tools
- **Status:** Active development with new integrations in place
- **Cards:** JSON-driven card library with per-answer point values and language support
- **Analytics:** PostHog integrated with opt-out and `.env` config

## What Works Right Now

### Core Game Features

1. **Home Screen** - Navigate to New Game, How to Play, Settings
2. **How to Play** - Full instructions
3. **Settings** - Sound, haptics, dark mode (placeholder), language, analytics opt-out
4. **Setup Screen** - Configure teams (2-4), rounds, duration, difficulty selection
5. **Game Loop**
   - Team handoff screen before each turn
   - Pre-turn question preview card (tap to start timer)
   - Refresh question button (same difficulty, avoids repeats)
   - Countdown timer with audio tick (last 10s) and end beep
   - Answer chips toggle selection/deselection
   - Per-answer point values shown in round results
   - End Round / End Game flows
   - Team rotation: all teams play each round
6. **Round Results Dialog**
   - Found/missed answers
   - Score adjustments by toggling answers
   - Scores so far and source attribution
   - Report issue entry point
7. **Results Screen**
   - Winner/tie announcement
   - Confetti celebration
   - Scoreboard and actions: Play Again, New Setup, Share, Home

### Content & Data

- Cards stored in `assets/cards.json` with:
  - `promptEn` / `promptEs`
  - `answersEn` / `answersEs`
  - `answerPoints` (1-5 per answer)
  - `languageScope` for language-specific prompts
- Randomized selection avoids repeats within a round and across the game.
- Answer list validation enforces exactly 10 answers for submissions.

### Submissions & Reporting

- New card submission flow with validation
- Report Issue / correction mode for existing cards
- Offline queue and retry for submissions
- Card preview in submission UI
- Google Sheets setup documented in `docs/Card Submission Plan.md`

### Internationalization

- UI localized for English and Spanish
- First 20+ cards translated, plus full cards translation support
- Language selection in Settings
- Language-sensitive cards can be flagged

### Analytics (PostHog)

- PostHog integration via `posthog_flutter`
- Opt-out toggle in Settings → Privacy → Analytics
- Events: app opened, game start/preview/start/end, answer toggles, refresh, game completion, submission events, language changes
- Configuration via `.env` (`POSTHOG_API_KEY`, `POSTHOG_HOST`, `POSTHOG_ALLOW_DEBUG`) or `--dart-define`

### Scripts

- `scripts/ios_deploy.sh` (supports `--debug`/`--release` + PostHog env)
- `scripts/android_build.sh` (supports `--debug`/`--release`, `--no-tree-shake-icons` + PostHog env)

## Architecture Snapshot

```
lib/
├── core/                   # Theme, routing, analytics/config
├── domain/entities/        # Team, CardItem, Difficulty, GameConfig, submissions
├── data/                   # Repositories and card loading
└── presentation/
    ├── state/              # Riverpod providers (game, timer, settings, locale)
    ├── screens/            # Home, setup, game, results, submission, settings
    └── widgets/            # Reusable UI components
```

## How to Build / Run

```bash
# Run locally
flutter run

# iOS deploy (device id required)
./scripts/ios_deploy.sh --release <device-id>

# Android APK
./scripts/android_build.sh --release
```

## Known Gaps / Follow-ups

- Verify analytics events and payloads in PostHog dashboard
- Run `flutter test` to validate current test suite after recent changes
- Continue remaining tasks from `docs/INTERNATIONALIZATION_PLAN.md`

## Recent Progress

- Implemented PostHog analytics with opt-out toggle and events
- Added Spanish localization keys and translated cards infrastructure
- Added card submission and correction flow with validation and previews
- Introduced per-answer point values and randomized answer selection
- Added pre-turn question preview card and refresh question action
- Improved audio feedback (countdown + timer-end beep)
- Added scripts for iOS deploy and Android builds
- Moved Sheets credentials to `.env` and added `.env.example`
- Added `docs/RELEASE_GUIDE.md` with APK/TestFlight publishing steps
- Added CLI scripts for sheet creation/testing via `scripts/create_google_sheet.dart` and `scripts/test_sheets_submission.dart`
