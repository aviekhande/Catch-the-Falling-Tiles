import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/game_stats.dart';
import '../repositories/game_repository.dart';
import 'usecase.dart';

class GetGameStatsUseCase implements UseCase<GameStats, NoParams> {
  const GetGameStatsUseCase(this.repository);

  final GameRepository repository;

  @override
  Future<Either<Failure, GameStats>> call(NoParams params) {
    return repository.getGameStats();
  }
}
