# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Quick Status:** 🎉 Phase 1 COMPLETE! Phase 2 Days 8-9 COMPLETE! ✅ Setup→Game connection WORKING! Configuration controls gameplay. See `PROJECT_STATUS.md` for detailed status.

## Project Overview

"Say & Find" (Pes Vres) is a **local multiplayer party trivia game** built with Flutter. It's an English version of the Greek game "Πες Βρες!" where 2-4 teams compete to guess items from hidden lists before a timer expires.

**Core Gameplay:**
- Single-device, pass-and-play format
- 2-4 teams competing in rounds
- Each round: a team tries to guess 10 answers from a prompt/question within a time limit
- Teams score 1 point per correct answer found
- Configurable difficulty levels (Easy/Medium/Hard/Mixed) and round duration (30/45/60/90 seconds)
- Tie-breaker/overtime mechanism when teams tie for first place

**Tech Stack:**
- Flutter (SDK: ^3.10.4)
- Target platforms: Android and iOS
- Local storage only (no backend for v1)
- State management: Riverpod (flutter_riverpod ^2.4.0)
- Navigation: go_router (^12.0.0)

## Implementation Status

**Current Phase:** 🚧 Phase 2 - State Management (Days 8-9 of 10 COMPLETE!)

**Phase 1 Complete (Days 1-7):**
- ✅ **Foundation** - Theme system, routing, entities, mock data
- ✅ **Reusable Widgets** - Buttons, color picker, responsive layouts, answer chips, team indicators, score cards
- ✅ **Home Screen** - Main menu with navigation
- ✅ **How to Play Screen** - Game instructions
- ✅ **Settings Screen** - App preferences (NOW with Riverpod + persistence!)
- ✅ **Setup Screen** - Team configuration and game settings (NOW syncs to provider!)
- ✅ **Game Screen** - Full gameplay loop with timer, answer discovery, scoring, and round management
- ✅ **Results Screen** - Final scoreboard, winner announcement, and action buttons

**Phase 2 - Day 8 Complete:**
- ✅ **Settings Provider** - Persistent user preferences with SharedPreferences
- ✅ **Game Setup Provider** - Team and configuration state management
- ✅ **Settings Screen Refactored** - ConsumerWidget with automatic persistence
- ✅ **Setup Screen Refactored** - ConsumerStatefulWidget with hybrid approach

**Phase 2 - Day 9 Complete:**
- ✅ **Timer Provider** - Countdown timer with auto-expiration detection
- ✅ **Game State Provider** - Active game orchestration (rounds, cards, scoring)
- ✅ **Game Screen FULLY Refactored** - Connected to all providers
- ✅ **Setup → Game Connection WORKING!** - Configuration controls gameplay
- 39 files (7,000+ lines of code)
- Zero flutter analyze warnings
- All tests passing

**What's Next:**
- ⏳ **Results Screen Refactor** - Connect to providers (Day 10)
- ⏳ **Play Again Functionality** - Use resetScores() (Day 10)
- ⏳ **Phase 2 Completion** - Final testing and documentation (Day 10)
- ⏳ **Domain Logic** - Use cases and repositories (Phase 3)
- ⏳ **Polish** - Animations, sounds, haptics (Phase 4)
- ⏳ **Testing** - Comprehensive test suite (Phase 5)

**Important Notes for Claude:**
- **Phase 2 Days 8-9 complete!** Full Riverpod state management working
- Settings screen: Full migration to ConsumerWidget with SharedPreferences persistence ✅
- Setup screen: Hybrid migration - syncs to provider but keeps local validation ✅
- Game screen: FULLY refactored to use all providers ✅ (Day 9 complete!)
- **Setup → Game connection WORKING!** Teams, rounds, timer all from setup config ✅
- **Complete playable game** from home to results screen
- All 39 files pass `flutter analyze` with no issues
- Mock data available in `lib/data/models/mock_cards.dart` (10 sample cards)
- See `IMPLEMENTATION_PLAN.md` for detailed roadmap and specifications

**Current Limitations (Almost Done!):**
- ✅ Settings NOW persist between sessions! (Day 8 complete)
- ✅ Setup screen NOW populates provider with config! (Day 8 complete)
- ✅ Game screen NOW uses setup configuration! (Day 9 complete) 🎉
- ⏳ "Play Again" shows placeholder message (Day 10 will implement)

### What Can Be Tested Right Now

**Fully Functional Gameplay (End-to-End):**

