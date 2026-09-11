import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../flame/catch_the_falling_tiles_game.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});

  final CatchTheFallingTilesGame game;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.overlayScrim,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.sentiment_dissatisfied_rounded,
            color: AppColors.livesFull,
            size: AppDimens.p48 + AppDimens.p8,
          ),
          const SizedBox(height: AppDimens.p16),
          Text(
            AppStrings.gameOver,
            style: kTextStylePublicSans800.copyWith(
              color: AppColors.textPrimary,
              fontSize: AppDimens.p28,
            ),
          ),
          const SizedBox(height: AppDimens.p8),
          ValueListenableBuilder<int>(
            valueListenable: game.score,
            builder: (context, score, _) => Text(
              AppStrings.formatFinalScore(score),
              style: kTextStylePublicSans400.copyWith(
                color: AppColors.textSecondary,
                fontSize: AppDimens.p16,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.p28),
          ElevatedButton(
            onPressed: game.startGame,
            child: const Text(AppStrings.playAgainButton),
          ),
        ],
      ),
    );
  }
}
