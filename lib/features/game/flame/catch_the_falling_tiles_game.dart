import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color, KeyEventResult;
import 'package:flutter/services.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/di/injector.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/entities/game_phase.dart';
import 'components/background_component.dart';
import 'components/drag_zone_component.dart';
import 'components/ground_component.dart';
import 'components/paddle_component.dart';
import 'components/tile_component.dart';

export '../domain/entities/game_phase.dart';

class CatchTheFallingTilesGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents {
  CatchTheFallingTilesGame({
    AudioService? audioService,
    this.onGameStarted,
    this.onScoreChanged,
    this.onLivesChanged,
    this.onGameOverCallback,
  }) : audioService = audioService ?? (sl.isRegistered<AudioService>() ? sl<AudioService>() : null);

  static const String overlayStart = AppStrings.overlayStart;
  static const String overlayHud = AppStrings.overlayHud;
  static const String overlayGameOver = AppStrings.overlayGameOver;

  final AudioService? audioService;
  final VoidCallback? onGameStarted;
  final void Function(int newScore)? onScoreChanged;
  final void Function(int remainingLives)? onLivesChanged;
  final void Function(int finalScore)? onGameOverCallback;

  // Notifiers let Flutter overlays rebuild directly without extra state management.
  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final ValueNotifier<int> lives = ValueNotifier<int>(
    GameConstants.startingLives,
  );

  GamePhase phase = GamePhase.start;

  final Random _random = Random();
  final Set<LogicalKeyboardKey> _keysDown = {};

  late BackgroundComponent _background;
  late GroundComponent _ground;
  late DragZoneComponent _dragZone;
  late PaddleComponent _paddle;
  TimerComponent? _spawner;

  late Vector2 _playAreaSize;
  Vector2 get playAreaSize => _playAreaSize;

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _updatePlayAreaSize(size);

    camera.viewfinder
      ..anchor = Anchor.topLeft
      ..position = Vector2.zero()
      ..visibleGameSize = _playAreaSize;

    _background = BackgroundComponent(size: _playAreaSize);
    _ground = GroundComponent(
      width: _playAreaSize.x,
      playHeight: _playAreaSize.y,
    );
    _dragZone = DragZoneComponent(size: _playAreaSize);
    _paddle = PaddleComponent(playAreaSize: _playAreaSize);

    world.addAll([
      _background,
      _ground,
      _dragZone,
      _paddle,
    ]);

    overlays.add(overlayStart);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (!isLoaded) {
      return;
    }
    _updatePlayAreaSize(size);
    _syncComponentsToPlayArea();
  }

  void _updatePlayAreaSize(Vector2 viewportSize) {
    if (viewportSize.x <= 0 || viewportSize.y <= 0) {
      _playAreaSize = GameConstants.playAreaSize.clone();
      return;
    }
    final dynamicHeight =
        GameConstants.playAreaWidth * (viewportSize.y / viewportSize.x);
    final height = max(700.0, dynamicHeight);
    _playAreaSize = Vector2(GameConstants.playAreaWidth, height);
  }

  void _syncComponentsToPlayArea() {
    camera.viewfinder.visibleGameSize = _playAreaSize;
    _background.size = _playAreaSize.clone();
    _dragZone.size = _playAreaSize.clone();
    _ground.updateBounds(
      width: _playAreaSize.x,
      playHeight: _playAreaSize.y,
    );
    _paddle.updateBounds(_playAreaSize);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (phase == GamePhase.playing) {
      _applyKeyboardMovement(dt);
    }
  }

  void _applyKeyboardMovement(double dt) {
    var dx = 0.0;
    if (_keysDown.contains(LogicalKeyboardKey.arrowLeft) ||
        _keysDown.contains(LogicalKeyboardKey.keyA)) {
      dx -= GameConstants.paddleKeyboardSpeed * dt;
    }
    if (_keysDown.contains(LogicalKeyboardKey.arrowRight) ||
        _keysDown.contains(LogicalKeyboardKey.keyD)) {
      dx += GameConstants.paddleKeyboardSpeed * dt;
    }
    if (dx != 0) {
      _paddle.moveBy(dx);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _keysDown
      ..clear()
      ..addAll(keysPressed);
    return KeyEventResult.handled;
  }

  void movePaddleBy(double dx) => _paddle.moveBy(dx);

  // Resets score, lives, clears remaining tiles, and kicks off spawner.
  void startGame() {
    _keysDown.clear();
    score.value = 0;
    lives.value = GameConstants.startingLives;
    phase = GamePhase.playing;

    _clearTiles();
    _paddle.resetPosition();

    _spawner?.removeFromParent();
    final spawner = TimerComponent(
      period: GameConstants.tileSpawnInterval,
      repeat: true,
      onTick: _spawnTile,
    );
    _spawner = spawner;
    world.add(spawner);

    overlays
      ..remove(overlayStart)
      ..remove(overlayGameOver)
      ..add(overlayHud);

    onGameStarted?.call();
  }

  void _spawnTile() {
    final radius =
        GameConstants.tileMinRadius +
        _random.nextDouble() *
            (GameConstants.tileMaxRadius - GameConstants.tileMinRadius);
    final x =
        radius +
        _random.nextDouble() * (_playAreaSize.x - 2 * radius);

    final speedRamp = min(
      GameConstants.maxSpeedRampBonus,
      score.value * GameConstants.speedRampPerPoint,
    );
    final fallSpeed =
        GameConstants.tileMinFallSpeed +
        _random.nextDouble() *
            (GameConstants.tileMaxFallSpeed - GameConstants.tileMinFallSpeed) +
        speedRamp;

    final color =
        AppColors.tileColors[_random.nextInt(AppColors.tileColors.length)];

    world.add(
      TileComponent(radius: radius, fallSpeed: fallSpeed, color: color)
        ..position = Vector2(x, -radius),
    );
  }

  void onTileCaught() {
    score.value += 1;
    audioService?.playCatch();
    onScoreChanged?.call(score.value);
  }

  void onTileMissed() {
    lives.value -= 1;
    audioService?.playMiss();
    onLivesChanged?.call(lives.value);
    if (lives.value <= 0) {
      _endGame();
    } else {
      audioService?.playLifeLost();
    }
  }

  void _endGame() {
    phase = GamePhase.gameOver;
    _keysDown.clear();
    _spawner?.timer.stop();
    _clearTiles();
    audioService?.playGameOver();
    onGameOverCallback?.call(score.value);
    overlays
      ..remove(overlayHud)
      ..add(overlayGameOver);
  }


  void _clearTiles() {
    world.children.whereType<TileComponent>().toList().forEach(
      (tile) => tile.removeFromParent(),
    );
  }

  @override
  void onRemove() {
    _keysDown.clear();
    _spawner?.removeFromParent();
    score.dispose();
    lives.dispose();
    super.onRemove();
  }
}
