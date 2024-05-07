import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import '../flappy_dash_game.dart';

class ParallaxBackground extends ParallaxComponent<FlappyDash> {
  @override
  FutureOr<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData("background.png"),
      ],
      baseVelocity: Vector2(80, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
    return super.onLoad();
  }
}
