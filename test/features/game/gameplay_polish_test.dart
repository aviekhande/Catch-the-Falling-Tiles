import 'package:catch_the_falling_tiles/core/constants/game_constants.dart';
import 'package:catch_the_falling_tiles/features/game/flame/components/crack_effect_component.dart';
import 'package:catch_the_falling_tiles/features/game/presentation/widgets/lives_indicator.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Gameplay Polish: CrackEffectComponent Tests', () {
    test('CrackEffectComponent spawns shards and finishes after duration', () async {
      final impactPoint = Vector2(200, 800);
      final crackEffect = CrackEffectComponent(
        impactPoint: impactPoint,
        tileColor: Colors.amber,
      );

      await crackEffect.onLoad();

      // At t=0, it should not be finished
      expect(crackEffect.isFinished, isFalse);

      // Simulate partial duration update
      crackEffect.update(0.1);
      expect(crackEffect.isFinished, isFalse);

      // Simulate full duration update
      crackEffect.update(GameConstants.crackEffectDuration);
      expect(crackEffect.isFinished, isTrue);
    });
  });

  group('Gameplay Polish: LivesIndicator Heart Blink Tests', () {
    testWidgets('LivesIndicator triggers animated heart when life is reduced', (
      tester,
    ) async {
      int lives = 3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    LivesIndicator(lives: lives, totalLives: 3),
                    ElevatedButton(
                      onPressed: () => setState(() => lives = 2),
                      child: const Text('Lose Life'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsNWidgets(3));

      // Tap to reduce life from 3 to 2
      await tester.tap(find.text('Lose Life'));
      await tester.pump();

      // Mid-animation frame: blinking/scaling is active
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.byIcon(Icons.favorite), findsNWidgets(3));

      // Complete the animation
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byIcon(Icons.favorite), findsNWidgets(3));
    });
  });
}
