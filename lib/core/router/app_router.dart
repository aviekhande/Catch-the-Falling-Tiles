import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/game/presentation/screens/game_screen.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppRoutes {
  AppRoutes._();

  static const String game = '/';
  static const String gameName = 'game';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.game,
    routes: [
      GoRoute(
        path: AppRoutes.game,
        name: AppRoutes.gameName,
        builder: (context, state) => const GameScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.livesFull,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.errorPageTitle,
              style: kTextStylePublicSans700.copyWith(
                color: AppColors.textPrimary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.game),
              child: const Text(AppStrings.backToGame),
            ),
          ],
        ),
      ),
    ),
  );
}
