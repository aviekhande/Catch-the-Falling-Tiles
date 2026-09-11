import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/theme/app_colors.dart';

class PaddleComponent extends RectangleComponent with CollisionCallbacks {
  PaddleComponent({Vector2? playAreaSize})
    : _playAreaSize = playAreaSize ?? GameConstants.playAreaSize.clone(),
      super(
        size: Vector2(GameConstants.paddleWidth, GameConstants.paddleHeight),
        anchor: Anchor.topLeft,
        paint: Paint()..color = AppColors.paddle,
      );

  Vector2 _playAreaSize;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.active));
    resetPosition();
  }

  void resetPosition() {
    final playWidth = _playAreaSize.x;
    position = Vector2(
      (playWidth - size.x) / 2,
      _playAreaSize.y -
          GameConstants.paddleBottomMargin -
          size.y,
    );
  }

  void updateBounds(Vector2 playAreaSize) {
    _playAreaSize = playAreaSize.clone();
    position.x = position.x.clamp(0.0, _playAreaSize.x - size.x);
    position.y =
        _playAreaSize.y - GameConstants.paddleBottomMargin - size.y;
  }

  // Clamps horizontal movement within the play area.
  void moveBy(double dx) {
    final playWidth = _playAreaSize.x;
    position.x = (position.x + dx).clamp(0.0, playWidth - size.x);
  }
}
