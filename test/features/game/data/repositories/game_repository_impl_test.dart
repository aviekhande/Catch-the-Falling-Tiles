import 'package:catch_the_falling_tiles/core/error/exceptions.dart';
import 'package:catch_the_falling_tiles/core/error/failures.dart';
import 'package:catch_the_falling_tiles/features/game/data/datasources/game_local_datasource.dart';
import 'package:catch_the_falling_tiles/features/game/data/datasources/game_remote_datasource.dart';
import 'package:catch_the_falling_tiles/features/game/data/models/game_stats_model.dart';
import 'package:catch_the_falling_tiles/features/game/data/models/high_score_model.dart';
import 'package:catch_the_falling_tiles/features/game/data/repositories/game_repository_impl.dart';
import 'package:catch_the_falling_tiles/features/game/domain/entities/game_stats.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeLocalDataSource implements GameLocalDataSource {
  int highScore = 0;
  GameStatsModel? stats;
  bool shouldThrow = false;

  @override
  Future<int> getHighScore() async {
    if (shouldThrow) throw const CacheException(message: 'Disk error');
    return highScore;
  }

  @override
  Future<void> saveHighScore(int score) async {
    if (shouldThrow) throw const CacheException(message: 'Disk write error');
    highScore = score;
  }

  @override
  Future<GameStatsModel?> getGameStats() async {
    if (shouldThrow) throw const CacheException(message: 'Stats read error');
    return stats;
  }

  @override
  Future<void> saveGameStats(GameStatsModel newStats) async {
    if (shouldThrow) throw const CacheException(message: 'Stats write error');
    stats = newStats;
  }
}

class FakeRemoteDataSource implements GameRemoteDataSource {
  int? syncedScore;
  GameStatsModel? syncedStats;

  @override
  Future<List<HighScoreModel>> getLeaderboard() async => [];

  @override
  Future<void> syncGameStats(GameStatsModel stats) async {
    syncedStats = stats;
  }

  @override
  Future<void> syncScore(int score) async {
    syncedScore = score;
  }
}

void main() {
  late FakeLocalDataSource localDataSource;
  late FakeRemoteDataSource remoteDataSource;
  late GameRepositoryImpl repository;

  setUp(() {
    localDataSource = FakeLocalDataSource();
    remoteDataSource = FakeRemoteDataSource();
    repository = GameRepositoryImpl(
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  });

  group('GameRepositoryImpl Tests', () {
    test('getHighScore returns Right(int) when local read succeeds', () async {
      localDataSource.highScore = 100;
      final result = await repository.getHighScore();

      expect(result, const Right(100));
    });

    test('getHighScore returns Left(CacheFailure) when CacheException thrown', () async {
      localDataSource.shouldThrow = true;
      final result = await repository.getHighScore();

      expect(result, isA<Left<Failure, int>>());
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('saveHighScore stores score in local and syncs with remote', () async {
      final result = await repository.saveHighScore(55);

      expect(result, const Right(null));
      expect(localDataSource.highScore, 55);
      expect(remoteDataSource.syncedScore, 55);
    });

    test('saveGameStats and getGameStats convert and retrieve cleanly', () async {
      const entity = GameStats(score: 18, lives: 2, highScore: 30);
      final saveResult = await repository.saveGameStats(entity);
      expect(saveResult, const Right(null));

      final getResult = await repository.getGameStats();
      expect(getResult, const Right(entity));
    });
  });
}
