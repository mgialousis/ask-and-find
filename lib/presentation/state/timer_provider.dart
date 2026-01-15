import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Timer state for countdown during gameplay
///
/// Tracks the current time remaining and whether the timer is running.
class TimerState extends Equatable {
  const TimerState({
    required this.secondsRemaining,
    required this.isRunning,
    required this.initialSeconds,
  });

  /// Seconds remaining in current countdown
  final int secondsRemaining;

  /// Whether timer is currently counting down
  final bool isRunning;

  /// Initial duration for reference (used for progress calculations)
  final int initialSeconds;

  /// Initial stopped state
  factory TimerState.initial() => const TimerState(
        secondsRemaining: 0,
        isRunning: false,
        initialSeconds: 0,
      );

  /// Create a copy with optional field updates
  TimerState copyWith({
    int? secondsRemaining,
    bool? isRunning,
    int? initialSeconds,
  }) {
    return TimerState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isRunning: isRunning ?? this.isRunning,
      initialSeconds: initialSeconds ?? this.initialSeconds,
    );
  }

  /// Check if timer has expired
  bool get isExpired => secondsRemaining <= 0;

  /// Check if timer is in warning zone (< 10 seconds)
  bool get isWarning => secondsRemaining > 0 && secondsRemaining <= 10;

  /// Check if timer is in critical zone (< 5 seconds)
  bool get isCritical => secondsRemaining > 0 && secondsRemaining <= 5;

  /// Get progress as percentage (0.0 to 1.0)
  double get progress {
    if (initialSeconds <= 0) return 0.0;
    return secondsRemaining / initialSeconds;
  }

  @override
  List<Object?> get props => [secondsRemaining, isRunning, initialSeconds];

  @override
  String toString() =>
      'TimerState(remaining: ${secondsRemaining}s, running: $isRunning)';
}

/// Timer notifier - manages countdown timer state
///
/// Provides methods to start, pause, resume, and reset the timer.
/// Automatically decrements every second when running.
class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier() : super(TimerState.initial());

  Timer? _timer;

  /// Start or restart the timer with specified duration in seconds
  void start(int durationSeconds) {
    // Cancel any existing timer
    _timer?.cancel();

    // Set initial state
    state = TimerState(
      secondsRemaining: durationSeconds,
      isRunning: true,
      initialSeconds: durationSeconds,
    );

    // Start countdown
    _startTicking();
  }

  /// Pause the timer (keeps current time)
  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  /// Resume the timer from paused state
  void resume() {
    if (state.secondsRemaining > 0) {
      state = state.copyWith(isRunning: true);
      _startTicking();
    }
  }

  /// Reset timer to initial state (stopped, zero time)
  void reset() {
    _timer?.cancel();
    state = TimerState.initial();
  }

  /// Add seconds to current time (for testing or bonus time)
  void addSeconds(int seconds) {
    if (state.secondsRemaining + seconds >= 0) {
      state = state.copyWith(
        secondsRemaining: state.secondsRemaining + seconds,
      );
    }
  }

  /// Internal method to handle the countdown tick
  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state = state.copyWith(
          secondsRemaining: state.secondsRemaining - 1,
        );
      } else {
        // Timer expired, stop ticking
        timer.cancel();
        state = state.copyWith(isRunning: false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider for countdown timer
///
/// Usage:
/// ```dart
/// // Start timer
/// ref.read(timerProvider.notifier).start(60);
///
/// // Watch timer state
/// final timer = ref.watch(timerProvider);
/// Text('${timer.secondsRemaining}s');
///
/// // Pause/resume
/// ref.read(timerProvider.notifier).pause();
/// ref.read(timerProvider.notifier).resume();
///
/// // Listen for expiration
/// ref.listen(timerProvider, (previous, current) {
///   if (current.isExpired && previous?.isRunning == true) {
///     // Timer just expired
///     onTimeUp();
///   }
/// });
/// ```
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>(
  (ref) => TimerNotifier(),
);
