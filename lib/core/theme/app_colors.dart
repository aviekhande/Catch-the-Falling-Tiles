import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const background = Color(0xFF0B0E17);
  static const playField = Color(0xFF141824);
  static const paddle = Color(0xFF4F8EF7);
  static const ground = Color(0xFF2A3048);

  static const scoreText = Color(0xFFF0F2FF);
  static const livesFull = Color(0xFFFF5F6D);
  static const livesEmpty = Color(0xFF2A3048);

  static const overlayScrim = Color(0xCC0B0E17);
  static const buttonPrimary = Color(0xFF4F8EF7);
  static const textPrimary = Color(0xFFF0F2FF);
  static const textSecondary = Color(0xFF8B90A0);

  /// Cycled through when spawning tiles so they're easy to tell apart.
  static const tileColors = <Color>[
    Color(0xFF26D98E),
    Color(0xFFFFC24B),
    Color(0xFFFF5F6D),
    Color(0xFF4F8EF7),
    Color(0xFFB07BFF),
  ];
}