1. **Run the app**: `flutter run`
2. **Navigate**: Home → Tap "New Game"
3. **Setup Game**:
   - Select number of teams (try 2, 3, or 4)
   - Customize team names
   - Pick team colors (unavailable colors grayed out)
   - Choose rounds: 5, 7, or 10
   - Choose timer: 30s, 45s, 60s, or 90s
   - Choose difficulty: Easy, Medium, Hard, Mixed
   - Tap "Start Game"
4. **Play Game**:
   - See "Pass device to Team X" screen
   - Tap "Ready? Start Round"
   - Timer starts counting down
   - See random question (e.g., "Name countries in Europe")
   - Tap numbered chips (1-10) to reveal answers
   - Found answers turn green with checkmark
   - Timer turns orange at 10s, red at 5s
   - Round ends when timer expires or all found
5. **View Round Results**:
   - See points earned (X of 10)
   - Tap "Show Answers" to see found/missed
   - See source attribution
   - Tap "Continue"
6. **Next Round**:
   - Device passes to next team
   - Repeat for all rounds
7. **Game Complete**:
   - Navigates to results screen with final scores
8. **View Results**:
   - See "Game Over!" header
   - Winner announcement (or "It's a Tie!")
   - Sorted scoreboard with rank badges (1st, 2nd, 3rd)
   - Trophy icon for winner
   - Tap "Share Results" to see formatted text
   - Tap "New Setup" to configure new game
   - Tap "Home" to return to main menu

**Current Mock Data Configuration:**
- Teams: 2 (hardcoded in game_screen.dart)
- Rounds: 5 (hardcoded)
- Duration: 60s (hardcoded)
- Cards: 10 different cards with various topics
- **Note:** Setup screen configuration not yet connected (Phase 2 with Riverpod)
  - Setup screen works and validates inputs
  - But game uses hardcoded values
  - Phase 2 will connect them via state management

**Files to Reference:**
- Main game logic: `lib/presentation/screens/game/game_screen.dart`
- Results screen: `lib/presentation/screens/results/results_screen.dart`
- Mock cards: `lib/data/models/mock_cards.dart`
- All widgets: `lib/presentation/widgets/` and `lib/presentation/screens/*/widgets/`

## Common Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run the app (debug mode)
flutter run

# Run on specific device
flutter devices                    # List available devices
flutter run -d <device-id>        # Run on specific device

# Hot reload during development
# Press 'r' in terminal or save files in IDE

# Hot restart (full restart)
# Press 'R' in terminal
```

### Testing
```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code (static analysis)
flutter analyze

# Format code
dart format lib/ test/

# Check formatting without changes
dart format --output=none --set-exit-if-changed lib/ test/
```

### Building
```bash
# Build APK (Android)
flutter build apk

# Build app bundle (Android - for Play Store)
flutter build appbundle

# Build iOS (requires macOS and Xcode)
flutter build ios

# Build for release with specific flavor
flutter build apk --release
```

## Architecture & Code Organization

### Required Folder Structure
The codebase **must** follow a clean architecture pattern with clear separation of concerns:

```
lib/
├── core/              # Cross-cutting concerns
│   ├── theme/         # App theme, colors, text styles
│   ├── routing/       # Navigation and route definitions
│   └── utils/         # Utilities and helpers
├── data/              # Data layer
│   ├── models/        # Data models (CardItem, etc.)
│   ├── repositories/  # Data access abstractions
│   └── sources/       # Local storage implementation
├── domain/            # Business logic layer
│   ├── entities/      # Domain models (Team, RoundResult)
│   ├── repositories/  # Repository interfaces
│   └── usecases/      # Business logic use cases
└── presentation/      # UI layer
    ├── screens/       # Screen widgets
    ├── widgets/       # Reusable UI components
    └── state/         # State management (providers/blocs)
