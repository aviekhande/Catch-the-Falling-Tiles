import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/theme/app_colors.dart';
import '../../flame/catch_the_falling_tiles_game.dart';
import '../cubit/game_cubit.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/hud_overlay.dart';
import '../widgets/start_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameCubit _cubit;
  late final CatchTheFallingTilesGame _game;

  @override
  void initState() {
    super.initState();
    _cubit = sl.isRegistered<GameCubit>()
        ? sl<GameCubit>()
        : GameCubit(
            getHighScoreUseCase: sl(),
            saveHighScoreUseCase: sl(),
            saveGameStatsUseCase: sl(),
            audioService: sl(),
          );
    _cubit.loadInitialData();

    _game = CatchTheFallingTilesGame(
      onGameStarted: () {
        _cubit.startGame();
      },
      onScoreChanged: (newScore) {
        _cubit.tileCaught();
      },
      onLivesChanged: (remainingLives) {
        _cubit.tileMissed();
      },
      onGameOverCallback: (finalScore) {
        _cubit.endGame(finalScore);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: GameWidget<CatchTheFallingTilesGame>(
          game: _game,
          overlayBuilderMap: {
            CatchTheFallingTilesGame.overlayStart: (context, game) =>
                StartOverlay(game: game),
            CatchTheFallingTilesGame.overlayHud: (context, game) =>
                HudOverlay(game: game),
            CatchTheFallingTilesGame.overlayGameOver: (context, game) =>
                GameOverOverlay(game: game),
          },
        ),
      ),
    );
  }
}
