plea# Day 11 Detailed Implementation Plan

**Date:** 2026-01-18
**Focus:** Polish & Feel - Animations and Testing

---

## Current State Summary

### Already Completed (Sound & Haptics)

| Feature | Status | Implementation |
|---------|--------|----------------|
| Sound assets | ✅ Done | `assets/sounds/countdown_tick.wav`, `timer_end.wav` |
| Timer countdown sounds | ✅ Done | Plays tick with increasing volume (0.2→1.0) for last 10s |
| Timer end sound | ✅ Done | Plays `timer_end.wav` at full volume |
| Answer selection sound | ✅ Done | Plays `countdown_tick.wav` at 0.5 volume on tap |
| Haptic feedback | ✅ Done | Light impact on answer tap, respects settings |

### Remaining Tasks

| Task | Priority | Complexity | Time Estimate |
|------|----------|------------|---------------|
| Answer chip selection animation | HIGH | Medium | ✅ Done |
| Timer continuous pulse animation | MEDIUM | Medium | ✅ Done |
| Results screen animations | LOW | High | ✅ Done |
| Comprehensive test coverage | HIGH | Medium | In progress (widget tests added) |

---

## Task 1: Answer Chip Selection Animation

**Priority:** HIGH
**Complexity:** Medium
**Estimated Time:** 45 minutes

### Current State
- `lib/presentation/widgets/game/answer_chip.dart` (110 lines)
- StatelessWidget with no animations
- Uses Material + InkWell for tap feedback
- Changes color and shows checkmark on selection

### Goal
Add a satisfying bounce/scale animation when an answer chip is tapped.

### Implementation Approach

**Option A: Convert to StatefulWidget with AnimationController (Recommended)**

```dart
class AnswerChip extends StatefulWidget {
  // ... same constructor
}

class _AnswerChipState extends State<AnswerChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  // Build with ScaleTransition wrapping the Material widget
}
```

**Option B: Use TweenAnimationBuilder (Simpler but less control)**

```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 1.0, end: isSelected ? 1.05 : 1.0),
  duration: const Duration(milliseconds: 200),
  curve: Curves.elasticOut,
  builder: (context, scale, child) {
    return Transform.scale(scale: scale, child: child);
  },
  child: Material(...),
)
```

### Files to Modify
- `lib/presentation/widgets/game/answer_chip.dart`

### Testing Criteria
- [ ] Chip visually bounces on tap
- [ ] Animation completes before state change
- [ ] Works smoothly at 60fps
- [ ] No janky behavior with rapid taps

---

## Task 2: Timer Continuous Pulse Animation

**Priority:** MEDIUM
**Complexity:** Medium
**Estimated Time:** 30 minutes

### Current State
- `lib/presentation/screens/game/widgets/timer_display.dart` (91 lines)
- Uses TweenAnimationBuilder for one-time scale change
- Scales from 1.0 to 1.1 when `_isWarning` (< 10s)
- Has box shadow effect when warning
- Color changes: primary → warning (orange) → error (red)

### Problem
The current animation only triggers once when entering warning state. It doesn't pulse continuously.

### Goal
Create a continuous pulsing effect when timer is in warning state (< 10s), with more intense pulsing when critical (< 5s).

### Implementation Approach

**Convert to StatefulWidget with repeating animation:**

```dart
class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key, required this.secondsRemaining});
  final int secondsRemaining;

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool get _isWarning => widget.secondsRemaining <= 10;
  bool get _isCritical => widget.secondsRemaining <= 5;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_pulseController);
  }

  @override
  void didUpdateWidget(TimerDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updatePulseAnimation();
  }

  void _updatePulseAnimation() {
    if (_isCritical) {
      // Faster pulsing when critical
      _pulseController.duration = const Duration(milliseconds: 300);
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else if (_isWarning) {
      // Normal pulsing when warning
      _pulseController.duration = const Duration(milliseconds: 500);
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      // Stop pulsing
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(/* existing container code */),
    );
  }
}
```

### Files to Modify
- `lib/presentation/screens/game/widgets/timer_display.dart`

### Testing Criteria
- [ ] Timer pulses continuously when < 10s
- [ ] Pulse speed increases when < 5s
- [ ] Pulsing stops when timer resets
- [ ] No memory leaks (controller properly disposed)
- [ ] Smooth 60fps animation

