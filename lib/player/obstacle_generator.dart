import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:get/get.dart';

import '../dash_game_controller.dart';
import '../flappy_dash_game.dart';

class ObstacleGenerator extends Component with HasGameReference<FlappyDash> {
  DashGameController dashGameController = Get.find();

  final intervalBetweenNextObstacle = 150.0;
  late Vector2 spawnPosition;
  final double spawnPositionOffset = 200;

  List<double> distanceBetweenTwoObstacle = [170.0, 180.0, 190.0, 200.0];
  late List<SpriteComponent> obstacles;

  @override
  FutureOr<void> onLoad() async {
    spawnPosition = Vector2(game.size.x + spawnPositionOffset, 0);

    obstacles = await generateObstacle();
    addAll(obstacles);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (dashGameController.gameState == GameState.GAME_STARTED) {
      for (var obstacle in obstacles) {
        obstacle.x -= intervalBetweenNextObstacle * dt;

        if (obstacle.x < -100) {
          removeFromParent();

          // Save user score progress
          dashGameController.userScore++;
          if (dashGameController.userScore >
              game.userPreferences.prefGetBestScore()) {
            game.userPreferences
                .prefSetBestScore(game.dashGameController.userScore.value);
          }
        }
      }
    } else if (dashGameController.gameState == GameState.GAME_OVER) {
      removeFromParent();
    }
    super.update(dt);
  }

  Future<List<SpriteComponent>> generateObstacle() async {
    List<SpriteComponent> obstacles = [];

    Vector2 spriteSize = Vector2(60, game.size.y / 2);
    double offset = Random().nextDouble() * 100;

    Sprite sprite = await Sprite.load("pipe-green.png");
    final topObstacle = SpriteComponent(sprite: sprite, size: spriteSize);
    topObstacle.position =
        Vector2(spawnPosition.x, (spriteSize.y / 1.5) + offset);
    topObstacle.angle = pi;
    topObstacle.add(RectangleHitbox());
    obstacles.add(topObstacle);

    final bottomObstacle = SpriteComponent(sprite: sprite, size: spriteSize);
    bottomObstacle.position = Vector2(
        topObstacle.x - spriteSize.x,
        topObstacle.position.y +
            distanceBetweenTwoObstacle[
                Random().nextInt(distanceBetweenTwoObstacle.length)] +
            offset);
    bottomObstacle.add(RectangleHitbox());
    obstacles.add(bottomObstacle);

    return obstacles;
  }
}
