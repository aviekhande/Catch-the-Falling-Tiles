import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/audio/audio_service.dart';
import '../../../../core/constants/game_constants.dart';
import '../../domain/entities/game_stats.dart';
import '../../domain/usecases/get_high_score_usecase.dart';
import '../../domain/usecases/save_game_stats_usecase.dart';
import '../../domain/usecases/save_high_score_usecase.dart';
import '../../domain/usecases/usecase.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit({
    required this.getHighScoreUseCase,
    required this.saveHighScoreUseCase,
    required this.saveGameStatsUseCase,
    required this.audioService,
  }) : super(const GameInitial());

  final GetHighScoreUseCase getHighScoreUseCase;
  final SaveHighScoreUseCase saveHighScoreUseCase;
  final SaveGameStatsUseCase saveGameStatsUseCase;
  final AudioService audioService;

  int _cachedHighScore = 0;
  int get currentHighScore => _cachedHighScore;

  Future<void> loadInitialData() async {
    emit(const GameLoading());
    final result = await getHighScoreUseCase(const NoParams());
    result.fold(
      (failure) {
        _cachedHighScore = 0;
        emit(const GameInitial(highScore: 0));
      },
      (highScore) {
        _cachedHighScore = highScore;
        emit(GameInitial(highScore: highScore));
      },
    );
  }

  void startGame() {
    emit(GamePlaying(
      score: 0,
      lives: GameConstants.startingLives,
      highScore: _cachedHighScore,
    ));
  }

  void tileCaught() {
    final current = state;
    if (current is! GamePlaying) return;

    final newScore = current.score + 1;
    final newHighScore = max(_cachedHighScore, newScore);
    if (newHighScore > _cachedHighScore) {
      _cachedHighScore = newHighScore;
    }

    emit(current.copyWith(
      score: newScore,
      highScore: newHighScore,
      lastLostLifeIndex: null,
    ));

    audioService.playCatch();
  }

  void tileMissed() {
    final current = state;
    if (current is! GamePlaying) return;

    final remainingLives = current.lives - 1;
    final lostIndex = remainingLives;

    if (remainingLives <= 0) {
      endGame(current.score);
    } else {
      audioService.playLifeLost();
      emit(current.copyWith(
        lives: remainingLives,
        lastLostLifeIndex: lostIndex,
      ));
    }
  }

  Future<void> endGame(int finalScore) async {
    final isNewHighScore = finalScore > _cachedHighScore;
    if (isNewHighScore) {
      _cachedHighScore = finalScore;
      await saveHighScoreUseCase(finalScore);
    }

    final stats = GameStats(
      score: finalScore,
      lives: 0,
      highScore: _cachedHighScore,
    );
    await saveGameStatsUseCase(stats);

    audioService.playGameOver();

    emit(GameOverState(
      finalScore: finalScore,
      highScore: _cachedHighScore,
      isNewHighScore: isNewHighScore,
    ));
  }

  void resetToStart() {
    emit(GameInitial(highScore: _cachedHighScore));
  }
}
