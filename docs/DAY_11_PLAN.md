# Day 11 - Polish & Testing Phase

**Date:** Next Development Session
**Focus:** Polish, Haptics, and Testing

---

## Current State Assessment

### What's Working:
- ✅ Full gameplay loop functional
- ✅ JSON-backed question cards
- ✅ Visible answers with toggle selection
- ✅ Per-answer scoring (1-5 points)
- ✅ Team rotation (all teams per round)
- ✅ End Round / End Game buttons
- ✅ Score adjustment on results
- ✅ Settings persistence
- ✅ Navigation working
- ✅ Countdown ticks (10s) and end-of-timer beep

### What Needs Work:
- ⚠️ Haptic feedback (setting exists, not implemented)
- ⚠️ Limited test coverage (only 1 basic test)
- ⚠️ No animations for transitions

---

## Day 11 Tasks

### Task 1: Implement Haptic Feedback (Priority: MEDIUM)
**Time Estimate:** 30 minutes

**Current State:**
- Settings toggle for haptics exists
- No haptic implementation

**Actions:**
1. Add HapticFeedback to answer taps:
   ```dart
   import 'package:flutter/services.dart';

   void _onAnswerTap(String answer) {
     if (settingsState.hapticEnabled) {
       HapticFeedback.lightImpact();
     }
     // ... existing code
   }
   ```

2. Add haptics to key interactions:
   - Answer selection/deselection
   - Timer warnings (heavier impact at 5s)
   - Round end
   - Button presses

**Files to modify:**
- `lib/presentation/screens/game/game_screen.dart`

---

### Task 2: Add Basic Animations (Priority: MEDIUM)
**Time Estimate:** 1 hour

**Actions:**
1. Answer chip selection animation:
   - Scale bounce on tap
   - Color fade transition

2. Timer warning animation:
   - Pulse effect when < 10s
   - Shake effect when < 5s

3. Score update animation:
   - Number counting up effect
   - Trophy bounce on winner

**Files to modify:**
- `lib/presentation/widgets/game/answer_chip.dart`
- `lib/presentation/screens/game/widgets/timer_display.dart`
- `lib/presentation/screens/results/results_screen.dart`

---

### Task 3: Expand Test Coverage (Priority: HIGH)
**Time Estimate:** 1.5 hours

**Current State:**
- Only 1 basic widget test
- No provider tests
- No integration tests

**Actions:**

1. **Provider Unit Tests** (`test/providers/`):
   ```dart
   // test/providers/game_state_provider_test.dart
   - Test initial state
   - Test startRound()
   - Test toggleAnswer()
   - Test endRound() scoring
   - Test team rotation
   ```

2. **Widget Tests** (`test/widgets/`):
   ```dart
   // test/widgets/answer_chip_test.dart
   - Test unselected state
   - Test selected state
   - Test tap toggles state

   // test/widgets/timer_display_test.dart
   - Test time formatting
   - Test warning colors
   ```

3. **Screen Tests** (`test/screens/`):
   ```dart
   // test/screens/setup_screen_test.dart
   - Test team count selection
   - Test validation
   - Test start game navigation
   ```

**New test files to create:**
- `test/providers/game_state_provider_test.dart`
- `test/providers/timer_provider_test.dart`
- `test/widgets/answer_chip_test.dart`
- `test/screens/setup_screen_test.dart`

---

### Task 4: UX Polish (Priority: LOW)
**Time Estimate:** 30 minutes

**Actions:**
1. Loading state during card loading
2. Empty state handling
3. Error state handling
4. Confirmation dialogs for End Game

---

## Recommended Order

1. **Haptic Feedback** - Quick win, enhances feel
2. **Test Coverage** - Important for stability
3. **Animations** - Nice to have, time permitting
4. **UX Polish** - If time allows

---

## Files Summary

### Files to Create:
- `test/providers/game_state_provider_test.dart`
- `test/providers/timer_provider_test.dart`
- `test/widgets/answer_chip_test.dart`

### Files to Modify:
- `lib/presentation/screens/game/game_screen.dart` (haptics)
- `lib/presentation/widgets/game/answer_chip.dart` (animations)

---

## Success Criteria

At end of Day 11:
- [ ] Haptic feedback on taps (if haptics enabled)
- [ ] At least 5 new test files with meaningful coverage
- [ ] Basic animations on answer selection
- [ ] All existing tests still pass
- [ ] No new flutter analyze warnings

---

## Alternative Focus: Content & Testing Only

If you prefer to skip polish for now:

### Option A: Testing Focus
1. Write comprehensive provider tests
2. Write widget tests for all components
3. Write integration tests for game flow
4. Aim for 80%+ code coverage

### Option B: Content Focus
1. Review and improve existing 100 cards
2. Add per-answer point values to all cards
3. Balance difficulty across categories
4. Add more variety to topics

---

## Quick Start Commands

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run on device
flutter run -d <device-id> --release
```

---

**Choose your focus and let me know which tasks you want to tackle!**
