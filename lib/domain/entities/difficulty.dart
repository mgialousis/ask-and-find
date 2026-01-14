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
}
