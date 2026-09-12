import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/game_stats.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_datasource.dart';
import '../datasources/game_remote_datasource.dart';
import '../models/game_stats_model.dart';

class GameRepositoryImpl implements GameRepository {
  const GameRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final GameLocalDataSource localDataSource;
  final GameRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, int>> getHighScore() async {
    try {
      final highScore = await localDataSource.getHighScore();
      return Right(highScore);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveHighScore(int score) async {
    try {
      await localDataSource.saveHighScore(score);
      // Non-blocking best-effort remote sync if available
      try {
        await remoteDataSource.syncScore(score);
      } catch (_) {
        // Local save succeeded; remote sync failure is non-fatal for offline play
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GameStats>> getGameStats() async {
    try {
      final cachedModel = await localDataSource.getGameStats();
      if (cachedModel != null) {
        return Right(cachedModel.toEntity());
      }
      return Right(GameStats.initial());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveGameStats(GameStats stats) async {
    try {
      final model = GameStatsModel.fromEntity(stats);
      await localDataSource.saveGameStats(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
