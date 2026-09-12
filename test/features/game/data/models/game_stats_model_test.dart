import 'package:catch_the_falling_tiles/features/game/data/models/game_stats_model.dart';
import 'package:catch_the_falling_tiles/features/game/data/models/high_score_model.dart';
import 'package:catch_the_falling_tiles/features/game/domain/entities/game_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameStatsModel Tests', () {
    const tModel = GameStatsModel(score: 15, lives: 2, highScore: 25);

    test('should be a subclass of GameStats entity', () {
      expect(tModel, isA<GameStats>());
    });

    test('fromJson returns valid model', () {
      final json = {'score': 10, 'lives': 1, 'highScore': 20};
      final result = GameStatsModel.fromJson(json);

      expect(result.score, 10);
      expect(result.lives, 1);
      expect(result.highScore, 20);
    });

    test('toJson returns JSON map with correct keys and values', () {
      final json = tModel.toJson();
      expect(json, {'score': 15, 'lives': 2, 'highScore': 25});
    });

    test('fromEntity converts entity to model correctly', () {
      const entity = GameStats(score: 7, lives: 3, highScore: 14);
      final model = GameStatsModel.fromEntity(entity);

      expect(model.score, 7);
      expect(model.lives, 3);
      expect(model.highScore, 14);
    });

    test('toEntity converts model to entity correctly', () {
      final entity = tModel.toEntity();

      expect(entity.score, 15);
      expect(entity.lives, 2);
      expect(entity.highScore, 25);
    });
  });

  group('HighScoreModel Tests', () {
    final now = DateTime(2026, 9, 12, 12, 0, 0);
    final tHighScoreModel = HighScoreModel(score: 42, recordedAt: now);

    test('fromJson parses JSON correctly', () {
      final json = {'score': 42, 'recordedAt': now.toIso8601String()};
      final result = HighScoreModel.fromJson(json);

      expect(result.score, 42);
      expect(result.recordedAt, now);
    });

    test('toJson outputs valid map', () {
      final json = tHighScoreModel.toJson();
      expect(json['score'], 42);
      expect(json['recordedAt'], now.toIso8601String());
    });
  });
}
