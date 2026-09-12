import 'package:equatable/equatable.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial({this.highScore = 0});

  final int highScore;

  @override
  List<Object?> get props => [highScore];
}

class GameLoading extends GameState {
  const GameLoading();
}

class GamePlaying extends GameState {
  const GamePlaying({
    required this.score,
    required this.lives,
    required this.highScore,
    this.lastLostLifeIndex,
  });

  final int score;
  final int lives;
  final int highScore;
  final int? lastLostLifeIndex;

  GamePlaying copyWith({
    int? score,
    int? lives,
    int? highScore,
    int? lastLostLifeIndex,
  }) {
    return GamePlaying(
      score: score ?? this.score,
      lives: lives ?? this.lives,
      highScore: highScore ?? this.highScore,
      lastLostLifeIndex: lastLostLifeIndex,
    );
  }

  @override
  List<Object?> get props => [score, lives, highScore, lastLostLifeIndex];
}

class GameOverState extends GameState {
  const GameOverState({
    required this.finalScore,
    required this.highScore,
    required this.isNewHighScore,
  });

  final int finalScore;
  final int highScore;
  final bool isNewHighScore;

  @override
  List<Object?> get props => [finalScore, highScore, isNewHighScore];
}

class GameError extends GameState {
  const GameError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
