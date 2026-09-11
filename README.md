# Catch the Falling Tiles

A small [Flame](https://flame-engine.org) game built with Flutter for the
take-home spec: a fixed play area, a paddle you steer with drag or keyboard,
tiles that fall and must be caught, a score/lives HUD, and a game-over
screen.

## Running it

```bash
flutter pub get
flutter run
```

Works on mobile (drag to move the paddle) and desktop/web (drag, or use
`←`/`→` or `A`/`D`).

## Project structure

The folder layout follows production Flutter & Flame feature-first conventions (`core/` for shared constants & theming, `app/` for app bootstrapping, and `features/<name>/` split into `domain/`, `flame/`, and `presentation/`):

```
lib/
  main.dart                               Entry point (orientation & binding setup)
  app/
    app.dart                              MaterialApp root & ScreenUtil / ScreenUtilInit
  core/
    constants/
      app_strings.dart                    Centralized UI & system string constants
      game_constants.dart                 All tunable numbers (sizes, speeds, lives…)
    theme/
      app_colors.dart                     Shared palette
      app_dimens.dart                     AppDimens design dimensions, padding & radius
      app_text_styles.dart                PublicSans typography style constants
      app_theme.dart                      Centralized Material 3 dark ThemeData
  features/game/
    domain/
      models/
        game_phase.dart                   Game state enum (start, playing, gameOver)
        game_stats.dart                   Score and lives data model
    flame/
      catch_the_falling_tiles_game.dart   The FlameGame engine itself
      components/
        background_component.dart         Playfield background component
        ground_component.dart             Static "miss" strip, CollisionType.passive
        paddle_component.dart             Player-controlled basket, CollisionType.active
        tile_component.dart               Falling collectible, CollisionType.active
        drag_zone_component.dart          Full-area invisible drag surface
    presentation/
      screens/
        game_screen.dart                  Hosts GameWidget + overlay wiring
      widgets/
        start_overlay.dart                Start screen with instructions
        hud_overlay.dart                  In-game HUD (score & lives)
        game_over_overlay.dart            Game over dialog & restart button
        lives_indicator.dart              Heart slots indicator (full & empty)
test/
  game_smoke_test.dart                    Smoke test for start screen
  widget_test.dart                        App bootstrap, widgets & domain unit tests
```

## How the spec maps to Flame APIs

- **Fixed play area & background** — `CatchTheFallingTilesGame` sets
  `camera.viewfinder.visibleGameSize` to a constant `400 x 700` logical size
  in `onLoad()`. Whatever the physical screen size or aspect ratio, exactly
  that many game-units are always visible, so every component is positioned
  in a stable coordinate space. A `BackgroundComponent` (`RectangleComponent`)
  fills it.
- **Paddle input** — Rather than attaching `DragCallbacks` to the small
  paddle itself (which would force drags to start exactly on top of it), a
  transparent, full-area `DragZoneComponent` mixes in `DragCallbacks` and
  forwards `event.localDelta.x` to the paddle. This lets the player drag from
  anywhere on screen, which is the friendlier control scheme on mobile.
  Keyboard input (`←`/`→`, `A`/`D`) is handled via the `KeyboardEvents` mixin
  on the game itself, tracked as a set of currently-held keys and applied
  every frame in `update()`.
- **Spawning** — A `TimerComponent(period: 1.0, repeat: true, onTick: ...)`
  drives tile spawning, started in `startGame()` and stopped on game over.
  Tile radius and fall speed are randomized within a range, and fall speed
  ramps up slightly with score for a gentle difficulty curve.
- **Collision detection** — The game mixes in `HasCollisionDetection`. The
  paddle and tiles each get a hitbox (`RectangleHitbox` / `CircleHitbox`)
  registered as `CollisionType.active` since they move every frame; the
  ground strip along the bottom is `CollisionType.passive` since it never
  moves. `TileComponent.onCollisionStart` checks whether it hit the
  `PaddleComponent` (score++) or the `GroundComponent` (life--), then removes
  itself — no manual bounding-box math anywhere.
- **HUD & game-over** — Score and lives live on the game as
  `ValueNotifier<int>`, and the HUD/start/game-over screens are plain Flutter
  widgets registered through `GameWidget`'s `overlayBuilderMap` and toggled
  via Flame's `overlays.add/remove`. The HUD widgets use
  `ValueListenableBuilder` so they update reactively without any manual
  `setState` calls or a separate state-management layer.

## Design decisions & assumptions

- **Fixed logical resolution over "true" responsiveness.** A `400x700`
  virtual play area was chosen (portrait, phone-like proportions) since the
  spec asked for a "fixed play area." On very wide/short windows this will
  letterbox rather than stretch, which keeps gameplay fair across devices.
- **3 lives, 1 tile/sec, mild difficulty ramp.** Not specified, so I picked
  values that feel reasonable for a quick arcade session and put them all in
  `GameConstants` so they're easy to retune.
- **Drag-anywhere control** instead of drag-on-paddle-only. The spec just
  says "moves left-right via drag or keyboard input," and a full-width drag
  surface is the more common and forgiving pattern for this genre on touch
  devices.
- **No sound/asset pipeline.** Everything is drawn with simple Flame
  shapes (`RectangleComponent`, `CircleComponent`) rather than sprites, to
  keep the deliverable dependency-free and focused on structure/APIs rather
  than art.
- **Platform scaffolding reused.** The `android/` and `ios/` folders came
  from the existing reference project's scaffold (with the package name,
  bundle id, and app display name updated), rather than hand-writing a new
  Gradle/Xcode setup from scratch.
- **Not run through `flutter pub get` / `flutter build` here** — this
  environment doesn't have the Flutter SDK or `pub.dev` access, so the code
  is written and reviewed carefully against the actual Flame engine source
  (APIs for `TimerComponent`, `CollisionCallbacks`, `DragCallbacks`,
  `Viewfinder.visibleGameSize`, `KeyboardEvents`, etc. were all verified
  against the `flame-engine/flame` GitHub repo), but you'll want to run
  `flutter pub get` and give it a first build on your machine.
