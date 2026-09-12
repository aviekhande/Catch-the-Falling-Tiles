import 'package:catch_the_falling_tiles/core/error/failures.dart';
import 'package:catch_the_falling_tiles/features/game/domain/entities/game_stats.dart';
import 'package:catch_the_falling_tiles/features/game/domain/repositories/game_repository.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/get_game_stats_usecase.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/get_high_score_usecase.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/save_game_stats_usecase.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/save_high_score_usecase.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGameRepository implements GameRepository {
  int highScore = 77;
  GameStats stats = const GameStats(score: 10, lives: 3, highScore: 77);

  @override
  Future<Either<Failure, GameStats>> getGameStats() async => Right(stats);

  @override
  Future<Either<Failure, int>> getHighScore() async => Right(highScore);

  @override
  Future<Either<Failure, void>> saveGameStats(GameStats newStats) async {
    stats = newStats;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> saveHighScore(int score) async {
    highScore = score;
    return const Right(null);
  }
}

void main() {
  late MockGameRepository repository;
  late GetHighScoreUseCase getHighScoreUseCase;
  late SaveHighScoreUseCase saveHighScoreUseCase;
  late GetGameStatsUseCase getGameStatsUseCase;
  late SaveGameStatsUseCase saveGameStatsUseCase;

  setUp(() {
    repository = MockGameRepository();
    getHighScoreUseCase = GetHighScoreUseCase(repository);
    saveHighScoreUseCase = SaveHighScoreUseCase(repository);
    getGameStatsUseCase = GetGameStatsUseCase(repository);
    saveGameStatsUseCase = SaveGameStatsUseCase(repository);
  });

  group('Domain Use Cases Tests', () {
    test('GetHighScoreUseCase returns high score from repository', () async {
      final result = await getHighScoreUseCase(const NoParams());
      expect(result, const Right(77));
    });

    test('SaveHighScoreUseCase invokes repository saveHighScore', () async {
      final result = await saveHighScoreUseCase(99);
      expect(result, const Right(null));
      expect(repository.highScore, 99);
    });

    test('GetGameStatsUseCase returns GameStats from repository', () async {
      final result = await getGameStatsUseCase(const NoParams());
      expect(result, Right(repository.stats));
    });

    test('SaveGameStatsUseCase updates stats in repository', () async {
      const newStats = GameStats(score: 25, lives: 1, highScore: 99);
      final result = await saveGameStatsUseCase(newStats);
      expect(result, const Right(null));
      expect(repository.stats, newStats);
    });
  });
}