```

### Key Domain Models

Based on `initial-requrements.md`, the following models are central to the app:

**CardItem:**
- `id`: String
- `promptEn`: String (e.g., "Name European capital cities")
- `answersEn`: List<String> (10-15 possible answers)
- `difficulty`: Enum (EASY, MEDIUM, HARD)
- `source`: String? (optional, e.g., "Source: Wikipedia")

**Team:**
- `id`: String
- `name`: String
- `color`: Color (for UI highlights)
- `score`: int (total correct answers across rounds)

**RoundResult:**
- `roundNumber`: int
- `teamId`: String
- `cardId`: String
- `selectedAnswers`: List<String> (the 10 answers chosen for scoring)
- `foundAnswers`: List<String> (subset of selectedAnswers)
- `pointsEarned`: int
- `isOvertime`: bool

### Game Flow Architecture (✅ FULLY IMPLEMENTED)

**Current Implementation Status:**

1. ✅ **Home Screen** → New Game button
2. ✅ **Setup Screen:**
   - Number of teams (2-4) with dynamic team cards
   - Team names and colors with validation (unique, non-empty)
   - Number of rounds (5/7/10)
   - Difficulty selection (Easy/Medium/Hard/Mixed)
   - Round duration (30/45/60/90 seconds)
3. ✅ **Game Loop (per round):**
   - **Ready Phase**: "Pass device to [Team]" handoff screen
   - **Start Round**: Tap "Ready? Start Round" button
   - Random card selection from mockCards (10 cards)
   - Random 10-answer subset from card's 10-15 answers
   - **Active Gameplay**:
     * Display prompt with difficulty badge
     * Display 10 hidden answer chips (numbered 1-10)
     * Timer counts down (MM:SS format)
     * Visual warnings at 10s (orange) and 5s (red)
     * Tap chips to reveal and mark as found
     * Found counter updates (X/10)
   - **Auto Round End** when:
     * Timer reaches 0, OR
     * All 10 answers found
   - **Round Results Dialog**:
     * Team name and points earned
     * Found vs missed breakdown
     * Expandable answer list with source
     * "Continue" to next round
   - Team rotation (round-robin)
   - Score tracking and updates
4. ⏳ **Final Results:** (In Progress - Day 7)
   - Display scoreboard sorted by score
   - Winner/tie announcement
   - Action buttons (Play Again, New Setup, Share, Home)

**Technical Implementation:**
- File: `lib/presentation/screens/game/game_screen.dart` (344 lines)
- Three game phases: ready, playing, roundEnd (GamePhase enum)
- Timer.periodic for countdown (±1s precision)
- StatefulWidget with local state (Riverpod in Phase 2)
- PopScope prevents accidental back navigation
- Clean widget separation (6 sub-widgets)

### Critical Implementation Rules

**Separation of Concerns:**
- NEVER mix UI code with business logic or data access
- NO network/storage calls directly from UI widgets
- State and logic MUST NOT live inside widget `build()` methods
- NO global mutable state

**Widget Guidelines:**
- Prefer **small, focused, and composable widgets**
- Use **flexible layouts** (`Expanded`, `Flexible`, `Spacer`, `LayoutBuilder`, `MediaQuery`)
- Must adapt to both **phones** and **tablets**
- Avoid absolute positioning unless necessary
- Avoid hard-coded pixel sizes

**State Management:**
- Use modern approach (Riverpod, Bloc, or Provider)
- Be consistent throughout the project
- State must be managed outside widgets

**Logging:**
Use `dart:developer` for logging:
```dart
import 'dart:developer' show log;
log('Message here', name: 'ComponentName');
```

**Card Selection Logic:**
- At runtime, filter cards by selected difficulty
- Choose card pseudo-randomly (avoid repeats within session)
- From card's `answersEn` (10-15 items), randomly select exactly 10 for scoring
- Only these 10 selected answers award points for that round

**Scoring Rules:**
- 1 point per correct answer found (out of 10 selected)
- No negative points for wrong guesses
- Tie-breaker: tied teams play extra rounds until tie is broken

## Design Considerations

### Internationalization
- v1 is **English only**
- Code structure MUST support future locales (use Flutter's i18n patterns)
- All UI strings should be externalized for easy translation

### Accessibility
- Text must be readable on phones and tablets
- Buttons and tappable areas large enough for party play
- Color usage should consider color-blind friendliness (pair colors with labels/icons)

### Performance
- Must run smoothly on mid-range Android and iOS devices
- Timer must be accurate to within ~100ms of real time
- Animations should be lightweight and non-blocking

### Legal & IP
- **DO NOT** copy exact question/card texts from "Πες Βρες"
- **DO NOT** use branding, graphics, or logo assets from the original app
- Use **original English prompts and answers**

## Development Tips

### Timer Implementation
- Timer accuracy is critical (±100ms acceptable)
- Consider using `Timer.periodic` from `dart:async`
- Visual countdown with distinct warning when approaching 0

### Local Storage
- v1 requires no backend
- Store game cards locally (consider JSON assets or SQLite)
- Settings persistence (sound, haptics, theme)

### Platform-Specific Features
- Share functionality: Use OS sharing sheet
- Sound effects: Platform-agnostic audio library
- Haptic feedback: Check platform support

### Testing Strategy
- Widget tests for UI components
- Unit tests for game logic (scoring, card selection, timer)
- Integration tests for game flow
- Test on both phone and tablet form factors
