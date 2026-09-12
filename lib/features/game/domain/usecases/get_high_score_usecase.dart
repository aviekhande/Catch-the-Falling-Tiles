import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/game_repository.dart';
import 'usecase.dart';

class GetHighScoreUseCase implements UseCase<int, NoParams> {
  const GetHighScoreUseCase(this.repository);

  final GameRepository repository;

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getHighScore();
  }
}
