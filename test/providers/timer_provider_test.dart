import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pes_vres/presentation/state/timer_provider.dart';

void main() {
  group('TimerState', () {
    test('initial state has zero seconds and is not running', () {
      final state = TimerState.initial();

      expect(state.secondsRemaining, 0);
      expect(state.isRunning, false);
      expect(state.initialSeconds, 0);
    });

    test('isExpired returns true when seconds remaining is 0', () {
      const state = TimerState(
        secondsRemaining: 0,
        isRunning: false,
        initialSeconds: 60,
      );

      expect(state.isExpired, true);
    });

    test('isExpired returns false when seconds remaining is positive', () {
      const state = TimerState(
        secondsRemaining: 30,
        isRunning: true,
        initialSeconds: 60,
      );

      expect(state.isExpired, false);
    });

    test('isWarning returns true when seconds <= 10 and > 0', () {
      const state = TimerState(
        secondsRemaining: 10,
        isRunning: true,
        initialSeconds: 60,
      );

      expect(state.isWarning, true);
    });

    test('isWarning returns false when seconds > 10', () {
      const state = TimerState(
        secondsRemaining: 11,
        isRunning: true,
        initialSeconds: 60,
      );

      expect(state.isWarning, false);
    });

    test('isWarning returns false when seconds is 0', () {
      const state = TimerState(
        secondsRemaining: 0,
        isRunning: false,
        initialSeconds: 60,
      );

      expect(state.isWarning, false);
    });

    test('isCritical returns true when seconds <= 5 and > 0', () {
      const state = TimerState(
        secondsRemaining: 5,
        isRunning: true,
        initialSeconds: 60,
      );

      expect(state.isCritical, true);
    });

    test('isCritical returns false when seconds > 5', () {
      const state = TimerState(
        secondsRemaining: 6,
        isRunning: true,
        initialSeconds: 60,
      );

      expect(state.isCritical, false);
    });

    test('progress calculates correctly', () {
      const state = TimerState(
        secondsRemaining: 30,
        isRunning: true,
        initialSeconds: 60,
      );

      expect(state.progress, 0.5);
    });

    test('progress returns 0 when initialSeconds is 0', () {
      const state = TimerState(
        secondsRemaining: 0,
        isRunning: false,
        initialSeconds: 0,
      );

      expect(state.progress, 0.0);
    });

    test('copyWith creates new instance with updated values', () {
      const original = TimerState(
        secondsRemaining: 60,
        isRunning: true,
        initialSeconds: 60,
      );

      final copied = original.copyWith(secondsRemaining: 30);

      expect(copied.secondsRemaining, 30);
      expect(copied.isRunning, true);
      expect(copied.initialSeconds, 60);
    });

    test('equality works correctly', () {
      const state1 = TimerState(
        secondsRemaining: 60,
        isRunning: true,
        initialSeconds: 60,
      );
      const state2 = TimerState(
        secondsRemaining: 60,
        isRunning: true,
        initialSeconds: 60,
      );
      const state3 = TimerState(
        secondsRemaining: 30,
        isRunning: true,
        initialSeconds: 60,
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('TimerNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is not running with 0 seconds', () {
      final state = container.read(timerProvider);

      expect(state.secondsRemaining, 0);
      expect(state.isRunning, false);
    });

    test('start sets correct duration and begins running', () {
      container.read(timerProvider.notifier).start(60);

      final state = container.read(timerProvider);

      expect(state.secondsRemaining, 60);
      expect(state.isRunning, true);
      expect(state.initialSeconds, 60);
    });

    test('pause stops the timer but keeps time', () {
      container.read(timerProvider.notifier).start(60);
      container.read(timerProvider.notifier).pause();

      final state = container.read(timerProvider);

      expect(state.secondsRemaining, 60);
      expect(state.isRunning, false);
    });

    test('resume continues from paused state', () {
      container.read(timerProvider.notifier).start(60);
      container.read(timerProvider.notifier).pause();
      container.read(timerProvider.notifier).resume();

      final state = container.read(timerProvider);

      expect(state.isRunning, true);
    });

    test('resume does nothing when timer is at 0', () {
      // Start with 0 seconds - can't resume from 0
      container.read(timerProvider.notifier).start(60);
      // Manually reset to simulate expired timer
      container.read(timerProvider.notifier).reset();
      container.read(timerProvider.notifier).resume();

      final state = container.read(timerProvider);

      expect(state.isRunning, false);
    });

    test('reset clears timer state', () {
      container.read(timerProvider.notifier).start(60);
      container.read(timerProvider.notifier).reset();

      final state = container.read(timerProvider);

      expect(state.secondsRemaining, 0);
      expect(state.isRunning, false);
      expect(state.initialSeconds, 0);
    });

    test('addSeconds increases remaining time', () {
      container.read(timerProvider.notifier).start(60);
      container.read(timerProvider.notifier).addSeconds(10);

      final state = container.read(timerProvider);

      expect(state.secondsRemaining, 70);
    });

    test('addSeconds can decrease time', () {
      container.read(timerProvider.notifier).start(60);
      container.read(timerProvider.notifier).addSeconds(-10);

      final state = container.read(timerProvider);

      expect(state.secondsRemaining, 50);
    });

    test('addSeconds does not go below 0', () {
      container.read(timerProvider.notifier).start(10);
      container.read(timerProvider.notifier).addSeconds(-20);

      final state = container.read(timerProvider);

      // Should not update if result would be negative
      expect(state.secondsRemaining, 10);
    });

    test('starting new timer cancels previous one', () {
      container.read(timerProvider.notifier).start(60);

      // Start a new timer
      container.read(timerProvider.notifier).start(30);

      final state = container.read(timerProvider);

      expect(state.secondsRemaining, 30);
      expect(state.initialSeconds, 30);
    });
  });
}
