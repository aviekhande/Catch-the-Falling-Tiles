import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/game_constants.dart';

class _Shard {
  _Shard({
    required this.position,
    required this.velocity,
    required this.angularVelocity,
    required this.size,
    required this.color,
  });

  Vector2 position;
  Vector2 velocity;
  double angularVelocity;
  double rotation = 0;
  final double size;
  final Color color;
}

class CrackEffectComponent extends Component {
  CrackEffectComponent({
    required Vector2 impactPoint,
    required this.tileColor,
  }) : _impactPoint = impactPoint.clone();

  final Vector2 _impactPoint;
  final Color tileColor;
  final List<_Shard> _shards = [];
  final Random _random = Random();

  double _elapsed = 0.0;
  static const double _duration = GameConstants.crackEffectDuration;

  bool get isFinished => _elapsed >= _duration;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Generate radiating angular shards bursting upwards from the impact point
    for (int i = 0; i < GameConstants.crackShardCount; i++) {
      // Upward semi-circle angles (-pi to 0)
      final angle = -pi * 0.15 - (_random.nextDouble() * pi * 0.7);
      final speed = GameConstants.crackMinShardSpeed +
          _random.nextDouble() *
              (GameConstants.crackMaxShardSpeed -
                  GameConstants.crackMinShardSpeed);

      final velocity = Vector2(cos(angle) * speed, sin(angle) * speed);
      final shardSize = 3.5 + _random.nextDouble() * 5.5;

      _shards.add(
        _Shard(
          position: _impactPoint.clone(),
          velocity: velocity,
          angularVelocity: (_random.nextDouble() * 12) - 6,
          size: shardSize,
          color: _random.nextBool() ? tileColor : Colors.white.withValues(alpha: 0.9),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= _duration) {
      removeFromParent();
      return;
    }

    // Apply physics to shards: velocity, gravity, rotation
    const gravity = 350.0;
    for (final shard in _shards) {
      shard.position.x += shard.velocity.x * dt;
      shard.position.y += shard.velocity.y * dt;
      shard.velocity.y += gravity * dt;
      shard.rotation += shard.angularVelocity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final progress = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha = (1.0 - progress).clamp(0.0, 1.0);

    // 1. Draw impact crack flash and fracture lines along the ground
    final crackPaint = Paint()
      ..color = Colors.white.withValues(alpha: alpha * 0.8)
      ..strokeWidth = 2.0 * (1.0 - progress)
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(_impactPoint.x, _impactPoint.y);
    path.lineTo(_impactPoint.x - 14 * (1 - progress * 0.3), _impactPoint.y - 3);
    path.lineTo(_impactPoint.x - 22 * (1 - progress * 0.3), _impactPoint.y + 2);

    path.moveTo(_impactPoint.x, _impactPoint.y);
    path.lineTo(_impactPoint.x + 12 * (1 - progress * 0.3), _impactPoint.y - 4);
    path.lineTo(_impactPoint.x + 24 * (1 - progress * 0.3), _impactPoint.y + 1);

    canvas.drawPath(path, crackPaint);

    // 2. Draw sharp polygonal shards
    for (final shard in _shards) {
      final shardPaint = Paint()
        ..color = shard.color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(shard.position.x, shard.position.y);
      canvas.rotate(shard.rotation);

      // Draw sharp triangular shard
      final s = shard.size;
      final shardPath = Path()
        ..moveTo(0, -s)
        ..lineTo(s * 0.6, s)
        ..lineTo(-s * 0.6, s * 0.6)
        ..close();

      canvas.drawPath(shardPath, shardPaint);
      canvas.restore();
    }
  }
}
