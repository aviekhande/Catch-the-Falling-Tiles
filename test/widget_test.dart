import 'package:catch_the_falling_tiles/app.dart';
import 'package:catch_the_falling_tiles/core/constants/app_strings.dart';
import 'package:catch_the_falling_tiles/core/constants/game_constants.dart';
import 'package:catch_the_falling_tiles/core/theme/app_dimens.dart';
import 'package:catch_the_falling_tiles/core/theme/app_text_styles.dart';
import 'package:catch_the_falling_tiles/features/game/domain/models/game_phase.dart';
import 'package:catch_the_falling_tiles/features/game/domain/models/game_stats.dart';
import 'package:catch_the_falling_tiles/features/game/flame/components/ground_component.dart';
import 'package:catch_the_falling_tiles/features/game/flame/components/paddle_component.dart';
import 'package:catch_the_falling_tiles/features/game/presentation/widgets/lives_indicator.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App & Widget Tests', () {
    testWidgets('boots CatchTheFallingTilesApp and loads home screen', (
      tester,
    ) async {
      await tester.pumpWidget(const CatchTheFallingTilesApp());

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text(AppStrings.appTitle), findsOneWidget);
    });

    testWidgets('LivesIndicator renders total lives correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LivesIndicator(lives: 2, totalLives: 3),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsNWidgets(3));
    });
  });

  group('Domain Model Tests', () {
    test('GameStats initial state has 0 score and 3 starting lives', () {
      final stats = GameStats.initial();
      expect(stats.score, 0);
      expect(stats.lives, 3);
      expect(stats.isGameOver, isFalse);
      expect(stats.hasFullHealth, isTrue);
    });

    test('GameStats copyWith updates properties immutably', () {
      final initial = GameStats.initial();
      final updated = initial.copyWith(score: 5, lives: 1);

      expect(updated.score, 5);
      expect(updated.lives, 1);
      expect(updated.isGameOver, isFalse);
      expect(updated.hasFullHealth, isFalse);

      final gameOver = updated.copyWith(lives: 0);
      expect(gameOver.isGameOver, isTrue);
    });

    test('GamePhase contains all expected enum states', () {
      expect(GamePhase.values, containsAll([
        GamePhase.start,
        GamePhase.playing,
        GamePhase.gameOver,
      ]));
    });
  });

  group('AppStrings Tests', () {
    test('formatScore formats correctly', () {
      expect(AppStrings.formatScore(12), 'Score: 12');
    });

    test('formatFinalScore formats correctly', () {
      expect(AppStrings.formatFinalScore(42), 'Final score: 42');
    });
  });

  group('AppTextStyles Tests', () {
    test('PublicSans text styles have expected font families', () {
      expect(kTextStylePublicSans300.fontFamily, 'PublicSans-Light');
      expect(kTextStylePublicSans400.fontFamily, 'PublicSans-Regular');
      expect(kTextStylePublicSans500.fontFamily, 'PublicSans-Medium');
      expect(kTextStylePublicSans600.fontFamily, 'PublicSans-SemiBold');
      expect(kTextStylePublicSans700.fontFamily, 'PublicSans-Bold');
      expect(kTextStylePublicSans800.fontFamily, 'PublicSans-ExtraBold');
      expect(kTextStylePublicSans900.fontFamily, 'PublicSans-Black');
    });
  });

  group('AppDimens & ScreenUtil Tests', () {
    test('AppDimens contains expected design values', () {
      expect(AppDimens.appDesignHeight, 917);
      expect(AppDimens.appDesignWidth, 412);
      expect(AppDimens.p4, 4);
      expect(AppDimens.p8, 8);
      expect(AppDimens.p12, 12);
      expect(AppDimens.p16, 16);
      expect(AppDimens.p20, 20);
      expect(AppDimens.p24, 24);
      expect(AppDimens.p28, 28);
      expect(AppDimens.p32, 32);
      expect(AppDimens.p40, 40);
      expect(AppDimens.p48, 48);
      expect(AppDimens.r8, 8);
      expect(AppDimens.r12, 12);
      expect(AppDimens.r16, 16);
      expect(AppDimens.r20, 20);
      expect(AppDimens.iconSm, 18);
      expect(AppDimens.iconMd, 24);
      expect(AppDimens.iconLg, 32);
      expect(AppDimens.buttonHeight, 54);
      expect(AppDimens.buttonRadius, 14);
    });

    test('ScreenUtils extensions calculate responsive values without crashing', () {
      expect(10.w, isA<double>());
      expect(10.h, isA<double>());
      expect(10.r, isA<double>());
      expect(10.sp, isA<double>());
    });

    testWidgets('ScreenUtilInit wraps and initializes child correctly', (tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          builder: (context, child) => const Directionality(
            textDirection: TextDirection.ltr,
            child: Text('ScreenUtil Loaded'),
          ),
        ),
      );

      expect(find.text('ScreenUtil Loaded'), findsOneWidget);
      expect(10.w, greaterThan(0));
    });
  });

  group('Game Layout & Ground Positioning Tests', () {
    test('GroundComponent aligns flush at bottom based on playHeight and groundBottomMargin', () async {
      final ground = GroundComponent(width: 400, playHeight: 890);
      await ground.onLoad();

      expect(
        ground.position.y,
        890 - GameConstants.groundHeight - GameConstants.groundBottomMargin,
      );
      expect(ground.size.x, 400);
      expect(ground.size.y, GameConstants.groundHeight);

      ground.updateBounds(width: 450, playHeight: 950);
      expect(
        ground.position.y,
        950 - GameConstants.groundHeight - GameConstants.groundBottomMargin,
      );
      expect(ground.size.x, 450);
    });

    test('PaddleComponent positions above the ground with paddleBottomMargin', () async {
      final paddle = PaddleComponent(playAreaSize: Vector2(400, 890));
      await paddle.onLoad();

      expect(
        paddle.position.y,
        890 - GameConstants.paddleBottomMargin - GameConstants.paddleHeight,
      );
      expect(paddle.position.x, (400 - GameConstants.paddleWidth) / 2);
    });
  });
}
