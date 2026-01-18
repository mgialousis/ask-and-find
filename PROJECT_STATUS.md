# Say & Find - Project Status

**Last Updated:** 2026-01-18

## Quick Summary

- **Phase:** Phase 2+ - Functional Game with Enhanced Features
- **Progress:** Core gameplay COMPLETE with major improvements!
- **Status:** Fully playable party trivia game
- **Files:** 40+ files (8,000+ lines)
- **Code Quality:** All files pass `flutter analyze`
- **Tests:** All tests passing

## What Works Right Now

### Fully Functional Game Features

1. **Home Screen** - Navigate to all sections
2. **How to Play** - Full game instructions
3. **Settings** - Sound, haptics, dark mode toggles (persisted)
4. **Setup Screen** - Configure teams (2-4) and game settings:
   - Team names and colors (with duplicate prevention)
   - Number of rounds (5/7/10)
   - Timer duration (30/45/60/90 seconds)
   - Difficulty level (Easy/Medium/Hard)

5. **Game Loop** - Complete gameplay from start to finish:
   - Team handoff screens ("Pass device to Team X")
   - Timer countdown with visual warnings (orange at 10s, red at 5s)
   - **All answers visible from start** (no hidden numbers!)
   - **Tap to select/deselect answers** (toggle behavior)
   - **Difficulty-based scoring:**
     - Easy: 1 point per answer
     - Medium: 2 points per answer
     - Hard: 3 points per answer
   - **Per-answer point values** shown on each chip
   - **End Round button** to finish early
   - **End Game button** to skip remaining rounds
   - Team rotation (all teams play each round)

6. **Round Results Dialog**:
   - Points earned with found/missed breakdown
   - **"Scores So Far"** showing all team standings
   - **Toggle answers** to fix mistakes (adjusts score!)
   - **End Game** button to skip to final results
   - Source attribution for each question

7. **Results Screen** - Final game results:
   - Winner announcement (or tie detection)
   - Sorted scoreboard with rank badges
   - Trophy icons for top 3
   - Share results functionality
   - Play Again / New Setup / Home navigation

### Recent Major Improvements

- **Visible Answers:** All 10 answers shown from start (not hidden behind numbers)
- **Toggle Selection:** Tap to select (green checkmark), tap again to deselect
- **Difficulty Scoring:** Points vary by difficulty (1/2/3 pts per answer)
- **Point Display:** Each answer chip shows its point value
- **Team Rotation Fixed:** All teams play in each round before advancing
- **Early Exit Options:** End Round and End Game buttons added
- **Score Adjustment:** Can toggle answers on results dialog to fix mistakes
- **Scores So Far:** Round results show current team standings
- **Removed "Mixed" Difficulty:** Only Easy/Medium/Hard options now

## Game Flow

### With 2 Teams, 3 Rounds:
```
Round 1:
  → Team A plays (timer, select answers, see results)
  → Team B plays (timer, select answers, see results)
Round 2:
  → Team A plays
  → Team B plays
Round 3:
  → Team A plays
  → Team B plays
→ Final Results Screen (6 total plays)
```

### Scoring Example (Medium Difficulty):
- Each answer = 2 points
- Find 7 of 10 answers = 14 points
- Find all 10 = 20 points

## Cards Database

- **25 question cards** with varied topics
- **Easy:** Days of week, pets, months, US states, body parts, colors, fruits, countries
- **Medium:** Planets, capitals, programming languages, Olympic sports, movies, instruments, cars, artists
- **Hard:** Shakespeare plays, chemical elements, state capitals, Nobel prizes, Greek gods, algorithms, constellations

## How to Test

```bash
# Run the app
flutter run

# On physical device
flutter run -d <device-id> --release

# Test complete flow:
# 1. Home → New Game
# 2. Configure teams (2-4), rounds, timer, difficulty
# 3. Start Game
# 4. Play through rounds (all answers visible, tap to select)
# 5. Verify team rotation (all teams play each round)
# 6. Test End Round / End Game buttons
# 7. Check final results
```

## Key Files

### Critical Files
1. `lib/presentation/screens/game/game_screen.dart` - Main game logic
2. `lib/presentation/screens/setup/setup_screen.dart` - Setup configuration
3. `lib/presentation/state/game_state_provider.dart` - Game orchestration
4. `assets/cards.json` - Question database

### Architecture
```
lib/
├── core/                   # Theme, routing, utils
├── domain/entities/        # Team, CardItem, Difficulty, GameConfig
├── data/
│   ├── models/             # Mock data
│   └── repositories/       # Cards repository
└── presentation/
    ├── state/              # Riverpod providers
    │   ├── settings_provider.dart
    │   ├── game_setup_provider.dart
    │   ├── timer_provider.dart
    │   └── game_state_provider.dart
    ├── screens/            # All screens
    └── widgets/            # Reusable components
```

## Known Issues

**None** - All implemented features working as designed.

## What's Next (Phase 3+)

- Card repository with JSON asset loading
- Game history tracking
- Animations and polish
- Sound effects
- Haptic feedback
- Comprehensive testing

## Quick Commands

```bash
flutter analyze        # Check code quality
flutter test          # Run tests
flutter run           # Run the app
flutter run --release # Run in release mode
```

## Recent Commits

1. **Functional Stage of APP** - Major updates including team rotation fix, enhanced round results, cards database expansion
2. **Add early exit options** - End Round and End Game buttons
3. **Fix team rotation** - Teams now alternate within each round
4. **Major gameplay improvements** - Visible answers, toggle selection, difficulty scoring
5. **Add testing content** - 15 new question cards + mobile testing guide
6. **Navigation fixes** - Route names properly configured

---

**Bottom Line:** Fully playable party trivia game! All core features working. Visible answers, toggle selection, difficulty-based scoring, proper team rotation, early exit options, and score adjustment on results. Ready for polish and content expansion!
