import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/game_repository.dart';
import 'usecase.dart';

class SaveHighScoreUseCase implements UseCase<void, int> {
  const SaveHighScoreUseCase(this.repository);

  final GameRepository repository;

  @override
  Future<Either<Failure, void>> call(int score) {
    return repository.saveHighScore(score);
  }
}
