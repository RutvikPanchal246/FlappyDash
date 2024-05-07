import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../flappy_dash_game.dart';

class BasePlatform extends PositionComponent with HasGameReference<FlappyDash> {

  BasePlatform({required this.platformPosition});

  final Vector2 platformPosition;

  @override
  FutureOr<void> onLoad() {
    size = Vector2(game.size.x, 20);
    position = platformPosition;

    add(RectangleHitbox());
    return super.onLoad();
  }

}