# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Quick Status:** 🎉 FEATURE COMPLETE + User Submissions + Analytics! 75 cards, confetti, animations, sounds, haptics, community card submissions (Google Sheets), PostHog analytics with privacy controls, bilingual (EN/ES).

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
- Target platforms: Android (JVM 17, Kotlin 1.9) and iOS
- Local storage: SharedPreferences for settings and offline queue
- Backend: Google Sheets API for user submissions (gsheets ^0.5.0)
- Analytics: PostHog (posthog_flutter ^4.10.0) with opt-out support
- State management: Riverpod (flutter_riverpod ^2.4.0)
- Navigation: go_router (^12.0.0)
- Connectivity: connectivity_plus ^6.0.0
- App info: package_info_plus ^8.1.0
- Environment config: flutter_dotenv ^5.1.0

## Implementation Status

**Current Phase:** Phase 4 - Day 12+ COMPLETE! 🎉

### Day 12+ Achievements (User Submissions + Analytics):
- ✅ **Submit New Cards** - Users can propose new trivia cards with 10 answers
- ✅ **Report Issues** - Users can report problems with existing cards
- ✅ **Google Sheets Backend** - Submissions stored in Google Spreadsheet
- ✅ **Offline Support** - Submissions queued locally when offline, synced when online
- ✅ **Card Preview** - Real-time preview while composing submissions
- ✅ **Bilingual Support** - Full English and Spanish localization for submission UI
- ✅ **Settings Integration** - Community section in Settings screen
- ✅ **Round Result Integration** - Report Issue button after each round
- ✅ **PostHog Analytics** - Anonymous usage tracking with user opt-out
- ✅ **Privacy Settings** - Analytics toggle in Settings > Privacy section
- ✅ **Build Scripts** - Android and iOS build scripts with analytics config

### Day 11 Achievements (Polish & Testing):
- ✅ **Answer Chip Animation** - Satisfying bounce/scale effect on tap
- ✅ **Timer Pulse Animation** - Continuous pulse when < 10s, faster when < 5s
- ✅ **Sound Effects** - Selection sounds, countdown warnings, round end sounds
- ✅ **Haptic Feedback** - Light impact on answer tap, heavy on round end
- ✅ **Comprehensive Test Suite** - 99 tests passing across 5 test files

### Test Coverage:
```
test/
├── widget_test.dart                    # Basic app test
├── l10n/
│   └── localization_test.dart          # Localization tests
├── providers/
│   ├── timer_provider_test.dart        # 22 tests
│   ├── game_state_provider_test.dart   # 36 tests
│   └── submission_provider_test.dart   # Submission provider tests
├── widgets/
│   ├── answer_chip_test.dart           # 3 tests
│   └── timer_display_test.dart         # 16 tests
└── screens/
    └── setup_screen_test.dart          # 34 tests
```

### Core Features Complete:
- ✅ **All Answers Visible** - No hidden numbers, all 10 answers shown from start
- ✅ **Toggle Selection** - Tap to select (green), tap again to deselect
- ✅ **Difficulty Scoring** - Easy (1pt), Medium (2pts), Hard (3pts) per answer
- ✅ **Per-Answer Points** - Point value shown on each chip
- ✅ **Team Rotation** - All teams play within each round before advancing
- ✅ **Early Exit** - End Round and End Game buttons available
- ✅ **Score Adjustment** - Can toggle answers on results to fix mistakes
- ✅ **Scores So Far** - Round results show current team standings
- ✅ **75 Question Cards** - Varied topics across all difficulties
- ✅ **Results Confetti** - Celebration animation on winner screen
- ✅ **User Submissions** - Submit new cards or report issues via Google Sheets
- ✅ **Offline Queue** - Submissions saved locally when offline, auto-synced
- ✅ **Analytics** - PostHog integration with privacy-respecting opt-out
- ✅ **Privacy Controls** - Users can disable analytics in Settings

