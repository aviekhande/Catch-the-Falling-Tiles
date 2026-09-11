import 'package:flame/game.dart';

// Gameplay balance, speeds, and dimensions.
class GameConstants {
  GameConstants._();

  /// Logical width for the play area.
  static const double playAreaWidth = 400;

  /// Default logical height matching modern tall phone aspect ratios (e.g. 412x917).
  static const double defaultPlayAreaHeight = 890;

  /// The logical, device-independent play area size.
  static final Vector2 playAreaSize = Vector2(playAreaWidth, defaultPlayAreaHeight);

  /// Lives the player starts (and restarts) with.
  static const int startingLives = 3;

  // --- Paddle ---
  static const double paddleWidth = 90;
  static const double paddleHeight = 20;
  static const double paddleBottomMargin = 24;

  /// Paddle speed when driven by the keyboard, in game-units/second.
  static const double paddleKeyboardSpeed = 340;

  // --- Ground (the "miss" strip along the bottom of the play area) ---
  static const double groundHeight = 6;
  static const double groundBottomMargin = 0;

  // --- Tile spawner ---
  /// Average time between tile spawns, in seconds.
  static const double tileSpawnInterval = 1.0;

  static const double tileMinRadius = 14;
  static const double tileMaxRadius = 22;

  /// Base fall speed range, in game-units/second.
  static const double tileMinFallSpeed = 90;
  static const double tileMaxFallSpeed = 150;

  /// Small difficulty ramp: every point of score nudges fall speed up a
  /// little, capped so the game never becomes unfair.
  static const double speedRampPerPoint = 4;
  static const double maxSpeedRampBonus = 160;
}
