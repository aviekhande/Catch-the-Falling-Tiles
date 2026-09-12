import '../../domain/entities/game_stats.dart';

class GameStatsModel extends GameStats {
  const GameStatsModel({
    required super.score,
    required super.lives,
    super.highScore = 0,
  });

  factory GameStatsModel.fromJson(Map<String, dynamic> json) {
    return GameStatsModel(
      score: json['score'] as int? ?? 0,
      lives: json['lives'] as int? ?? 3,
      highScore: json['highScore'] as int? ?? 0,
    );
  }

  factory GameStatsModel.fromEntity(GameStats entity) {
    return GameStatsModel(
      score: entity.score,
      lives: entity.lives,
      highScore: entity.highScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'lives': lives,
      'highScore': highScore,
    };
  }

  GameStats toEntity() {
    return GameStats(
      score: score,
      lives: lives,
      highScore: highScore,
    );
  }
}
