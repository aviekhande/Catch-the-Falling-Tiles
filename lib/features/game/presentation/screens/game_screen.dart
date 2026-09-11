import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../flame/catch_the_falling_tiles_game.dart';
import '../widgets/game_over_overlay.dart';
import '../widgets/hud_overlay.dart';
import '../widgets/start_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final CatchTheFallingTilesGame _game;

  @override
  void initState() {
    super.initState();
    _game = CatchTheFallingTilesGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
