import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../catch_the_falling_tiles_game.dart';
import 'crack_effect_component.dart';
import 'ground_component.dart';
import 'paddle_component.dart';

class TileComponent extends CircleComponent
    with CollisionCallbacks, HasGameReference<CatchTheFallingTilesGame> {
  TileComponent({
    required double radius,
    required this.fallSpeed,
    required Color color,
  }) : super(
         radius: radius,
         anchor: Anchor.center,
         paint: Paint()..color = color,
       );

  final double fallSpeed;

  // Prevent double-counting if paddle and ground trigger in the same frame.
  bool _resolved = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox(collisionType: CollisionType.active));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += fallSpeed * dt;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_resolved || isRemoving) {
      return;
    }

    if (other is PaddleComponent) {
      _resolved = true;
      game.onTileCaught();
      removeFromParent();
    } else if (other is GroundComponent) {
      _resolved = true;
      // Spawn crack/shatter visual effect at impact point
      final impactPoint = Vector2(position.x, other.position.y);
      game.world.add(
        CrackEffectComponent(
          impactPoint: impactPoint,
          tileColor: paint.color,
        ),
      );
      game.onTileMissed();
      removeFromParent();
    }
  }
}

