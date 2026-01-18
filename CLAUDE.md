# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Quick Status:** 🎉 FULLY FUNCTIONAL GAME! All core features working. See `PROJECT_STATUS.md` for detailed status.

## Project Overview

"Say & Find" (Pes Vres) is a **local multiplayer party trivia game** built with Flutter. It's an English version of the Greek game "Πες Βρες!" where 2-4 teams compete to identify items from visible lists before a timer expires.

**Core Gameplay:**
- Single-device, pass-and-play format
- 2-4 teams competing in rounds
- Each round: a team sees 10 answers and taps to select the ones they identify
- **All answers visible from start** (tap to select/deselect)
- **Difficulty-based scoring:**
  - Easy: 1 point per answer
  - Medium: 2 points per answer
  - Hard: 3 points per answer
- Configurable difficulty levels (Easy/Medium/Hard) and round duration (30/45/60/90 seconds)
- Team rotation: all teams play within each round before advancing

**Tech Stack:**
- Flutter (SDK: ^3.10.4)
- Target platforms: Android and iOS
- Local storage only (no backend for v1)
- State management: Riverpod (flutter_riverpod ^2.4.0)
- Navigation: go_router (^12.0.0)

## Implementation Status

**Current Status:** 🎉 FULLY FUNCTIONAL GAME with enhanced features!

### Core Features Complete:
- ✅ **All Answers Visible** - No hidden numbers, all 10 answers shown from start
- ✅ **Toggle Selection** - Tap to select (green), tap again to deselect
- ✅ **Difficulty Scoring** - Easy (1pt), Medium (2pts), Hard (3pts) per answer
- ✅ **Per-Answer Points** - Point value shown on each chip
- ✅ **Team Rotation** - All teams play within each round before advancing
- ✅ **Early Exit** - End Round and End Game buttons available
- ✅ **Score Adjustment** - Can toggle answers on results to fix mistakes
- ✅ **Scores So Far** - Round results show current team standings
- ✅ **25 Question Cards** - Varied topics across all difficulties

### What's Working:
1. **Home Screen** - Navigation to all sections
2. **Settings** - Sound, haptics, dark mode (persisted)
3. **Setup Screen** - Teams (2-4), rounds (5/7/10), timer (30/45/60/90s), difficulty (Easy/Medium/Hard)
4. **Game Loop** - Complete with visible answers, toggle selection, point display
5. **Round Results** - Points, scores so far, answer toggle, End Game option
6. **Final Results** - Winner announcement, scoreboard, Play Again

### Important Notes for Claude:
- **"Mixed" difficulty removed** - Only Easy/Medium/Hard options
- **Cards database** - `assets/cards.json` with per-answer point values
- **Team rotation** - All teams play each round before incrementing round number
- **Toggle behavior** - Answers can be selected/deselected during play AND on results
- All files pass `flutter analyze` with no issues

**What's Next (Phase 3+):**
- ⏳ Animations and polish
- ⏳ Sound effects
- ⏳ Haptic feedback
- ⏳ More question cards
- ⏳ Comprehensive testing

### What Can Be Tested Right Now

**Fully Functional Gameplay (End-to-End):**

1. **Run the app**: `flutter run`
2. **Navigate**: Home → Tap "New Game"
3. **Setup Game**:
   - Select number of teams (2, 3, or 4)
   - Customize team names and colors
   - Choose rounds (5/7/10), timer (30/45/60/90s), difficulty (Easy/Medium/Hard)
   - Tap "Start Game"
4. **Play Game**:
   - See "Pass device to Team X" screen
   - Tap "Ready? Start Turn"
   - Timer starts counting down
   - **All 10 answers visible** with point values (e.g., "France (1 pt)")
   - **Tap to select** (turns green with checkmark)
   - **Tap again to deselect** (back to gray)
   - Timer turns orange at 10s, red at 5s
   - **"End Turn" button** to finish early
5. **View Round Results**:
   - See points earned based on difficulty
   - **"Scores So Far"** showing all team standings
   - Tap "Show Answers" to see found/missed
   - **Tap answers to toggle** selection (adjusts score!)
   - **"End Game"** to skip remaining rounds
   - Tap "Continue" for next team
6. **Team Rotation**:
   - All teams play within each round
   - Round number advances after all teams play
7. **Final Results**:
   - Winner announcement (or "It's a Tie!")
   - Sorted scoreboard with rank badges
   - Play Again / New Setup / Home buttons

**Configuration Options:**
- Teams: 2-4 (fully configurable)
- Rounds: 5, 7, or 10
- Timer: 30s, 45s, 60s, or 90s
- Difficulty: Easy (1pt), Medium (2pts), Hard (3pts)
- Cards: 25 question cards with varied topics

**Files to Reference:**
- Main game logic: `lib/presentation/screens/game/game_screen.dart`
- Game state: `lib/presentation/state/game_state_provider.dart`
- Cards database: `assets/cards.json`
- Results screen: `lib/presentation/screens/results/results_screen.dart`

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
   - Difficulty selection (Easy/Medium/Hard)
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
