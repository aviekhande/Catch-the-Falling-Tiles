import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../flame/catch_the_falling_tiles_game.dart';
import 'lives_indicator.dart';

class HudOverlay extends StatelessWidget {
  const HudOverlay({super.key, required this.game});

  final CatchTheFallingTilesGame game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.p20,
          vertical: AppDimens.p12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: game.score,
              builder: (context, score, _) => _Pill(
                child: Text(
                  AppStrings.formatScore(score),
                  style: kTextStylePublicSans700.copyWith(
                    color: AppColors.scoreText,
                    fontSize: AppDimens.p16,
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: game.lives,
              builder: (context, lives, _) => _Pill(
                child: LivesIndicator(lives: lives),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.p16,
        vertical: AppDimens.p8,
      ),
      decoration: BoxDecoration(
        color: AppColors.overlayScrim,
        borderRadius: BorderRadius.circular(AppDimens.r20),
      ),
      child: child,
    );
  }
}
