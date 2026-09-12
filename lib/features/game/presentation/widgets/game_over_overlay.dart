import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../flame/catch_the_falling_tiles_game.dart';
import '../cubit/game_cubit.dart';
import '../cubit/game_state.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key, required this.game});

  final CatchTheFallingTilesGame game;

  @override
  Widget build(BuildContext context) {
    bool isNewHighScore = false;
    int highScore = 0;

    try {
      final cubitState = context.watch<GameCubit>().state;
      if (cubitState is GameOverState) {
        isNewHighScore = cubitState.isNewHighScore;
        highScore = cubitState.highScore;
      } else if (cubitState is GamePlaying) {
        highScore = cubitState.highScore;
      }
    } catch (_) {
      // Fallback for standalone overlay tests
    }

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
            builder: (context, score, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.formatFinalScore(score),
                    style: kTextStylePublicSans400.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: AppDimens.p16,
                    ),
                  ),
                  if (isNewHighScore && score > 0) ...[
                    const SizedBox(height: AppDimens.p8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.p12,
                        vertical: AppDimens.p4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                        border: Border.all(
                          color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                        ),
                      ),
                      child: Text(
                        AppStrings.newHighScore,
                        style: kTextStylePublicSans700.copyWith(
                          color: const Color(0xFFFFD700),
                          fontSize: AppDimens.p12 + 1,
                        ),
                      ),
                    ),
                  ] else if (highScore > 0) ...[
                    const SizedBox(height: AppDimens.p4),
                    Text(
                      AppStrings.formatHighScore(highScore),
                      style: kTextStylePublicSans400.copyWith(
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
                        fontSize: AppDimens.p12 + 1,
                      ),
                    ),
                  ],
                ],
              );
            },
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
