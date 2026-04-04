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

**Phase 1: COMPLETE!** 🎉
**Phase 2: COMPLETE!** 🎉

- ✅ Full UI implementation with Material Design 3
- ✅ Complete game loop from setup to results
- ✅ Timer-based gameplay with visual warnings
- ✅ Team rotation and score tracking
- ✅ Winner announcement and results screen
- ✅ **Settings persistence with SharedPreferences** (Day 8)
- ✅ **Riverpod state management infrastructure** (Days 8-10)
- ✅ **Setup → Game → Results → Play Again WORKING!** (Days 8-10) 🎯
- ✅ **Configuration respected: teams, rounds, timer** (Days 8-10)
- ✅ **"Play Again" functionality** (Day 10)
- ✅ 39 files, 7,000+ lines of code
- ✅ Zero analyzer warnings, all tests passing

**Try it now:** `flutter run`

## 🎯 Features

### Implemented (Phase 1)
- ✅ Home screen with navigation
- ✅ Game setup: 2-4 teams, configurable rounds/timer/difficulty
- ✅ Team customization: names and colors
- ✅ Full gameplay: timer, answer discovery, round results
- ✅ Score tracking and team rotation
- ✅ Results screen with winner announcement
- ✅ Share functionality
- ✅ Responsive design (phone and tablet)

### Phase 2 Complete! (State Management) ✅
- ✅ Settings persistence (Day 8)
- ✅ Riverpod provider infrastructure (Days 8-10)
- ✅ Timer & Game state providers (Day 9)
- ✅ Setup → Game connection (Day 9) 🎯
- ✅ Results screen provider integration (Day 10)
- ✅ Play Again functionality (Day 10) 🎯

### Coming Soon (Phase 3+)
- ⏳ Domain logic layer
- ⏳ Animations and sound effects
- ⏳ 100+ original trivia cards

## 🏗️ Architecture

```
lib/
├── core/              # Theme, routing, utils
├── domain/entities/   # Team, CardItem, RoundResult, GameConfig, etc.
├── data/models/       # Mock data (10 sample cards)
└── presentation/
    ├── state/         # Riverpod providers (Phase 2 Days 8-9)
    │   ├── settings_provider.dart      # User preferences
    │   ├── game_setup_provider.dart    # Team & config
    │   ├── timer_provider.dart         # Countdown timer
    │   └── game_state_provider.dart    # Active gameplay
    ├── screens/       # 14 screen files
    │   ├── home/
    │   ├── how_to_play/
    │   ├── settings/  # Uses Riverpod ✅
    │   ├── setup/     # Uses Riverpod ✅
    │   ├── game/      # Uses Riverpod ✅
    │   └── results/   # Uses Riverpod ✅ (Day 10!)
    └── widgets/       # 7 reusable components
```

**Design Pattern:** Clean Architecture with UI-first approach
- Phase 1: UI with local state
- Phase 2: Riverpod state management
- Phase 3: Domain and data layers
- Phase 4: Polish and animations
- Phase 5: Testing and refinement

## 🎲 How to Play

1. **Setup Teams**: Choose 2-4 teams, pick names and colors
2. **Configure Game**: Select rounds (5/7/10), timer (30/45/60/90s), difficulty
3. **Play Rounds**: Each team tries to find 10 answers before time runs out
4. **Score Points**: 1 point per correct answer discovered
5. **See Results**: Winner determined by highest score, ties detected

## 🛠️ Tech Stack

- **Framework:** Flutter ^3.10.4
- **Language:** Dart
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

See `IMPLEMENTATION_PLAN.md` for detailed roadmap and specifications.

See `CLAUDE.md` for development guidelines and project overview.

See `PROJECT_STATUS.md` for current implementation status.

See `docs/RELEASE_GUIDE.md` for publishing/build steps.

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

**Current Status:** 1 widget test (app launch)
**Phase 5:** Comprehensive test suite planned

## 📊 Analytics (PostHog)

- Analytics are optional and can be disabled in Settings → Privacy → Analytics.
- No PII is sent. Custom card content and team names are not captured.
- Configure keys via `.env` (recommended) or `--dart-define`:
  - `.env` keys: `POSTHOG_API_KEY`, `POSTHOG_HOST`, `POSTHOG_ALLOW_DEBUG`
  - `--dart-define=POSTHOG_API_KEY=...`
  - `--dart-define=POSTHOG_HOST=https://app.posthog.com`
  - Optional: `--dart-define=POSTHOG_ALLOW_DEBUG=true` for non-release builds.

## 📝 Development Notes

### Phase 1 Limitations
- Setup configuration doesn't affect gameplay (uses hardcoded values)
- Settings don't persist between sessions
- "Play Again" shows placeholder message

**These will be addressed in Phase 2 with Riverpod integration**

### Mock Data
Currently using 10 sample cards in `lib/data/models/mock_cards.dart`. Phase 4 will add 100+ original cards.

## 🗓️ Roadmap

- ✅ **Phase 1 (Days 1-7):** UI-First Development - COMPLETE
- ✅ **Phase 2 (Days 8-10):** State Management - COMPLETE
  - Day 8: Settings & Setup providers ✅
  - Day 9: Timer & Game State providers, Game Screen refactor ✅
  - Day 10: Results screen refactor & "Play Again" ✅
- ⏳ **Phase 3 (Days 11-13):** Domain & Data Layers
- ⏳ **Phase 4 (Days 14-20):** Polish & Features
- ⏳ **Phase 5 (Days 21-25):** Testing & Refinement

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

---

**Status:** Phase 1 Complete, Phase 2 Complete! 🎉

**Latest:** Phase 2 COMPLETE! Setup → Game → Results → Play Again flow working! ✅

**Next:** Phase 3 - Domain & Data Layers
