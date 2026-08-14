# Ask & Find

A local multiplayer party trivia game built with Flutter. Teams compete to guess items from hidden lists before time runs out!

## 🎮 What is Ask & Find?

Ask & Find is an English version inspired by the Greek game "Πες Βρες!" where 2-4 teams take turns guessing answers from category-based prompts. Think of it as a party game mashup of trivia and speed thinking!

**Example Prompt:** "Name countries in Europe"
- 10 hidden answers to discover
- 60 seconds on the clock
- Tap to reveal each answer
- Score points for each correct guess

## 🚀 Current Status

The core game is playable end to end on Android and iOS:

- Complete setup → game → results → play-again flow
- Configurable teams, rounds, timer, and difficulty
- Riverpod-managed game, setup, timer, settings, and submission state
- 243 bilingual English/Spanish trivia cards with per-answer scoring
- Sound effects, haptic feedback, sharing, and persistent settings
- New-card and correction submissions with offline retry support
- PostHog analytics with a user-facing privacy toggle
- Ask & Find branding and generated Android/iOS launcher icons

Run it locally with `flutter run`.

## 🎯 Features

- Home screen and routed game flow
- Team setup for 2-4 teams with custom names and colors
- Configurable rounds, timer duration, and difficulty
- Timer-based gameplay with countdown audio and haptics
- Per-answer scoring, score adjustment, team rotation, and final results
- Round-complete dialog that requires Continue or End Game
- English and Spanish localization
- Card submission and issue-reporting flows
- Offline submission queue and Google Sheets integration
- Responsive phone and tablet layouts

## 🏗️ Architecture

```
lib/
├── core/              # Analytics, config, routing, theme, and utilities
├── domain/entities/   # Game and submission entities
├── data/
│   ├── repositories/  # Cards and submission repositories
│   └── sources/       # Asset loading, Sheets API, and offline storage
└── presentation/
    ├── state/         # Riverpod providers and notifiers
    ├── screens/       # Home, setup, game, results, settings, submissions
    └── widgets/       # Shared UI components
```

Trivia content is loaded from `assets/cards.json`; app and round state are managed with Riverpod.

## 🎲 How to Play

1. **Setup Teams**: Choose 2-4 teams, pick names and colors
2. **Configure Game**: Select rounds (5/7/10), timer (30/45/60/90s), difficulty
3. **Play Rounds**: Each team tries to find 10 answers before time runs out
4. **Score Points**: Earn the per-answer point value for each correct answer
5. **See Results**: Winner determined by highest score, ties detected

## 🛠️ Tech Stack

- **Framework:** Flutter
- **Language:** Dart ^3.10.4
- **State Management:** Riverpod (Phase 2)
- **Navigation:** go_router ^12.0.0
- **Platforms:** Android, iOS

## 📦 Getting Started

### Prerequisites
- Flutter SDK 3.10.4 or higher
- Dart SDK (comes with Flutter)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd pes_vres

# Optional: configure .env for submissions/analytics
cp .env.example .env

# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Check code quality
flutter analyze
```

### Quick Test Flow

```bash
flutter run
# 1. Tap "New Game"
# 2. Configure teams (try different numbers, names, colors)
# 3. Tap "Start Game"
# 4. Play through rounds
# 5. See winner on results screen
```

## 📁 Project Structure

See `CLAUDE.md` for development guidelines and project overview.

See `docs/RELEASE_GUIDE.md` for publishing/build steps.

See `docs/MOBILE_TESTING_GUIDE.md` for physical-device testing.

## 🎨 Design System

- **Theme:** Material Design 3
- **Colors:** 12 team colors + semantic colors (success, warning, error)
- **Typography:** Roboto with clear hierarchy
- **Responsive:** Phone (< 600dp) and Tablet (≥ 600dp) layouts
- **Components:** Custom widgets with consistent styling

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

**Current Status:** 102 declared test cases across 8 test files, covering localization, providers, setup, shared widgets, submissions, and app launch.

## 📊 Analytics (PostHog)

- Analytics are optional and can be disabled in Settings → Privacy → Analytics.
- No PII is sent. Custom card content and team names are not captured.
- Configure keys via `.env` (recommended) or `--dart-define`:
  - `.env` keys: `POSTHOG_API_KEY`, `POSTHOG_HOST`, `POSTHOG_ALLOW_DEBUG`
  - `--dart-define=POSTHOG_API_KEY=...`
  - `--dart-define=POSTHOG_HOST=https://app.posthog.com`
  - Optional: `--dart-define=POSTHOG_ALLOW_DEBUG=true` for non-release builds.

## 📝 Recent Changes

- Added 21 trivia cards and corrected accuracy issues in existing cards
- Rebranded the app and platform labels to Ask & Find
- Added a launcher-icon source and generated Android/iOS icon variants
- Added the Android build script's optional `--icons` generation step
- Prevented system back from dismissing the round-complete dialog

## 🤝 Contributing

This is a personal project. Feedback and suggestions are welcome!

## 📄 License

[License to be determined]

## 🙏 Acknowledgments

- Inspired by the Greek game "Πες Βρες!"
- Built with Flutter and Material Design
- Developed with assistance from Claude Code

## 📧 Contact

[Contact information to be added]
