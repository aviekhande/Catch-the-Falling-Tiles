import 'package:catch_the_falling_tiles/core/audio/audio_service.dart';
import 'package:catch_the_falling_tiles/core/constants/game_constants.dart';
import 'package:catch_the_falling_tiles/core/error/failures.dart';
import 'package:catch_the_falling_tiles/features/game/domain/entities/game_stats.dart';
import 'package:catch_the_falling_tiles/features/game/domain/repositories/game_repository.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/get_high_score_usecase.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/save_game_stats_usecase.dart';
import 'package:catch_the_falling_tiles/features/game/domain/usecases/save_high_score_usecase.dart';
import 'package:catch_the_falling_tiles/features/game/presentation/cubit/game_cubit.dart';
import 'package:catch_the_falling_tiles/features/game/presentation/cubit/game_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAudioService implements AudioService {
  int catchCount = 0;
  int missCount = 0;
  int lifeLostCount = 0;
  int gameOverCount = 0;
  bool muted = false;

  @override
  bool get isMuted => muted;

  @override
  Future<void> playCatch() async => catchCount++;

  @override
  Future<void> playGameOver() async => gameOverCount++;

  @override
  Future<void> playLifeLost() async => lifeLostCount++;

  @override
  Future<void> playMiss() async => missCount++;

  @override
  void setMuted(bool isMuted) => muted = isMuted;

  @override
  void toggleMute() => muted = !muted;
}

class FakeGameRepository implements GameRepository {
  int highScore = 10;
  GameStats stats = GameStats.initial();

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
  late FakeAudioService audioService;
  late FakeGameRepository repository;
  late GameCubit cubit;

  setUp(() {
    audioService = FakeAudioService();
    repository = FakeGameRepository();
    cubit = GameCubit(
      getHighScoreUseCase: GetHighScoreUseCase(repository),
      saveHighScoreUseCase: SaveHighScoreUseCase(repository),
      saveGameStatsUseCase: SaveGameStatsUseCase(repository),
      audioService: audioService,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('GameCubit Tests', () {
    test('initial state is GameInitial', () {
      expect(cubit.state, const GameInitial());
    });

    test('loadInitialData retrieves and emits high score', () async {
      await cubit.loadInitialData();
      expect(cubit.state, const GameInitial(highScore: 10));
      expect(cubit.currentHighScore, 10);
    });

    test('startGame emits GamePlaying with initial lives and score', () async {
      await cubit.loadInitialData();
      cubit.startGame();

      expect(cubit.state, isA<GamePlaying>());
      final playingState = cubit.state as GamePlaying;
      expect(playingState.score, 0);
      expect(playingState.lives, GameConstants.startingLives);
      expect(playingState.highScore, 10);
    });

    test('tileCaught increments score, updates high score if beaten, and plays audio', () async {
      await cubit.loadInitialData();
      cubit.startGame();

      cubit.tileCaught();
      expect((cubit.state as GamePlaying).score, 1);
      expect(audioService.catchCount, 1);

      // Catch 11 tiles to beat high score of 10
      for (int i = 0; i < 10; i++) {
        cubit.tileCaught();
      }
      expect((cubit.state as GamePlaying).score, 11);
      expect((cubit.state as GamePlaying).highScore, 11);
    });

    test('tileMissed decrements life, plays life lost audio, and sets lastLostLifeIndex', () async {
      await cubit.loadInitialData();
      cubit.startGame();

      cubit.tileMissed();
      final playingState = cubit.state as GamePlaying;
      expect(playingState.lives, GameConstants.startingLives - 1);
      expect(playingState.lastLostLifeIndex, GameConstants.startingLives - 1);
      expect(audioService.lifeLostCount, 1);
    });

    test('endGame emits GameOverState and marks isNewHighScore appropriately', () async {
      await cubit.loadInitialData();
      await cubit.endGame(25);

      expect(cubit.state, isA<GameOverState>());
      final gameOver = cubit.state as GameOverState;
      expect(gameOver.finalScore, 25);
      expect(gameOver.highScore, 25);
      expect(gameOver.isNewHighScore, isTrue);
      expect(audioService.gameOverCount, 1);
      expect(repository.highScore, 25);
    });
  });
}
