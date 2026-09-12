import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/game_stats.dart';

abstract class GameRepository {
  Future<Either<Failure, int>> getHighScore();
  Future<Either<Failure, void>> saveHighScore(int score);
  Future<Either<Failure, GameStats>> getGameStats();
  Future<Either<Failure, void>> saveGameStats(GameStats stats);
}
