import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../flame/catch_the_falling_tiles_game.dart';

class StartOverlay extends StatelessWidget {
  const StartOverlay({super.key, required this.game});

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
