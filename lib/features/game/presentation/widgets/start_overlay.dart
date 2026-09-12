import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../flame/catch_the_falling_tiles_game.dart';
import '../cubit/game_cubit.dart';
import '../cubit/game_state.dart';

class StartOverlay extends StatelessWidget {
  const StartOverlay({super.key, required this.game});

  final CatchTheFallingTilesGame game;

  @override
  Widget build(BuildContext context) {
    int highScore = 0;
    try {
      final cubitState = context.watch<GameCubit>().state;
      if (cubitState is GameInitial) {
        highScore = cubitState.highScore;
      } else if (cubitState is GamePlaying) {
        highScore = cubitState.highScore;
      } else if (cubitState is GameOverState) {
        highScore = cubitState.highScore;
      }
    } catch (_) {
      // Fallback for tests mounted outside BlocProvider
    }

    return Container(
      color: AppColors.overlayScrim,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.grid_view_rounded,
            color: AppColors.paddle,
            size: AppDimens.p48 + AppDimens.p8,
          ),
          const SizedBox(height: AppDimens.p16),
          Text(
            AppStrings.gameTitle,
            textAlign: TextAlign.center,
            style: kTextStylePublicSans800.copyWith(
              color: AppColors.textPrimary,
              fontSize: AppDimens.p24 + 2,
            ),
          ),
          if (highScore > 0) ...[
            const SizedBox(height: AppDimens.p8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.p12,
                vertical: AppDimens.p4,
              ),
              decoration: BoxDecoration(
                color: AppColors.paddle.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimens.r12),
                border: Border.all(color: AppColors.paddle.withValues(alpha: 0.5)),
              ),
              child: Text(
                AppStrings.formatHighScore(highScore),
                style: kTextStylePublicSans700.copyWith(
                  color: AppColors.paddle,
                  fontSize: AppDimens.p12 + 1,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimens.p8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.p32),
            child: Text(
              AppStrings.instructions,
              textAlign: TextAlign.center,
              style: kTextStylePublicSans400.copyWith(
                color: AppColors.textSecondary,
                fontSize: AppDimens.p12 + 2,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.p28),
          ElevatedButton(
            onPressed: game.startGame,
            child: const Text(AppStrings.startButton),
          ),
        ],
      ),
    );
  }
}
