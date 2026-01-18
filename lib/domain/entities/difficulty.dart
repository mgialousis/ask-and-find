/// Difficulty levels for game cards
enum Difficulty {
  easy,
  medium,
  hard;

  /// Get display name for the difficulty level
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
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
