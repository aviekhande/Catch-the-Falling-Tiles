import 'package:equatable/equatable.dart';

import '../../../../core/constants/game_constants.dart';

class GameStats extends Equatable {
  const GameStats({
    required this.score,
    required this.lives,
    this.highScore = 0,
  });

  factory GameStats.initial() {
    return const GameStats(
      score: 0,
      lives: GameConstants.startingLives,
      highScore: 0,
    );
  }

  final int score;
  final int lives;
  final int highScore;

  bool get isGameOver => lives <= 0;
  bool get hasFullHealth => lives >= GameConstants.startingLives;

  GameStats copyWith({
    int? score,
    int? lives,
    int? highScore,
  }) {
    return GameStats(
      score: score ?? this.score,
      lives: lives ?? this.lives,
      highScore: highScore ?? this.highScore,
    );
  }

  @override
  List<Object?> get props => [score, lives, highScore];

  @override
  String toString() =>
      'GameStats(score: $score, lives: $lives, highScore: $highScore)';
}
