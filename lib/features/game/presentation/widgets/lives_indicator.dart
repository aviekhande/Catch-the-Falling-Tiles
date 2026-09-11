import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';

class LivesIndicator extends StatelessWidget {
  const LivesIndicator({
    super.key,
    required this.lives,
    this.totalLives = GameConstants.startingLives,
    this.size = AppDimens.iconSm,
  });

  final int lives;
  final int totalLives;
  final double size;

  @override
  Widget build(BuildContext context) {
    final currentLives = lives.clamp(0, totalLives);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalLives,
        (index) {
          final isFull = index < currentLives;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.p4 / 2),
            child: Icon(
              Icons.favorite,
              color: isFull ? AppColors.livesFull : AppColors.livesEmpty,
              size: size,
            ),
          );
        },
      ),
    );
  }
}