### What's Working:
1. **Home Screen** - Navigation to all sections
2. **Settings** - Sound, haptics, dark mode, Privacy section (analytics toggle), Community section
3. **Setup Screen** - Teams (2-4), rounds (5/7/10), timer (30/45/60/90s), difficulty (Easy/Medium/Hard)
4. **Game Loop** - Complete with visible answers, toggle selection, point display, animations
5. **Round Results** - Points, scores so far, answer toggle, End Game option, Report Issue button
6. **Final Results** - Winner announcement, scoreboard, Play Again
7. **Card Submission** - Submit new cards with 10 answers, difficulty, optional source
8. **Issue Reporting** - Report problems with existing cards, select card, describe issue
9. **Analytics** - PostHog event tracking (settings changes, game events), user opt-out supported

### Important Notes for Claude:
- **99+ tests passing** - Run `flutter test` to verify
- **Answer chip animation** - Bounce effect in `lib/presentation/widgets/game/answer_chip.dart`
- **Timer pulse animation** - Continuous pulse in `lib/presentation/screens/game/widgets/timer_display.dart`
- **Sound effects** - Integrated in `game_screen.dart` via audioplayers
- **Haptic feedback** - HapticFeedback.lightImpact/heavyImpact on actions
- **User submissions** - Google Sheets config in `lib/core/config/sheets_config.dart`
- **Offline queue** - Pending submissions stored via SharedPreferences
- **Card submissions require exactly 10 answers** - Validation enforced in forms
- **Analytics** - PostHog config via environment variables (see `lib/core/config/analytics_config.dart`)
- **Privacy** - Analytics opt-out via Settings > Privacy, persisted in SharedPreferences
- All files pass `flutter analyze` with no issues

**Completed:**
- ✅ Manual testing on physical device
- ✅ 75 question cards (expanded from 25)
- ✅ Results screen confetti animation

**Optional Remaining:**
- ⏳ Performance profiling
- ⏳ Tie-breaker/overtime rounds
- ⏳ Dark mode implementation
- ⏳ App store preparation
- ⏳ Google Sheets credentials setup (see `lib/core/config/sheets_config.dart`)

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
- Cards: 75 question cards with varied topics

**App Routes (go_router):**
- `/` - Home screen
- `/setup` - Game setup
- `/game` - Active gameplay
- `/results` - Final results
- `/settings` - App settings (includes Community section)
- `/how-to-play` - Instructions
- `/submit-card` - Submit new card form
- `/report-issue` - Report issue form (accepts CardItem as extra)
- `/submission-success` - Submission confirmation

**Files to Reference:**
- Main game logic: `lib/presentation/screens/game/game_screen.dart`
- Game state: `lib/presentation/state/game_state_provider.dart`
- Cards database: `assets/cards.json`
- Results screen: `lib/presentation/screens/results/results_screen.dart`
- Submission screen: `lib/presentation/screens/submission/card_submission_screen.dart`
- Submission state: `lib/presentation/state/submission_provider.dart`
- Google Sheets config: `lib/core/config/sheets_config.dart`
- Offline storage: `lib/data/sources/offline_submissions_storage.dart`
- Analytics service: `lib/core/analytics/analytics_service.dart`
- Analytics config: `lib/core/config/analytics_config.dart`
- Settings state: `lib/presentation/state/settings_provider.dart`
- Preferences keys: `lib/core/config/preferences_keys.dart`

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
# Build APK (Android) - simple
flutter build apk

# Build APK with analytics (Android) - using build script
POSTHOG_API_KEY=your_key scripts/android_build.sh --release

# Build app bundle (Android - for Play Store)
flutter build appbundle

# Build iOS (requires macOS and Xcode) - using build script
scripts/ios_deploy.sh --release

# Build for release with specific flavor
flutter build apk --release

# Build with analytics environment variables
flutter build apk --dart-define=POSTHOG_API_KEY=your_key --dart-define=POSTHOG_HOST=https://app.posthog.com
```

## Architecture & Code Organization

### Required Folder Structure
The codebase **must** follow a clean architecture pattern with clear separation of concerns:

```
lib/
├── core/              # Cross-cutting concerns
│   ├── theme/         # App theme, colors, text styles
│   ├── routing/       # Navigation and route definitions
│   ├── config/        # Configuration (sheets_config, analytics_config, preferences_keys)
│   ├── analytics/     # Analytics service (PostHog integration)
│   └── utils/         # Utilities and helpers
├── data/              # Data layer
│   ├── models/        # Data models (CardItem, etc.)
│   ├── repositories/  # Data access (cards_repository, submissions_repository)
│   └── sources/       # Storage (google_sheets_service, offline_submissions_storage)
├── domain/            # Business logic layer
│   ├── entities/      # Domain models (Team, RoundResult, CardSubmission)
│   ├── repositories/  # Repository interfaces
│   └── usecases/      # Business logic use cases
└── presentation/      # UI layer
    ├── screens/       # Screen widgets
    │   ├── game/      # Game screens
    │   ├── submission/# Card submission screens and widgets
    │   └── ...        # Other screens
    ├── widgets/       # Reusable UI components
    └── state/         # State management (providers including submission_provider)

