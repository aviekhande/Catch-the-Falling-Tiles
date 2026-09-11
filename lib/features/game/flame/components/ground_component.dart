import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_colors.dart';

// Passive strip along the bottom edge; triggers a life loss when hit.
class GroundComponent extends RectangleComponent with CollisionCallbacks {
  GroundComponent({required double width, double? playHeight})
    : _playHeight = playHeight ?? GameConstants.playAreaSize.y,
      super(
        size: Vector2(width, GameConstants.groundHeight),
        paint: Paint()..color = AppColors.ground,
      );

  double _playHeight;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _reposition();
    add(RectangleHitbox(collisionType: CollisionType.passive));
  }

  void _reposition() {
    position = Vector2(
      0,
      _playHeight -
          GameConstants.groundHeight -
          GameConstants.groundBottomMargin,
    );
  }

  void updateBounds({required double width, required double playHeight}) {
    size.x = width;
    _playHeight = playHeight;
    _reposition();
  }
}