---

## Task 3: Results Screen Animations (Optional)

**Priority:** LOW
**Complexity:** High
**Estimated Time:** 1 hour

### Current State
- `lib/presentation/screens/results/results_screen.dart` (285 lines)
- ConsumerWidget with static display
- Winner announcement with icon
- Scoreboard with ranks

### Goal
Add celebratory animations:
1. Confetti effect for winner
2. Animated score counting
3. Staggered fade-in for scoreboard items

### Implementation Approach

**Option A: Add confetti package**

```yaml
# pubspec.yaml
dependencies:
  confetti: ^0.7.0
```

```dart
class ResultsScreen extends ConsumerStatefulWidget {
  // ...
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Auto-play confetti on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Existing scaffold content
        Scaffold(...),
        // Confetti overlay
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            colors: [Colors.red, Colors.blue, Colors.green, Colors.yellow],
          ),
        ),
      ],
    );
  }
}
```

**Option B: Animated score counting**

```dart
TweenAnimationBuilder<int>(
  tween: IntTween(begin: 0, end: winners.first.score),
  duration: const Duration(milliseconds: 1500),
  curve: Curves.easeOut,
  builder: (context, value, child) {
    return Text(
      '$value ${value == 1 ? 'point' : 'points'}',
      style: TextStyle(...),
    );
  },
)
```

### Files to Modify
- `lib/presentation/screens/results/results_screen.dart`
- `lib/presentation/screens/results/scoreboard_widget.dart`
- `pubspec.yaml` (if adding confetti package)

### Testing Criteria
- [ ] Confetti plays on results screen load
- [ ] Score counts up from 0 to final value
- [ ] Animations don't block user interaction
- [ ] Performance acceptable on mid-range devices

---

## Task 4: Comprehensive Test Coverage

**Priority:** HIGH
**Complexity:** Medium
**Estimated Time:** 1.5 hours

### Current State
- Only 1 test file: `test/widget_test.dart`
- Single test: "App launches successfully"
- No provider tests, no unit tests for game logic

### Goal
Add meaningful test coverage for critical components:
1. Provider unit tests
2. Widget tests for key components
3. Game logic tests

### Test Files to Create

#### 1. `test/providers/game_state_provider_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/presentation/state/game_state_provider.dart';

void main() {
  group('GameStateProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is ready phase', () {
      final state = container.read(gameStateProvider);
      expect(state.gamePhase, GamePhase.ready);
      expect(state.currentRound, 1);
      expect(state.currentTeamIndex, 0);
    });

    test('toggleAnswer adds answer to foundAnswers', () {
      final notifier = container.read(gameStateProvider.notifier);
      // Setup: start a round first
      // notifier.startRound();
      // notifier.beginTurn();
      // notifier.toggleAnswer('Test Answer');
      // expect(container.read(gameStateProvider).foundAnswers, contains('Test Answer'));
    });

    test('endRound calculates score correctly', () {
      // Test scoring logic
    });

    test('team rotation works correctly', () {
      // Test that teams rotate properly within a round
    });
  });
}
```

#### 2. `test/providers/timer_provider_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/presentation/state/timer_provider.dart';

void main() {
  group('TimerProvider', () {
    test('initial state has 0 seconds and is not running', () {
      final container = ProviderContainer();
      final state = container.read(timerProvider);
      expect(state.secondsRemaining, 0);
      expect(state.isRunning, false);
      container.dispose();
    });

    test('start sets correct duration and begins countdown', () async {
      final container = ProviderContainer();
      container.read(timerProvider.notifier).start(60);

      final state = container.read(timerProvider);
      expect(state.secondsRemaining, 60);
      expect(state.isRunning, true);

      container.dispose();
    });

    test('pause stops the timer', () {
      // Test pause functionality
    });

    test('reset clears timer state', () {
      // Test reset functionality
    });
  });
}
```

#### 3. `test/widgets/answer_chip_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/presentation/widgets/game/answer_chip.dart';

