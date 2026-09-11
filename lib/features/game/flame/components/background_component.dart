import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class BackgroundComponent extends RectangleComponent {
  BackgroundComponent({required Vector2 size})
    : super(
        size: size,
        paint: Paint()..color = AppColors.playField,
      );
}
