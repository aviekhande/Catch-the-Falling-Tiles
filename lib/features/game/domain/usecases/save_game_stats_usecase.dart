import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/game_stats.dart';
import '../repositories/game_repository.dart';
import 'usecase.dart';

class SaveGameStatsUseCase implements UseCase<void, GameStats> {
  const SaveGameStatsUseCase(this.repository);

  final GameRepository repository;

  @override
  Future<Either<Failure, void>> call(GameStats stats) {
    return repository.saveGameStats(stats);
  }
}
