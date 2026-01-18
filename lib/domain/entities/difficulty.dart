/// Difficulty levels for game cards
enum Difficulty {
  easy,
  medium,
  hard,
  mixed;

  /// Get display name for the difficulty level
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
      case Difficulty.mixed:
        return 'Mixed';
    }
  }

  /// Get short description for each difficulty
  String get description {
    switch (this) {
      case Difficulty.easy:
        return 'Simple and well-known items';
      case Difficulty.medium:
        return 'Moderate challenge';
      case Difficulty.hard:
        return 'Challenging and obscure items';
      case Difficulty.mixed:
        return 'Random mix of all difficulties';
    }
  }

  /// Get points per answer based on difficulty
  int get pointsPerAnswer {
    switch (this) {
      case Difficulty.easy:
        return 1;
      case Difficulty.medium:
        return 2;
      case Difficulty.hard:
        return 3;
      case Difficulty.mixed:
        return 1; // Mixed uses default 1 point (varies by card)
    }
  }
}

Difficulty parseDifficulty(String value) {
  final normalized = value.trim().toLowerCase();
  for (final difficulty in Difficulty.values) {
    if (difficulty.name == normalized) {
      return difficulty;
    }
  }
  throw ArgumentError('Unknown difficulty: $value');
}