void main() {
  group('AnswerChip', () {
    testWidgets('displays answer text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnswerChip(
              answer: 'Test Answer',
              state: AnswerChipState.unselected,
              onTap: () {},
              pointValue: 2,
            ),
          ),
        ),
      );

      expect(find.text('Test Answer'), findsOneWidget);
      expect(find.textContaining('2 pts'), findsOneWidget);
    });

    testWidgets('shows checkmark when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnswerChip(
              answer: 'Test Answer',
              state: AnswerChipState.selected,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnswerChip(
              answer: 'Test Answer',
              state: AnswerChipState.unselected,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AnswerChip));
      expect(wasTapped, true);
    });
  });
}
```

#### 4. `test/widgets/timer_display_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/presentation/screens/game/widgets/timer_display.dart';

void main() {
  group('TimerDisplay', () {
    testWidgets('formats time correctly (MM:SS)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(secondsRemaining: 65),
          ),
        ),
      );

      expect(find.text('01:05'), findsOneWidget);
    });

    testWidgets('shows warning state when under 10 seconds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(secondsRemaining: 8),
          ),
        ),
      );

      // Timer should have warning styling
      expect(find.text('00:08'), findsOneWidget);
    });

    testWidgets('shows critical state when under 5 seconds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(secondsRemaining: 3),
          ),
        ),
      );

      expect(find.text('00:03'), findsOneWidget);
    });
  });
}
```

#### 5. `test/screens/setup_screen_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pes_vres/presentation/screens/setup/setup_screen.dart';

void main() {
  group('SetupScreen', () {
    testWidgets('shows team count selector', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SetupScreen(),
          ),
        ),
      );

      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('shows correct number of team cards', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SetupScreen(),
          ),
        ),
      );

      // Default is 2 teams
      expect(find.text('Team 1'), findsOneWidget);
      expect(find.text('Team 2'), findsOneWidget);
    });

    testWidgets('validates empty team names', (tester) async {
      // Test validation logic
    });
  });
}
```

### Test Directory Structure

```
test/
├── widget_test.dart              # Existing - app launch test
├── providers/
│   ├── game_state_provider_test.dart
│   ├── timer_provider_test.dart
│   └── game_setup_provider_test.dart
├── widgets/
│   ├── answer_chip_test.dart
│   └── timer_display_test.dart
└── screens/
    └── setup_screen_test.dart
```

### Testing Criteria
- [ ] All tests pass with `flutter test`
- [ ] Provider tests cover initial state, mutations, and edge cases
- [ ] Widget tests verify rendering and interactions
- [ ] No flaky tests (consistent pass/fail)

---

## Implementation Order (Recommended)

### Phase 1: Quick Wins (1 hour)
1. **Answer Chip Animation** - Most noticeable improvement
2. **Timer Pulse Animation** - Enhances tension in gameplay

### Phase 2: Testing Foundation (1.5 hours)
3. **Provider Tests** - Critical for stability
4. **Widget Tests** - Ensure components work correctly

### Phase 3: Optional Polish (1 hour)
5. **Results Screen Animations** - Nice-to-have celebration effects

---

## Dependencies Check

Current `pubspec.yaml` already has:
- ✅ `audioplayers: ^6.5.1` - For sounds
- ✅ `flutter_riverpod: ^2.4.0` - For state management
- ✅ `mocktail: ^1.0.0` - For testing

Added:
- `confetti: ^0.7.0` - Results screen confetti

---

## Success Criteria for Day 11

At the end of Day 11:
- [ ] Answer chips animate on tap (bounce/scale)
- [ ] Timer pulses continuously when < 10s
- [ ] At least 5 new test files created
- [ ] All tests pass with `flutter test`
- [ ] No new `flutter analyze` warnings
- [ ] Manual testing confirms polish feels good

---

## Commands Reference

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/providers/game_state_provider_test.dart

# Run tests with coverage
flutter test --coverage

# Generate coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Check code quality
flutter analyze

# Run app for manual testing
flutter run --release
```

---

## Notes

- All animations should respect the device's reduced motion settings for accessibility
- Keep animations subtle - this is a party game, not a gaming app
- Prioritize 60fps performance over fancy effects
- Tests should be fast and not rely on delays

---

**Ready to implement?** Start with Task 1 (Answer Chip Animation) for the biggest visual impact.
