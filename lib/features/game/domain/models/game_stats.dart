import 'package:flutter/foundation.dart';

import '../../../../core/constants/game_constants.dart';

@immutable
class GameStats {
  const GameStats({
    required this.score,
    required this.lives,
  });

  factory GameStats.initial() {
    return const GameStats(
      score: 0,
      lives: GameConstants.startingLives,
    );
  }

  final int score;
  final int lives;

  bool get isGameOver => lives <= 0;
  bool get hasFullHealth => lives >= GameConstants.startingLives;

  GameStats copyWith({
    int? score,
    int? lives,
  }) {
    return GameStats(
      score: score ?? this.score,
      lives: lives ?? this.lives,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStats &&
          runtimeType == other.runtimeType &&
          score == other.score &&
          lives == other.lives;

  @override
  int get hashCode => Object.hash(score, lives);

  @override
  String toString() => 'GameStats(score: $score, lives: $lives)';
}
