import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents a team in the game
class Team extends Equatable {
  final String id;
  final String name;
  final Color color;
  final int score;

  const Team({
    required this.id,
    required this.name,
    required this.color,
    this.score = 0,
  });

  /// Create a copy of this team with updated fields
  Team copyWith({
    String? id,
    String? name,
    Color? color,
    int? score,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      score: score ?? this.score,
    );
  }

  /// Add points to the team's score
  Team addPoints(int points) {
    return copyWith(score: score + points);
  }

  /// Reset the team's score to zero
  Team resetScore() {
    return copyWith(score: 0);
  }

  @override
  List<Object?> get props => [id, name, color, score];

  @override
  String toString() => 'Team(id: $id, name: $name, score: $score)';
}
