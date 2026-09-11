import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../catch_the_falling_tiles_game.dart';

// Covers the arena so players can drag anywhere, not just on the paddle itself.
class DragZoneComponent extends PositionComponent
    with DragCallbacks, HasGameReference<CatchTheFallingTilesGame> {
  DragZoneComponent({required Vector2 size})
    : super(size: size, position: Vector2.zero());

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (game.phase != GamePhase.playing) {
      return;
    }
    game.movePaddleBy(event.localDelta.x);
  }
}