scripts/               # Build and utility scripts
├── android_build.sh   # Android APK build with analytics config
├── ios_deploy.sh      # iOS build and deployment
└── flag_language_sensitive_cards.py  # Card localization helper
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

**CardSubmission:** (for user-submitted cards/corrections)
- `id`: String (UUID)
- `type`: SubmissionType (newCard, correction)
- `submittedAt`: DateTime
- For new cards: `promptEn`, `answersEn` (exactly 10), `difficulty`, `source`
- For corrections: `existingCardId`, `existingCardPrompt`, `issueType`, `issueDescription`
- Optional: `submitterName`, `submitterEmail`, `appVersion`, `locale`

**IssueType:** (for corrections)
- `wrongAnswer` - An answer is incorrect or missing
- `outdatedInfo` - The card uses outdated facts
- `spellingGrammar` - Spelling or grammar needs correction
- `unclearQuestion` - The prompt is confusing or ambiguous
- `other` - Something else needs attention

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
- **English and Spanish** fully supported
- Localization files: `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`
- Language selection in Settings screen
- All UI strings externalized using Flutter's i18n patterns
- Submission feature includes ~40 localization strings per language

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
- Game cards stored in `assets/cards.json`
- Settings persistence via SharedPreferences (sound, haptics, theme, locale)
- Offline submissions queue stored in SharedPreferences

### User Submissions (Google Sheets Backend)
- Submissions sent to Google Sheets via `gsheets` package
- Requires Google Cloud service account credentials in `sheets_config.dart`
- Two sheets: "New Card Submissions" and "Card Corrections"
- Offline support: submissions queued locally, auto-synced when online
- Connectivity monitored via `connectivity_plus` package
- App version captured via `package_info_plus` package

### Analytics (PostHog)
- PostHog integration via `posthog_flutter` package
- Configuration via environment variables at build time:
  - `POSTHOG_API_KEY` - Your PostHog project API key
  - `POSTHOG_HOST` - PostHog host (default: https://app.posthog.com)
  - `POSTHOG_ALLOW_DEBUG` - Enable analytics in debug builds (default: false)
- User opt-out: Settings > Privacy > Analytics toggle
- Events captured: settings changes, game events (with anonymous device ID)
- Super properties: app_version, platform, os_version, locale, timezone
- Analytics disabled if API key is empty or user opts out

### Platform-Specific Features
- Share functionality: Use OS sharing sheet
- Sound effects: Platform-agnostic audio library
- Haptic feedback: Check platform support

### Testing Strategy
- Widget tests for UI components
- Unit tests for game logic (scoring, card selection, timer)
- Integration tests for game flow
- Test on both phone and tablet form factors

### Android Build Configuration
The project uses JVM 17 and Kotlin 1.9 for Android builds. This is configured in:
- `android/app/build.gradle.kts` - App-level Java/Kotlin settings
- `android/build.gradle.kts` - Project-level settings applied to all subprojects

Key configuration (in `android/build.gradle.kts`):
```kotlin
gradle.projectsEvaluated {
    allprojects {
        tasks.withType<KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(JvmTarget.JVM_17)
                languageVersion.set(KotlinVersion.KOTLIN_1_9)
                apiVersion.set(KotlinVersion.KOTLIN_1_9)
            }
        }
        tasks.withType<JavaCompile>().configureEach {
            sourceCompatibility = "17"
            targetCompatibility = "17"
        }
    }
}
```

This ensures all Flutter plugins (like `audioplayers_android`, `posthog_flutter`) compile with consistent JVM targets.
